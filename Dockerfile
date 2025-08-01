# Use official Python image as base
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv and dependencies
COPY Pipfile Pipfile.lock* requirements.txt ./
RUN pip install --upgrade pip && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi && \
    if [ -f Pipfile ]; then pip install pipenv && pipenv install --system --deploy; fi

# Copy project
COPY . .

# Expose port (default Django port)
EXPOSE 8000

# Collect static files (if needed)
# RUN python manage.py collectstatic --noinput

# Start server
CMD ["gunicorn", "ulcer_diagnosis_django.wsgi:application", "--bind", "0.0.0.0:8000"]
