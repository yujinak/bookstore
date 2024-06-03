from django.urls import path, include
from rest_framework import routers

from order import viewsets

router = routers.SimpleRouter()
router.register(r'order', viewsets.OrderViewSet, basename='order') # se refere ao subdominio site.com/order

urlpatterns = [
    path('', include(router.urls))
]