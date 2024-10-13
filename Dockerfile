# Usar la imagen base de Python compatible con ARM64 (Mac con chip M1/M2) o x86_64 para CPU
FROM python:3.9-slim

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Instalar dependencias del sistema, como ffmpeg y git
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar PyTorch compatible con CPU y Whisper desde GitHub
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install git+https://github.com/openai/whisper.git

# Crear un archivo de audio de prueba vacío para descargar el modelo en el build
RUN echo "test" > /app/test_audio.txt

# Ejecutar Whisper con el modelo "large" para descargarlo durante la construcción
RUN whisper /app/test_audio.txt --model medium --language en || true

# Eliminar el archivo de prueba después de descargar el modelo
RUN rm /app/test_audio.txt

# Definir el comando de ejecución en el contenedor
CMD ["/bin/bash", "-c", "\
    if [ -z \"$AUDIO_FILE\" ]; then \
        echo 'No se ha especificado la ruta del archivo de audio. Usa la variable de entorno AUDIO_FILE para pasar el archivo.'; \
        exit 1; \
    fi; \
    whisper \"$AUDIO_FILE\" --model medium --output_dir /app --device cpu; \
    OUTPUT_FILE_BASE=\"/app/$(basename ${AUDIO_FILE%.*})\"; \
    if [ -f \"${OUTPUT_FILE_BASE}.txt\" ] || [ -f \"${OUTPUT_FILE_BASE}.json\" ]; then \
        echo 'Transcripción completada: $(basename \"$AUDIO_FILE\")'; \
        echo 'Archivos generados: '; \
        ls \"${OUTPUT_FILE_BASE}\"*; \
    else \
        echo 'No se encontró ningún archivo de transcripción.'; \
        exit 1; \
    fi; \
"]
