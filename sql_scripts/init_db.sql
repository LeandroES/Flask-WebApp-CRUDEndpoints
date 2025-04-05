CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Eliminamos tablas si ya existen (opcional para desarrollo)
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

-- Tabla de Autores
CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(100),
  date_of_birth DATE,
  date_of_death DATE
);

-- Tabla de Libros
CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  author_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  publication_year INT,
  genre VARCHAR(100),
  FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- INSERTS en authors
INSERT INTO authors (name, country, date_of_birth, date_of_death)
VALUES
('Gabriel García Márquez', 'Colombia', '1927-03-06', '2014-04-17'),
('Jorge Luis Borges', 'Argentina', '1899-08-24', '1986-06-14'),
('Isabel Allende', 'Chile', '1942-08-02', NULL),
('Mario Vargas Llosa', 'Perú', '1936-03-28', NULL),
('Carlos Fuentes', 'México', '1928-11-11', '2012-05-15'),
('Julio Cortázar', 'Argentina', '1914-08-26', '1984-02-12'),
('Octavio Paz', 'México', '1914-03-31', '1998-04-19'),
('Pablo Neruda', 'Chile', '1904-07-12', '1973-09-23'),
('Miguel de Cervantes', 'España', '1547-09-29', '1616-04-22'),
('Laura Esquivel', 'México', '1950-09-30', NULL);

-- INSERTS en books
INSERT INTO books (author_id, title, publication_year, genre)
VALUES
(1, 'Cien años de soledad', 1967, 'Realismo mágico'),
(1, 'El amor en los tiempos del cólera', 1985, 'Realismo mágico'),
(2, 'El Aleph', 1949, 'Fantasía filosófica'),
(2, 'Ficciones', 1944, 'Fantasía filosófica'),
(3, 'La casa de los espíritus', 1982, 'Realismo mágico'),
(4, 'La ciudad y los perros', 1963, 'Literatura latinoamericana'),
(5, 'La muerte de Artemio Cruz', 1962, 'Literatura latinoamericana'),
(6, 'Rayuela', 1963, 'Realismo mágico'),
(8, 'Veinte poemas de amor y una canción desesperada', 1924, 'Poesía'),
(9, 'El ingenioso hidalgo Don Quijote de la Mancha', 1605, 'Novela de caballería');
