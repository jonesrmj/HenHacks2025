import requests
from django.shortcuts import render
from django.http import HttpResponse
from dotenv import load_dotenv
import os
import hashlib
# Create your views here.

load_dotenv()    
api_key = os.getenv("API_KEY")


def index(request):
    return HttpResponse("Hello, world. You're at the password page.")

def display(request):
    #x = requests.get("https://haveibeenpwned.com/api/v3/breachedaccount/io311@comcast.net", headers = {"user-agent": "PassWarrior", "hibp-api-key": api_key})
    #print(x.text)
    print(checkPassword("123456"))
    return render(request, "Passwarrior.html")
    
def checkPassword(password):
    # Step 1: Hash the password using SHA-1
    sha1_hash = hashlib.sha1(password.encode()).hexdigest().upper()
    prefix, suffix = sha1_hash[:5], sha1_hash[5:]

    # Step 2: Make API request to Pwned Passwords
    url = f"https://api.pwnedpasswords.com/range/{prefix}"
    headers = {"User-Agent": "PassMate-1.0"}  # Set a valid User-Agent
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        # Step 3: Check if the suffix exists in the API response
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


