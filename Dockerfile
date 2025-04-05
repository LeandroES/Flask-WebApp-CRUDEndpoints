FROM python:3.9

# Ir directamente al backend
WORKDIR /app/backend


# Copiar requerimientos y backend solamente
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del backend
COPY backend/ .

# También copiar scripts y nginx.conf si lo usás
COPY sql_scripts/ /app/sql_scripts/
COPY nginx.conf /app/nginx.conf
COPY wait-for-mysql.sh /app/wait-for-mysql.sh
RUN chmod +x /app/wait-for-mysql.sh

ENV PYTHONPATH="/app"

EXPOSE 5000

CMD ["python", "app.py"]
