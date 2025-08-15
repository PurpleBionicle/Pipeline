FROM python:3.11-alpine

WORKDIR /app

# Создаем пользователя, чтобы запускать не из-под рута
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY requirements.txt requirements.txt
COPY main.py main.py
COPY test_myapp.py test_myapp.py


# Качаем зависимости и обновляем базовые пакеты
RUN apk update && apk upgrade
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade --force-reinstall setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Переключаемся на непривилегированного пользователя
USER appuser







