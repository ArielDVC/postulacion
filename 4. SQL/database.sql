CREATE DATABASE temp;
USE temp;

CREATE TABLE clientes(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255)NOT NULL
);

CREATE TABLE productos(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255)NOT NULL
);

CREATE TABLE ventas(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT UNSIGNED NOT NULL,
    producto_id INT UNSIGNED NOT NULL,
    FOREIGN KEY(cliente_id)REFERENCES clientes(id),
    FOREIGN KEY(producto_id)REFERENCES productos(id)
);

INSERT INTO clientes(nombre)VALUES('Juan'), ('Maria');
INSERT INTO productos(nombre)VALUES('Laptop'), ('Celular');
INSERT INTO ventas(cliente_id, producto_id)VALUES(1,2), (1,1), (1,2), (2,2), (2,2);

-- -CONSULTA
SELECT v.cliente_id, p.nombre AS producto, COUNT(*)AS cantidad
FROM ventas    AS v
JOIN productos AS p ON v.producto_id = p.id
GROUP BY v.cliente_id, v.producto_id
HAVING COUNT(*) = (
    SELECT MAX(cantidad)
    FROM (
        SELECT COUNT(*)AS cantidad
        FROM ventas
        WHERE cliente_id = v.cliente_id
        GROUP BY producto_id
    ) AS subconsulta
)
ORDER BY v.cliente_id;