from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('account-api/', include('account_api.urls', namespace='account')),
    path('face-recognition/', include('face_recognition_api.urls', namespace='face_recognition')),
]
