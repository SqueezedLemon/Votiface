import cv2
from django.shortcuts import get_object_or_404
from requests import request
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from votiface_django import firebase
from .checkfaces import findEncoding, comparison
import numpy as np

class GetEncode(APIView):
  def post(self, request):
    img = cv2.imdecode(np.fromstring(request.data['profileImage'].read(), np.uint8), cv2.IMREAD_UNCHANGED)
    encode = findEncoding(img)
    data = {'encode': encode}
    return Response(data, status = status.HTTP_202_ACCEPTED)

class CheckFace(APIView):
  def post(self, request):
    img = cv2.imdecode(np.fromstring(request.data['inputImage'].read(), np.uint8), cv2.IMREAD_UNCHANGED)
    input_encode = findEncoding(img)
    id = request.data['idToken']
    user = firebase.auth.get_account_info(id)
    user = user['users']
    user = user[0]
    user = str(user['localId'])
    data = firebase.db.child("Users").child(user).child("Encode").get(id).val()
    faceId = comparison(data, input_encode)
    serializer = {'faceID': faceId}
    return Response(serializer, status = status.HTTP_202_ACCEPTED)