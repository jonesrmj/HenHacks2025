import os
import json
import time
import requests
import hashlib
import string
import markdown
from django.http import HttpResponse
from dotenv import load_dotenv
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from django.views.decorators.csrf import csrf_exempt
from zxcvbn import zxcvbn

load_dotenv()    
api_key = os.getenv("API_KEY")
# Corrected SCOPES with proper URLs
SCOPES = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/generative-language.tuning']

# Define the client secrets file relative to the current directory
def get_oauth_file_path():
    base_dir = os.path.dirname(os.path.abspath(__file__))  # Get the absolute path of the current script
    CLIENT_SECRETS_FILE = os.path.join(base_dir, "../../client_secret_468832922922-o6a05v6eg1r3jmq9dp4c8940r5d53tke.apps.googleusercontent.com.json")
    
    if os.path.exists(CLIENT_SECRETS_FILE):
        print(f"File found: {CLIENT_SECRETS_FILE}")
        return CLIENT_SECRETS_FILE
    else:
        print(f"File not found: {CLIENT_SECRETS_FILE}")
        return None

# Updated get_oauth_token function with exception handling
def get_oauth_token():
    credentials = None
    credentials_data = None
    CLIENT_SECRETS_FILE = get_oauth_file_path()

    if CLIENT_SECRETS_FILE is None:
        return "Error: Client secret file not found."

    # Check if the token file already exists
    if os.path.exists('token.json'):
        with open('token.json', 'r') as token:
            try:
                credentials_data = json.load(token)  # Load credentials as a dictionary
            except json.JSONDecodeError:
                return "Error: Invalid token format."
            
        # Attempt to create credentials from the loaded data
        try:
            credentials = Credentials.from_authorized_user_info(info=credentials_data)
        except ValueError as e:
            print(f"Error loading credentials: {e}")
            credentials = None  # Set to None to trigger re-authentication

    # If no valid credentials or they are expired, run OAuth flow
    if not credentials or (credentials.expiry and credentials.expiry.timestamp() <= time.time()):
        flow = InstalledAppFlow.from_client_secrets_file(
            CLIENT_SECRETS_FILE, SCOPES)
        credentials = flow.run_local_server(port=8080)

        # Save the new credentials for the next run
        with open('token.json', 'w') as token:
            token.write(credentials.to_json())

    return credentials.token

# Define the improvePasswordSecurity function
def geminiAdvice(password):
    oauth_token = get_oauth_token()

    if oauth_token.startswith("Error"):
        return oauth_token

    # Prepare the headers for the request
    headers = {
        "Authorization": f"Bearer {oauth_token}",  # Use OAuth 2.0 token here
        "Content-Type": "application/json"
    }

    # Prepare the payload with the password in a prompt
    prompt = f"Suggest ways to improve the security of the password: {password}"
    payload = {
        "contents": [
            {
                "role": "user",
                "parts": [
                    {
                        "text": prompt
                    }
                ]
            }
        ]
    }

    # URL for Gemini API (using gemini-1.5-flash model)
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    # Make the request to the Gemini API
    response = requests.post(url, json=payload, headers=headers)
    print(response.status_code)

    # Handle the response from the Gemini API
    if response.status_code == 200:
        # Extract the suggestions from the response
        try:
            suggestions = response.json()['candidates'][0]['content']['parts'][0]['text']
            return markdown.markdown(suggestions)
        except (KeyError, IndexError):
            return "Error: Unable to parse suggestions from Gemini API response."
    else:
        return f"Error: Unable to reach Gemini API. Status code: {response.status_code}, Response: {response.text}"
    
def checkBreachs(password):
    # Hash the password using SHA-1
    sha1_hash = hashlib.sha1(password.encode()).hexdigest().upper()
    prefix, suffix = sha1_hash[:5], sha1_hash[5:]

    # Make API request to HIBP
    url = f"https://api.pwnedpasswords.com/range/{prefix}"
    headers = {"User-Agent": "PassMate-1.0"}  # Set a valid User-Agent
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        # Check if the suffix exists in the API response
        hashes = response.text.splitlines()
        for h in hashes:
            parts = h.split(":")
            if len(parts) == 2:
                h_suffix, count = parts
                if h_suffix == suffix:
                    return f"Password found {count} times in data breaches! Consider changing it."
        return "Password not found in known breaches. (Still use strong passwords!)"
    else:
        return f"Error: Unable to reach API. Status code: {response.status_code}"

def getFilePath():
    base_dir = os.path.dirname(os.path.abspath(__file__))  # Get the absolute path of the current script
    CLIENT_SECRETS_FILE = os.path.join(base_dir, "../../client_secret_468832922922-o6a05v6eg1r3jmq9dp4c8940r5d53tke.apps.googleusercontent.com.json")

    # Check if the file exists
    if os.path.exists(CLIENT_SECRETS_FILE):
        print(f"File found: {CLIENT_SECRETS_FILE}")
    else:
        print(f"File not found: {CLIENT_SECRETS_FILE}")

def has_uppercase(input_string):
    for char in input_string:
        if char.isupper():
            return True
    return False

def has_special_characters(text):
    for char in text:
        if not char.isdigit() and char not in string.whitespace:
            return True
    return False

def has_numbers(input_string):
    return any(char.isdigit() for char in input_string)
        
@csrf_exempt
def call_handler(request):
    if request.method == "POST":
        password = json.loads(request.body)["password"]

        analysis = zxcvbn(password)
        # Make API calls here
        return HttpResponse(json.dumps({
            "strengh": f"It would take hackers {analysis['crack_times_display']['offline_slow_hashing_1e4_per_second']} to crack your password.",
            "breaches": checkBreachs(password),
            "AI": f"Advice from Google Gemini\n {geminiAdvice(password)} (not working rn)",
            "best_practices": {
                "12Char": True,
                "UpChar": has_uppercase(password),
                "SpecChar": has_special_characters(password),
                "Num": has_numbers(password)
            }
        }))
    else:
        return HttpResponse("Not a POST Request")

@csrf_exempt
def dummy_data(request):
    if request.method == "POST":
        return HttpResponse(json.dumps({
            "strengh": "It would take 21 hours to crack this password (Dummy Data)",
            "breaches": "This password has been in 50 breaches (Dummy Data)",
            "AI": "To Improve this pass you could... (Dummy Data)"
        }))
    else:
        return HttpResponse("Not a POST Request (dummy)")