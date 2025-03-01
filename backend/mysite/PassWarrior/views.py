import requests
from django.shortcuts import render
from django.http import HttpResponse
from dotenv import load_dotenv
import os
# Create your views here.

load_dotenv()    
api_key = os.getenv("API_KEY")


def index(request):
    return HttpResponse("Hello, world. You're at the password page.")

def display(request):
    x = requests.get("https://haveibeenpwned.com/api/v3/breachedaccount/io311@comcast.net", headers = {"user-agent": "PassWarrior", "hibp-api-key": api_key})
    print(x.text)
    return render(request, "Passwarrior.html")
    
