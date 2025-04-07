
# 📚 Autor_Libro API

Una API RESTful desarrollada en **Flask**, que permite gestionar autores y libros utilizando una base de datos MySQL, con conexión a través de un pool de conexiones optimizado. Está contenida mediante Docker y expuesta a través de Nginx.

## Integrantes
```
- Leandro Estrada
- Evelyn Chipana
- Rodrigo Ancori
- Rodrigo Ruelas
```
---
## 📌 Características Principales

- Gestión de **autores** y **libros**.
- Separación modular por **blueprints**.
- Uso de **MySQLConnectionPool** para mejorar el rendimiento.
- Configuración multi-servicio con **Docker Compose**.
- Soporte CORS.
- Base de datos inicializada automáticamente con `init_db.sql`.

---

## 🧱 Estructura del Proyecto

```
Autor_Libro/
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   ├── blueprints/
│   │   ├── authors_bp.py
│   │   └── books_bp.py
│   ├── models/
│   │   ├── author_model.py
│   │   ├── book_model.py
│   │   └── mysql_connection_pool.py
├── docker-compose.yml
├── Dockerfile
├── nginx.conf
├── sql_scripts/
│   └── init_db.sql
```

---

## 🚀 Endpoints y JSON para Postman

### 📘 Libros

#### `GET /books`
Retorna todos los libros.

#### `POST /books`
**JSON:**
```json
{
  "title": "Cien años de soledad",
  "author_id": 1
}
```

#### `PUT /books/<id>`
**JSON:**
```json
{
  "title": "Nuevo título",
  "author_id": 2
}
```

#### `DELETE /books/<id>`
Elimina el libro con el ID especificado.

---

### 🧑‍🏫 Autores

#### `GET /authors`
Lista todos los autores.

#### `POST /authors`
**JSON:**
```json
{
  "name": "Gabriel García Márquez"
}
```

#### `PUT /authors/<id>`
**JSON:**
```json
{
  "name": "Nuevo nombre"
}
```

#### `DELETE /authors/<id>`
Elimina el autor con el ID especificado.

---

## ⚙️ Instalación y Ejecución con Docker

### 1. Clonar el repositorio

```bash
git clone https://github.com/tuusuario/Autor_Libro.git
cd Autor_Libro
```

### 2. Verifica tus rutas de configuración

Edita `backend/models/mysql_connection_pool.py` y asegúrate que el archivo `.ini` apunte correctamente al entorno Docker, o reemplaza directamente el `dbconfig` con:

```python
dbconfig = {
    "host": "mysql_container",
    "port": 3306,
    "user": "root",
    "password": "rootpassword",
    "database": "library_db"
}
```

### 3. Ejecutar con Docker Compose

```bash
docker-compose up --build
```

Esto levantará:

- `mysql_container`: Base de datos MySQL.
- `flask_app`: Aplicación Flask.
- `nginx_proxy`: Servidor Nginx.

