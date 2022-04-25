from django.shortcuts import get_object_or_404
from requests import request
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from votiface_django import firebase

class UserRecordView(APIView):
  def post(self, request):
    user = (get_token(request.data['email'],request.data['password']))
    if (user is not False):
      return Response(user , status = status.HTTP_202_ACCEPTED)
    else:
      return Response(status = status.HTTP_401_UNAUTHORIZED)

class UserDataView(APIView):
  def post(self, request):
    id = request.data['idToken']
    user = firebase.auth.get_account_info(id)
    user = user['users']
    user = user[0]
    user = str(user['localId'])
    data = firebase.db.child("Users").child(user).get()
    return Response(data.val(), status = status.HTTP_202_ACCEPTED)


class UserImageView(APIView):
  def post(self, request):
    id = request.data['idToken']
    user = firebase.auth.get_account_info(id)
    user = user['users']
    user = user[0]
    user = str(user['localId'])
    img = firebase.storage.child("profile-images/"+user+".jpeg").put('C:/Users/biraj/Desktop/yom3AXElP2QFIMqXOTXiR2Zlz7S2.jpeg', id)
    img_url = firebase.storage.child("profile-images/yom3AXElP2QFIMqXOTXiR2Zlz7S2.jpeg").get_url(img['downloadTokens'])
    firebase.db.child("Users").child(user).child("profile_img").set(img_url,id)
    print(img_url)
    return Response(status = status.HTTP_202_ACCEPTED)


def get_token(email , password):
  try:
    user = firebase.auth.sign_in_with_email_and_password(email , password)
    return {'idToken': user['idToken']}
  except:
    return False
