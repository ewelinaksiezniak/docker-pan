

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


RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN python -c "\
from huggingface_hub import snapshot_download; \
snapshot_download(repo_id='Ewel/FacebookAI_xlm_roberta_base', local_dir='/app/models/FacebookAI_xlm_roberta_base', local_dir_use_symlinks=False); \
snapshot_download(repo_id='Ewel/modeltrained_on_contrastive_encoder_10_epoch_quote_easy_freeze_0', local_dir='/app/models/modeltrained_on_contrastive_encoder_10_epoch_quote_easy_freeze_0', local_dir_use_symlinks=False); \
snapshot_download(repo_id='Ewel/model_trained_on_contrastive_encoder_10_epoch_question_freeze_0', local_dir='/app/models/model_trained_on_contrastive_encoder_10_epoch_question_freeze_0', local_dir_use_symlinks=False); \
snapshot_download(repo_id='Ewel/model_trained_on_contrastive_encoder_10_epoch_question_medium_freeze_2', local_dir='/app/models/model_trained_on_contrastive_encoder_10_epoch_question_medium_freeze_2', local_dir_use_symlinks=False)"

ENTRYPOINT [ "python3", "/MySoft.py", "-i", "$inputDataset", "-o", "$outputDir" ]
# ENTRYPOINT ["python", "MySoft.py"]
# ENTRYPOINT ["python", "MySoft.py", "/input", "/output"]
ENTRYPOINT ["python", "MySoft.py", "--input", "/input", "--output", "/output"]


