#!/bin/bash

# Verificar si se ha proporcionado un archivo de audio
if [ -z "$1" ]; then
    echo "Debes proporcionar la ruta del archivo de audio. Uso: ./transcribe.sh /ruta/del/audio.mp4"
    exit 1
fi

AUDIO_FILE=$1

# Verificar si el archivo existe
if [ ! -f "$AUDIO_FILE" ]; then
    echo "El archivo especificado no existe: $AUDIO_FILE"
    exit 1
fi

# Obtener el directorio del archivo de audio
OUTPUT_DIR=$(dirname "$AUDIO_FILE")

# Activar el entorno virtual en whisperlib
echo "Activando el entorno virtual..."
source whisperlib/bin/activate

# Ejecutar Whisper para transcribir el archivo de audio, usando el backend Metal (MPS) en Mac M2
echo "Transcribiendo el archivo: $AUDIO_FILE"
whisper "$AUDIO_FILE" --model medium --output_dir "$OUTPUT_DIR" --device cpu

# Desactivar el entorno virtual
echo "Desactivando el entorno virtual..."
deactivate

echo "Transcripción completada. Los archivos de salida se encuentran en el directorio: $OUTPUT_DIR"
