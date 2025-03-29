CREATE DATABASE temp;
USE temp;

CREATE TABLE departamentos(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255)NOT NULL
);

CREATE TABLE empleados(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255)NOT NULL,
    departamento_id INT UNSIGNED NOT NULL,
    FOREIGN KEY(departamento_id)REFERENCES departamentos(id)
);

CREATE TABLE salarios(
    empleado_id INT UNSIGNED NOT NULL,
    salario DECIMAL(10,2)NOT NULL,
    FOREIGN KEY(empleado_id)REFERENCES empleados(id)
);

INSERT INTO departamentos(nombre)VALUES('Desarrollo'),('Ventas');
INSERT INTO empleados(nombre, departamento_id)VALUES('Luis', 1),('Marta', 2),('Juan', 1);
INSERT INTO salarios(empleado_id, salario)VALUES(1, 2500),(2, 3000),(3, 2700);


-- -METODO 1
SELECT e.nombre AS empleado, d.nombre AS departamento, s.salario,
    (
        SELECT AVG(ss.salario)
        FROM empleados AS se
        LEFT JOIN salarios AS ss ON ss.empleado_id = se.id
        WHERE se.departamento_id = e.departamento_id
    )AS promedio,
    (
        s.salario - (
            SELECT AVG(ss.salario)
            FROM empleados AS se
            LEFT JOIN salarios AS ss ON ss.empleado_id = se.id
            WHERE se.departamento_id = e.departamento_id
        )
    ) AS diferencia
FROM empleados AS e
LEFT JOIN departamentos AS d ON d.id = e.departamento_id
LEFT JOIN salarios AS s ON s.empleado_id = e.id

-- -METODO 2
WITH ref_prom AS (
    SELECT e.departamento_id, AVG(s.salario)AS promedio
    FROM empleados     AS e
    LEFT JOIN salarios AS s ON s.empleado_id = e.id
    GROUP BY e.departamento_id
)
SELECT e.nombre AS empleado, d.nombre AS departamento, s.salario, rp.promedio, (s.salario - rp.promedio)AS diferencia
FROM empleados          AS  e
LEFT JOIN departamentos AS  d ON d.id = e.departamento_id
LEFT JOIN salarios      AS  s ON s.empleado_id = e.id
LEFT JOIN ref_prom      AS rp ON rp.departamento_id = e.departamento_id