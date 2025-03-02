from django.shortcuts import render
from django.http import HttpResponse
import json

# Create your views here.

def CallHandler(request):
    if request.method == "POST":
        password = request.POST.get["password"]
        #make api calls here

        return HttpResponse(json.dumps({"password": password}))
    else:
        return HttpResponse("Not a POST Request")


