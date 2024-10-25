.DEFAULT_GOAL := all
##Incluir el Makefile secundario
include ./whisper/Makefile
include ./web-clone/Makefile

## GENERAL ##
# Variable para el nombre del archivo temporal
TEMP_FILE=temp.md

# Comando para leer el portapapeles en macOS
CLIP_CMD = pbpaste

# Directorio del Escritorio en macOS
DESKTOP_DIR = $(HOME)/Desktop

# Generar un nombre aleatorio para el archivo de salida
OUT_FILE=$(DESKTOP_DIR)/salida_$(shell openssl rand -hex 3).docx

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


# Limpiar el archivo temporal
clean:
	@#rm -f $(TEMP_FILE)
	@echo "Archivos temporales eliminados."

help:
	@printf "\033[31m%-16s %-59s %s\033[0m\n" "Target" "Help" "Usage"; \
	printf "\033[31m%-16s %-59s %s\033[0m\n" "------" "----" "-----"; \
	grep -hE '^\S+:.## .$$' $(MAKEFILE_LIST) | sed -e 's/:.##\s/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-16s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'

