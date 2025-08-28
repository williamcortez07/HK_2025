## 1. Introducción

El presente documento técnico describe la solución propuesta para el reto "Control fitosanitario basado en IA" enfocado en cultivos de frijol. Esta aplicación busca resolver la problemática de pérdidas económicas significativas causadas por plagas y enfermedades en cultivos de frijol, mediante la implementación de tecnologías de inteligencia artificial para la identificación temprana y recomendaciones de control.

El cultivo de frijol es fundamental para la seguridad alimentaria en la región, siendo una fuente importante de proteína y sustento económico para miles de familias productoras. Sin embargo, las pérdidas por plagas y enfermedades pueden alcanzar hasta un 40% de la producción si no se identifican y controlan a tiempo.

## 2. Objetivos del Sistema

### 2.1 Objetivo General
Desarrollar una aplicación móvil y web que permita a productores, estudiantes y técnicos identificar y controlar oportunamente plagas y enfermedades en cultivos de frijol mediante el uso de inteligencia artificial, contribuyendo a reducir pérdidas económicas y mejorar la seguridad alimentaria.

### 2.2 Objetivos Específicos
- Implementar un sistema de identificación automatizada de plagas y enfermedades del frijol con una precisión mínima del 85%
- Desarrollar un motor de recomendaciones técnicas personalizadas basado en diagnósticos, condiciones locales y mejores prácticas
- Crear un sistema de geolocalización y visualización de incidencias para monitoreo y alerta temprana
- Implementar un dashboard para análisis de datos y toma de decisiones a nivel individual y colectivo
- Desarrollar capacidades offline para garantizar funcionalidad en zonas con conectividad limitada 


## 3.Alcances y limitantes

### 3.1 Funcionalidades en sistema 

#### 3.1.2 Funciones del reto

- ***1.Registro y autenticación básica (email + contraseña)***: Cuando el usuario se registre y luego quiera autenticarse se le enviará un código ya sea al correo o al whatsapp o un mensaje de texto para verificar su identidad en el sistema

- ***2.Detección de plagas y enfermedades:*** El sistema cubrirá 10 tipos de plagas  y enfermedades más comunes del frijol que incluye :
	- Mosaico dorado
	- Antracnosis
	- Bacteriosis común
    - Roya
	- Mancha angular
	- Mustia hilachosa
	- Mosaico común
	- Pudriciones radiculares
	- Gorgojos
	- Mosca blanca

- ***3.Usuarios**:* El sistema estará diseñado para ser utilizado por:
	- Pequeños y medianos productores de frijol
	- Estudiantes de agronomía
	- Técnicos agrícolas
	- Investigadores y académicos

 - ***4.Cobertura Geográfica**:* Inicialmente enfocado en regiones productoras de frijol en el país, con potencial de expansión a otras regiones.
	- Visualización en mapa de incidencias
		- Por tipo de plaga/enfermedad
		- Por temporalidad
	    - Por severidad

- ***5. Gestión de datos Estadístico**:* Sistema de recopilación, procesamiento y análisis de datos estadísticos sobre incidencias fitosanitarias.

**Implementación**:
- Recopilación automática de datos de diagnósticos
- Agregación por variables relevantes:
  - Tipo de plaga/enfermedad
  - Región geográfica
  - Temporada/clima
  - Efectividad de tratamientos
- Análisis de tendencias y patrones
- Predicciones básicas de riesgo


- ***6.Recomendación Técnicas Personalizadas**:* Sistema de recomendaciones basado en los diagnósticos previos, condiciones ambientales y mejores prácticas agronómicas.

**Implementación**:
- Motor de reglas para recomendaciones básicas según diagnóstico
- Sistema de recomendación contextual basado en:
  - Historial de diagnósticos del usuario
  - Datos geográficos y climáticos de la zona
  - Prácticas efectivas reportadas por otros usuarios
- Biblioteca de tratamientos con opciones orgánicas y convencionales
- Alertas y recordatorios para seguimiento de tratamientos


- ***7. Dashboard para Visualización de Casos**:* Interfaz de visualización de datos agregados sobre incidencias, tratamientos y efectividad.

**Implementación**:
- Paneles personalizados según tipo de usuario
- Visualizaciones en tiempo real de:
  - Incidencias por región
  - Distribución de tipos de plagas/enfermedades
  - Efectividad de tratamientos
  - Tendencias temporales
- Exportación de datos en formatos estándar
- Informes automáticos periódicos

#### 3.1.2 Funciones para el valor agregado

- ***1. Multiplataforma:*** El sistema se podrá ejecutar tanto en móviles como en entorno web

 - ***2. Idiomas**:* Tendrá el ESPAÑOL como idioma principal, con posibilidad de añadir idiomas que el usuario necesite.

- ***3. Biblioteca de Conocimiento**:* Repositorio estructurado sobre las plagas, enfermedades y sus tratamientos y mejores prácticas:
	- Contenido multimedia(Imágenes,vídeos, Infografía)
	- Fichas técnicas
	- Búsquedas por síntomas o características 


- ***4. Módulo de capacitación**:*  Sistema de aprendizaje para mejorar las capacidades de los usuarios en identificación y manejo de problemas fitosanitarios.
	- Curso
	- Contenido Multimedia interactivo
	- Calendario de capacitaciones

- ***4. Comunidad y Foro de Discusión**:* Espacio de intercambio de conocimientos entre usuarios para compartir experiencias y soluciones:
	- Foros categorizados por tipo de problema
	- Sistema de valoración de respuestas
	- Integración con diagnósticos para compartir casos
	- Participación de expertos verificados



### 3.2 Funcionalidades que no incluirá

#### Funciones del Reto

#### Funciones de valor 

- **Integración IoT :** conexión con sensores y dispositivos IoT para monitoreo automático de condiciones ambientales en cultivos.

	- Soporte para sensores de humedad, temperatura, pH
	- Protocolos estándar (MQTT, CoAP)
	- Visualización de datos de sensores en tiempo real
	- Alertas basadas en umbrales definidos

- **Marketplace de Insumos y Servicios :** Plataforma para conectar productores con proveedores de insumos y servicios técnicos relacionados con el control fitosanitario.

	- Listado de proveedores verificados
	- Recomendaciones de productos basadas en diagnósticos
	- Sistema de valoraciones y reseñas
	- Solicitud de cotizaciones

