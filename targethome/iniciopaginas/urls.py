from django.urls import path
from iniciopaginas.views import (
		HomeView,
	)


app_name = 'iniciopaginas'

urlpatterns = [
	path('', HomeView.as_view(), name='home')
]