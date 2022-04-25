from django.urls import path

from .views import UserRecordView, UserDataView, UserImageView

app_name='accounts_api'
urlpatterns = [
    path('user/get_token/', UserRecordView.as_view(), name='user'),
    path('user/get_user_info/', UserDataView.as_view(), name='info'),
    path('user/get_user_image/', UserImageView.as_view(), name='image'),
]