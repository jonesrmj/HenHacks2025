from django.shortcuts import render
from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, world. You're at the password page.")

def display(request):
    #password = "123456"
    #print(checkPassword(password))
    #print(improvePasswordSecurity(password))
    return render(request, "Passwarrior.html")