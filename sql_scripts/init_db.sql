
-- CREACIÓN DE BASE DE DATOS
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_db;

-- TABLA DE USUARIOS PARA AUTENTICACIÓN
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- TABLA DE AUTORES
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLA DE GÉNEROS
CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLA DE LIBROS
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year INT,
    genre_id INT,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

-- TABLA INTERMEDIA PARA RELACIÓN MUCHOS A MUCHOS ENTRE AUTORES Y LIBROS
CREATE TABLE author_book (
    author_id INT,
    book_id INT,
    PRIMARY KEY (author_id, book_id),
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- PROCEDIMIENTO: AGREGAR AUTOR
DELIMITER //
CREATE PROCEDURE add_author(IN p_name VARCHAR(100), IN p_bio TEXT)
BEGIN
    IF EXISTS (SELECT 1 FROM authors WHERE name = p_name AND is_deleted = FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Author already exists';
    ELSE
        INSERT INTO authors(name, bio) VALUES(p_name, p_bio);
    END IF;
END;
//

-- PROCEDIMIENTO: AGREGAR GÉNERO
CREATE PROCEDURE add_genre(IN p_name VARCHAR(100), IN p_description TEXT)
BEGIN
    IF EXISTS (SELECT 1 FROM genres WHERE name = p_name AND is_deleted = FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Genre already exists';
    ELSE
        INSERT INTO genres(name, description) VALUES(p_name, p_description);
    END IF;
END;
//

-- PROCEDIMIENTO: AGREGAR LIBRO
CREATE PROCEDURE add_book(IN p_title VARCHAR(255), IN p_year INT, IN p_genre_id INT, IN p_author_ids TEXT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE author_id INT;
    DECLARE cur CURSOR FOR SELECT CAST(value AS UNSIGNED) FROM JSON_TABLE(CONCAT('[', p_author_ids, ']'), "$[*]" COLUMNS(value VARCHAR(255) PATH "$")) AS jt;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    IF NOT EXISTS (SELECT 1 FROM genres WHERE id = p_genre_id AND is_deleted = FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Genre does not exist';
    END IF;

    INSERT INTO books(title, publication_year, genre_id) VALUES(p_title, p_year, p_genre_id);
    SET @book_id = LAST_INSERT_ID();

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO author_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM authors WHERE id = author_id AND is_deleted = FALSE) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more authors do not exist';
        END IF;

        INSERT INTO author_book(author_id, book_id) VALUES(author_id, @book_id);
    END LOOP;
    CLOSE cur;
END;
//

-- PROCEDIMIENTO: ELIMINACIÓN LÓGICA
CREATE PROCEDURE soft_delete_author(IN p_author_id INT)
BEGIN
    UPDATE authors SET is_deleted = TRUE WHERE id = p_author_id;
END;
//

CREATE PROCEDURE soft_delete_book(IN p_book_id INT)
BEGIN
    UPDATE books SET is_deleted = TRUE WHERE id = p_book_id;
END;
//

CREATE PROCEDURE soft_delete_genre(IN p_genre_id INT)
BEGIN
    UPDATE genres SET is_deleted = TRUE WHERE id = p_genre_id;
END;
//

-- PROCEDIMIENTO: LISTAR LIBROS DE UN AUTOR
CREATE PROCEDURE get_books_by_author(IN p_author_id INT)
BEGIN
    SELECT b.id, b.title, b.publication_year, g.name AS genre
    FROM books b
    JOIN genres g ON b.genre_id = g.id
    JOIN author_book ab ON b.id = ab.book_id
    WHERE ab.author_id = p_author_id AND b.is_deleted = FALSE;
END;
//

-- PROCEDIMIENTO: LISTAR AUTORES DE UN LIBRO
CREATE PROCEDURE get_authors_by_book(IN p_book_id INT)
BEGIN
    SELECT a.id, a.name, a.bio
    FROM authors a
    JOIN author_book ab ON a.id = ab.author_id
    WHERE ab.book_id = p_book_id AND a.is_deleted = FALSE;
END;
//
DELIMITER ;
