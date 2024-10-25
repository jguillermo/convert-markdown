.DEFAULT_GOAL := all
##Incluir el Makefile secundario
include ./whisper/Makefile

## GENERAL ##
# Variable para el nombre del archivo temporal
TEMP_FILE=temp.md

# Comando para leer el portapapeles en macOS
CLIP_CMD = pbpaste

# Directorio del Escritorio en macOS
DESKTOP_DIR = $(HOME)/Desktop

# Generar un nombre aleatorio para el archivo de salida
OUT_FILE=$(DESKTOP_DIR)/salida_$(shell openssl rand -hex 3).docx

# Generar un nombre aleatorio para el archivo de salida
OUT_FOLDER=$(DESKTOP_DIR)/web_$(shell openssl rand -hex 3)


# Tarea por defecto
all: check_temp_file convert_and_move clean

# Verificar si el archivo temp.md ya existe y eliminarlo si es necesario
check_temp_file:
	@if [ -f $(TEMP_FILE) ]; then \
		echo "El archivo $(TEMP_FILE) ya existe, eliminándolo..."; \
		rm -f $(TEMP_FILE); \
	fi

install:
	npm install


# Convertir el archivo temp.md a un archivo de salida con nombre aleatorio
convert_and_move:
	@node convertMarkdown.js
	@echo "Convirtiendo $(TEMP_FILE) a $(OUT_FILE) con pandoc..."
	pandoc --from markdown+lists_without_preceding_blankline+hard_line_breaks --to docx $(TEMP_FILE) -o $(OUT_FILE)
	@echo "Archivo convertido y movido a: $(OUT_FILE)"

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
clone:
	@wget -m -p -E -k -np -U Mozilla --wait=1 --limit-rate=200k --convert-links --no-check-certificate -P "$(OUT_FOLDER)" https://refactoring.guru/es

# Limpiar el archivo temporal
clean:
	@#rm -f $(TEMP_FILE)
	@echo "Archivos temporales eliminados."

help:
	@printf "\033[31m%-16s %-59s %s\033[0m\n" "Target" "Help" "Usage"; \
	printf "\033[31m%-16s %-59s %s\033[0m\n" "------" "----" "-----"; \
	grep -hE '^\S+:.## .$$' $(MAKEFILE_LIST) | sed -e 's/:.##\s/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-16s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'

