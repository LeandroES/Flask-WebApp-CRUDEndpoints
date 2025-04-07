
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
├── Dockerfile
├── sql_scripts/
│   └── init_db.sql
```

---

## 🚀 Endpoints y JSON para Postman

### 📘 Libros

### 🧑‍🏫 Autores
