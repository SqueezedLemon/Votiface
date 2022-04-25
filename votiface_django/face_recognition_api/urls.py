from django.urls import path

from .views import GetEncode,CheckFace

app_name='face_recognition_api'
urlpatterns = [
    path('get_encode/', GetEncode.as_view(), name='encode'),
    path('check_face/', CheckFace.as_view(), name='check_face'),
]