# Generar un nombre aleatorio para el archivo de salida
OUT_FOLDER=$(DESKTOP_DIR)/web_$(shell openssl rand -hex 3)

# Variable para pasar el archivo de audio a transcribir
TEMP_WEB_URL := $(wordlist 2, 2, $(MAKECMDGOALS))

# Verificar si se ha proporcionado un archivo de audio
ifeq ($(firstword $(MAKECMDGOALS)),download-web)
  ifeq ($(strip $(TEMP_WEB_URL)),)
    $(error Debes proporcionar una url: make download-web https://web.com)
  endif
endif

# clonar una pagina web
#-m o --mirror: Activa el modo espejo, lo que significa que descargará todo el sitio web y sus subpáginas.
#-p o --page-requisites: Descarga todos los archivos necesarios para que las páginas se vean correctamente, incluyendo imágenes, CSS y JavaScript.
#-E o --adjust-extension: Ajusta las extensiones de los archivos HTML para que sean compatibles al verlos localmente.
#-k o --convert-links: Convierte los enlaces para que funcionen de manera local en la copia descargada.
#-np o --no-parent: Evita que wget acceda a directorios superiores en el sitio (importante para no descargar archivos o páginas fuera del dominio).
#-U Mozilla: Simula un navegador web (Mozilla) como agente de usuario, lo cual puede ser útil si el sitio bloquea agentes que no sean navegadores estándar.
#--wait=1: Pausa de un segundo entre cada solicitud, para no sobrecargar el servidor.
#--limit-rate=200k: Limita la velocidad de descarga a 200 KB/s, para que el proceso sea más amigable con el servidor.
#--convert-links: Asegura que todos los enlaces se conviertan para que funcionen en tu copia local.
#--no-check-certificate: Ignora problemas de certificados SSL en caso de que el sitio web use HTTPS y tenga un certificado no confiable.
#-P "$OUT_FOLDER": Especifica la ruta de descarga, usando la variable de entorno OUT_FOLDER como el directorio donde se guardarán todos los archivos.
#URL="$(filter-out $@,$(MAKECMDGOALS))";
download-web:
	#wget -m -p -E -k -np -U Mozilla --wait=1 --limit-rate=200k --convert-links --no-check-certificate -P "$(OUT_FOLDER)" --accept-regex "^$(TEMP_WEB_URL)|.*\.(css|js|png|jpg|jpeg|gif|svg|woff|woff2)$$" $(TEMP_WEB_URL)  || true

