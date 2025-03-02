import json
import os
import hashlib
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from dotenv import load_dotenv


load_dotenv()    
api_key = os.getenv("API_KEY")
m = mellt.Mellt()

@csrf_exempt
def call_handler(request):
    if request.method == "POST":
        password = request.POST.get["password"]
        #make api calls here

        #return HttpResponse(json.dumps({"password": password}))
        return HttpResponse(json.dumps({"strengh":"It would take 21 hours to crack this password (Dummy Data)", "breaches": "This password has been in 50 breaches (Dummy Data)", "AI": "To Improve this pass you could... (Dummy Data)"}))
    else:
        return HttpResponse("Not a POST Request")

@csrf_exempt
def dummy_data(request):
    if request.method == "POST":
        return HttpResponse(json.dumps({"strengh":"It would take 21 hours to crack this password (Dummy Data)", "breaches": "This password has been in 50 breaches (Dummy Data)", "AI": "To Improve this pass you could... (Dummy Data)"}))
    else:
        return HttpResponse("Not a POST Request")
