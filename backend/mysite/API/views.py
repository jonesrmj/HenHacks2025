from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
import json
from dotenv import load_dotenv
import os
import hashlib

# Create your views here.
load_dotenv()    
api_key = os.getenv("API_KEY")

@csrf_exempt
def CallHandler(request):
    if request.method == "POST":
        print(request.POST)
        #password = request.POST.get["password"]
        #make api calls here

        #return HttpResponse(json.dumps({"password": password}))
        return HttpResponse(json.dumps{"it works"})
    else:
        return HttpResponse("Not a POST Request")


