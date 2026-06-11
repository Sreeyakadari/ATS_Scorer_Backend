# ==========================================================
# Base Image
# ==========================================================
FROM python:3.11-slim

# ==========================================================
# Environment Variables
# ==========================================================
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# ==========================================================
# Working Directory
# ==========================================================
WORKDIR /app

# ==========================================================
# System Dependencies
# Required for:
# - WeasyPrint
# - python-magic
# - spaCy
# - PDF processing
# ==========================================================
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    curl \
    git \
    libmagic1 \
    shared-mime-info \
    libcairo2 \
    libcairo2-dev \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# ==========================================================
# Install Python Dependencies
# ==========================================================
COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel

RUN pip install -r requirements.txt

# ==========================================================
# Copy Application Files
# ==========================================================
COPY . .

# ==========================================================
# Hugging Face Spaces Port
# ==========================================================
EXPOSE 7860

# ==========================================================
# Start FastAPI
# ==========================================================
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "7860"]