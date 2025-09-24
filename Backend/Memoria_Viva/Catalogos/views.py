from rest_framework import generics
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from .models import Rol, Localizacion, Categoria
from .serializers import RolSerializer, LocalizacionSerializer, CategoriaSerializer

# CRUD para Roles
class RolListCreateView(generics.ListCreateAPIView):
    queryset = Rol.objects.all()
    serializer_class = RolSerializer

    @swagger_auto_schema(
        operation_description="Lista todos los roles o crea uno nuevo.",
        tags=["Catálogos"],
        request_body=RolSerializer,
        responses={
            201: openapi.Response("Rol creado", RolSerializer),
            400: "Datos inválidos o faltantes"
        }
    )
    def post(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)


# CRUD para Rol: Retrieve, Update, Destroy
class RolRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Rol.objects.all()
    serializer_class = RolSerializer

    @swagger_auto_schema(
        operation_description="Obtiene el detalle de un rol por ID.",
        tags=["Catálogos"],
        responses={
            200: openapi.Response("Detalle de rol", RolSerializer),
            404: "Rol no encontrado"
        }
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Actualiza un rol por ID.",
        tags=["Catálogos"],
        request_body=RolSerializer,
        responses={
            200: openapi.Response("Rol actualizado", RolSerializer),
            400: "Datos inválidos",
            404: "Rol no encontrado"
        }
    )
    def put(self, request, *args, **kwargs):
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Elimina un rol por ID.",
        tags=["Catálogos"],
        responses={
            204: "Rol eliminado",
            404: "Rol no encontrado"
        }
    )
    def delete(self, request, *args, **kwargs):
        return super().destroy(request, *args, **kwargs)

# CRUD para Localizaciones
class LocalizacionListCreateView(generics.ListCreateAPIView):
    queryset = Localizacion.objects.all()
    serializer_class = LocalizacionSerializer

    @swagger_auto_schema(
        operation_description="Lista todas las localizaciones o crea una nueva.",
        tags=["Catálogos"],
        request_body=LocalizacionSerializer,
        responses={
            201: openapi.Response("Localización creada", LocalizacionSerializer),
            400: "Datos inválidos o faltantes"
        }
    )
    def post(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)


# CRUD para Localizacion: Retrieve, Update, Destroy
class LocalizacionRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Localizacion.objects.all()
    serializer_class = LocalizacionSerializer

    @swagger_auto_schema(
        operation_description="Obtiene el detalle de una localización por ID.",
        tags=["Catálogos"],
        responses={
            200: openapi.Response("Detalle de localización", LocalizacionSerializer),
            404: "Localización no encontrada"
        }
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Actualiza una localización por ID.",
        tags=["Catálogos"],
        request_body=LocalizacionSerializer,
        responses={
            200: openapi.Response("Localización actualizada", LocalizacionSerializer),
            400: "Datos inválidos",
            404: "Localización no encontrada"
        }
    )
    def put(self, request, *args, **kwargs):
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Elimina una localización por ID.",
        tags=["Catálogos"],
        responses={
            204: "Localización eliminada",
            404: "Localización no encontrada"
        }
    )
    def delete(self, request, *args, **kwargs):
        return super().destroy(request, *args, **kwargs)

# CRUD para Categorias
class CategoriaListCreateView(generics.ListCreateAPIView):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

    @swagger_auto_schema(
        operation_description="Lista todas las categorías o crea una nueva.",
        tags=["Catálogos"],
        request_body=CategoriaSerializer,
        responses={
            201: openapi.Response("Categoría creada", CategoriaSerializer),
            400: "Datos inválidos o faltantes"
        }
    )
    def post(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)


# CRUD para Categoria: Retrieve, Update, Destroy
class CategoriaRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

    @swagger_auto_schema(
        operation_description="Obtiene el detalle de una categoría por ID.",
        tags=["Catálogos"],
        responses={
            200: openapi.Response("Detalle de categoría", CategoriaSerializer),
            404: "Categoría no encontrada"
        }
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Actualiza una categoría por ID.",
        tags=["Catálogos"],
        request_body=CategoriaSerializer,
        responses={
            200: openapi.Response("Categoría actualizada", CategoriaSerializer),
            400: "Datos inválidos",
            404: "Categoría no encontrada"
        }
    )
    def put(self, request, *args, **kwargs):
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Elimina una categoría por ID.",
        tags=["Catálogos"],
        responses={
            204: "Categoría eliminada",
            404: "Categoría no encontrada"
        }
    )
    def delete(self, request, *args, **kwargs):
        return super().destroy(request, *args, **kwargs)