-- ============================================================
-- PROYECTO I - CASO 1: Tienda Online "ElectroHouse"
-- Estudiante: María José Zavaleta Ramírez
-- Fecha: 22/10/2025
-- ============================================================

-- Crear la base de datos
CREATE DATABASE ElectroHouseDB;
USE ElectroHouseDB;

-- ============================================================
-- TABLA: Productos
-- ============================================================
CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

-- ============================================================
-- TABLA: Clientes
-- ============================================================
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);

-- ============================================================
-- TABLA: Ordenes
-- ============================================================
CREATE TABLE Ordenes (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    total DECIMAL(10,2),
    fecha DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- ============================================================
-- INSERCIÓN DE DATOS INICIALES
-- ============================================================
INSERT INTO Productos (nombre, categoria, precio, stock) VALUES
('Televisor Samsung 50"', 'Electrónica', 350000.00, 10),
('Refrigeradora LG', 'Electrodomésticos', 480000.00, 5),
('Microondas Panasonic', 'Electrodomésticos', 85000.00, 15),
('Laptop Dell Inspiron', 'Computadoras', 550000.00, 8),
('Parlante JBL Go 3', 'Audio', 45000.00, 25);

INSERT INTO Clientes (nombre, correo, telefono) VALUES
('María Gómez', 'maria.gomez@gmail.com', '8888-1111'),
('Carlos Rojas', 'carlos.rojas@gmail.com', '8999-2222'),
('Laura Jiménez', 'laura.jimenez@gmail.com', '8700-3333');

INSERT INTO Ordenes (id_cliente, id_producto, cantidad, total, fecha) VALUES
(1, 1, 1, 350000.00, '2025-10-01'),
(2, 5, 2, 90000.00, '2025-10-03');

-- ============================================================
-- CONSULTAS SOLICITADAS
-- ============================================================

-- 1. Listar todos los productos con precio mayor a 100000
SELECT * FROM Productos WHERE precio > 100000;

-- 2. Mostrar clientes con órdenes registradas
SELECT DISTINCT c.nombre, c.correo
FROM Clientes c
JOIN Ordenes o ON c.id_cliente = o.id_cliente;

-- 3. JOIN para combinar información de clientes y sus órdenes
SELECT c.nombre AS Cliente, p.nombre AS Producto, o.cantidad, o.total, o.fecha
FROM Ordenes o
JOIN Clientes c ON o.id_cliente = c.id_cliente
JOIN Productos p ON o.id_producto = p.id_producto;

-- ============================================================
-- TRANSACCIÓN: Simular una venta
-- ============================================================

START TRANSACTION;

-- Supongamos que el cliente 3 (Laura) compra 1 laptop Dell (id_producto = 4)
SET @id_cliente = 3;
SET @id_producto = 4;
SET @cantidad = 1;

-- Verificar stock disponible
SELECT stock FROM Productos WHERE id_producto = @id_producto;

-- Disminuir el stock
UPDATE Productos
SET stock = stock - @cantidad
WHERE id_producto = @id_producto;

-- Registrar la orden
SET @precio = (SELECT precio FROM Productos WHERE id_producto = @id_producto);
SET @total = @precio * @cantidad;

INSERT INTO Ordenes (id_cliente, id_producto, cantidad, total)
VALUES (@id_cliente, @id_producto, @cantidad, @total);

-- Confirmar la transacción
COMMIT;

-- Si hubiera un error, se podría usar:
-- ROLLBACK;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
