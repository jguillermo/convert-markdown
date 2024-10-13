.DEFAULT_GOAL := all
## GENERAL ##
# Variable para el nombre del archivo temporal
TEMP_FILE=temp.md

# Comando para leer el portapapeles en macOS
CLIP_CMD = pbpaste

# Directorio del Escritorio en macOS
DESKTOP_DIR = $(HOME)/Desktop

# Generar un nombre aleatorio para el archivo de salida
OUT_FILE=$(DESKTOP_DIR)/salida_$(shell openssl rand -hex 3).docx

ifeq ($(firstword $(MAKECMDGOALS)),transcribe)
  # Verificar si no se ha proporcionado un argumento
  ifeq ($(strip $(ARG)),)
    ARG=$(wordlist 2, 2, $(MAKECMDGOALS))
    ifeq ($(ARG),)
      $(error Debes proporcionar la ruta del archivo. Uso: make transcribe /ruta/del/archivo/audio.mp3)
    endif
  endif
endif

# Extraer el directorio del archivo de audio
AUDIO_DIR=$(shell dirname $(ARG))

# Extraer el nombre del archivo (sin el directorio)
AUDIO_FILE=$(shell basename $(ARG))

# Crear el nombre del archivo de salida, añadiendo un sufijo para evitar conflictos
OUTPUT_FILE=$(shell echo $(AUDIO_FILE) | sed 's/\(.*\)\..*/\1_output.txt/')

# Asegurar que el argumento no se interprete como un objetivo de Make
$(eval $(ARG):;@:)

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

build:
	#docker build --no-cache -t whisper-image-metal .
	docker build -t whisper-image-metal .
	docker run --rm -it whisper-image-metal /bin/bash -c "ls -ls /root/.cache/whisper/"


transcribe:
	@echo "Transcribiendo el archivo de audio: $(ARG)"
	@docker run --rm -v $(AUDIO_DIR):/app -e AUDIO_FILE="/app/$(AUDIO_FILE)" whisper-image-metal
	@echo "Transcripción completada: $(OUTPUT_FILE)"

# Convertir el archivo temp.md a un archivo de salida con nombre aleatorio
convert_and_move:
	@node convertMarkdown.js
	@echo "Convirtiendo $(TEMP_FILE) a $(OUT_FILE) con pandoc..."
	pandoc --from markdown+lists_without_preceding_blankline+hard_line_breaks --to docx $(TEMP_FILE) -o $(OUT_FILE)
	@echo "Archivo convertido y movido a: $(OUT_FILE)"

# Limpiar el archivo temporal
clean:
	@#rm -f $(TEMP_FILE)
	@echo "Archivos temporales eliminados."

help:
	@printf "\033[31m%-16s %-59s %s\033[0m\n" "Target" "Help" "Usage"; \
	printf "\033[31m%-16s %-59s %s\033[0m\n" "------" "----" "-----"; \
	grep -hE '^\S+:.## .$$' $(MAKEFILE_LIST) | sed -e 's/:.##\s/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-16s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'

