# Definir el directorio donde están los scripts y el entorno virtual
WHISPER_DIR := whisper
INSTALL_SCRIPT := $(WHISPER_DIR)/install.sh
TRANSCRIBE_SCRIPT := $(WHISPER_DIR)/transcribe.sh

# Nombre del archivo de entorno virtual
VENV_DIR := $(WHISPER_DIR)/whisperlib

# Comando para verificar si el entorno virtual ya está creado
VENV_ACTIVATE := source $(VENV_DIR)/bin/activate

# Variable para pasar el archivo de audio a transcribir
AUDIO_FILE := $(wordlist 2, 2, $(MAKECMDGOALS))

# Verificar si se ha proporcionado un archivo de audio
ifeq ($(firstword $(MAKECMDGOALS)),transcribe)
  ifeq ($(strip $(AUDIO_FILE)),)
    $(error Debes proporcionar la ruta del archivo de audio. Uso: make transcribe /ruta/del/archivo/audio.mp4)
  endif
endif

# Tarea para instalar las dependencias
install-whisper:
	@echo "Instalando dependencias con $(INSTALL_SCRIPT)..."
	@bash $(INSTALL_SCRIPT)

# Tarea para ejecutar la transcripción
transcribe:
	@echo "Transcribiendo el archivo de audio: $(AUDIO_FILE)"
	@bash $(TRANSCRIBE_SCRIPT) "$(AUDIO_FILE)"

# Tarea para limpiar el entorno virtual (opcional)
clean-whisper:
	@echo "Eliminando el entorno virtual..."
	@rm -rf $(VENV_DIR)
	@echo "Entorno virtual eliminado."
