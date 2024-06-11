# `python-base` sets up all our shared environment variables

# Use Python 3.9-slim como base
FROM python:3.10-slim as python-base

# Set environment variables for Python, pip, and Poetry
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.3 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Install system dependencies and build tools
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy project requirement files
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# Install project dependencies
RUN poetry install --with dev

# Set working directory and copy project files
WORKDIR /app
COPY . /app/

# Expose the application port
EXPOSE 8000

# Command to run the application
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]