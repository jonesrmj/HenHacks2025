from django.shortcuts import render

# Create your views here.

def CallHandler(request):
    if request.method == "POST":
        password = request.POST.get["password"]
        #make api calls here


