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

# Instalar PyTorch con soporte para Metal (MPS) y otras dependencias
echo "Instalando PyTorch con soporte para Metal (MPS) y otras dependencias..."
pip install torch torchvision torchaudio

# Instalar Whisper desde el repositorio oficial
echo "Instalando Whisper..."
pip install git+https://github.com/openai/whisper.git

# Instalar ffmpeg usando Homebrew si no está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "Instalando ffmpeg..."
    brew install ffmpeg
else
    echo "ffmpeg ya está instalado"
fi

# Verificar si el backend MPS está disponible
echo "Verificando si el backend MPS está disponible en tu sistema..."
python3 -c "import torch; print('MPS backend is available' if torch.backends.mps.is_available() else 'MPS backend is not available')"

# Desactivar el entorno virtual
echo "Desactivando el entorno virtual..."
deactivate

echo "Instalación completada. Usa 'transcribe.sh' para transcribir archivos de audio."
