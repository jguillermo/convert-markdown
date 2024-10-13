#!/bin/bash

# Crear un entorno virtual de Python en una carpeta llamada whisperlib si no existe
if [ ! -d "whisperlib" ]; then
    echo "Creando entorno virtual de Python en whisperlib..."
    python3 -m venv whisperlib
fi

# Activar el entorno virtual
echo "Activando el entorno virtual..."
source whisperlib/bin/activate

# Actualizar pip
echo "Actualizando pip..."
pip install --upgrade pip

# Instalar las dependencias
echo "Instalando las dependencias necesarias (Whisper, PyTorch, ffmpeg)..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install git+https://github.com/openai/whisper.git

# Instalar ffmpeg si no está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "Instalando ffmpeg..."
    brew install ffmpeg
else
    echo "ffmpeg ya está instalado"
fi

# Desactivar el entorno virtual
echo "Desactivando el entorno virtual..."
deactivate

echo "Instalación completada. Usa 'transcribe.sh' para transcribir archivos de audio."
