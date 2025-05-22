# # Używamy oficjalnego obrazu Pythona jako bazowego
# FROM python:3.10-slim

# # Wyłącz interaktywne zapytania np. o lokalizację podczas instalacji pakietów
# ENV DEBIAN_FRONTEND=noninteractive

# # Instalacja zależności systemowych (jeśli potrzebne np. do torch, transformers)
# RUN apt-get update && apt-get install -y \
#     git \
#     curl \
#     unzip \
#     && rm -rf /var/lib/apt/lists/*

# # Ustaw katalog roboczy w kontenerze
# WORKDIR /app

# # Skopiuj pliki projektu do kontenera
# #COPY . /app
# COPY requirements.txt MySoft.py /app/

# # Zainstaluj wymagane pakiety Pythona (upewnij się, że plik requirements.txt istnieje)
# RUN pip install --upgrade pip
# RUN pip install -r requirements.txt

# # Punkt wejścia (można nadpisać przy docker run)
# ENTRYPOINT ["python", "MySoft.py"]

FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Skopiuj kod + modele
COPY requirements.txt MySoft.py /app/
COPY models/ /app/models/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN python -c 'from transformers import AutoTokenizer, AutoModel; AutoTokenizer.from_pretrained("FacebookAI/xlm-roberta-base"); AutoModel.from_pretrained("FacebookAI/xlm-roberta-base")'

ENTRYPOINT ["python", "MySoft.py"]
