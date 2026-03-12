-- NovaStore E-Ticaret Veri Yönetim Sistemi
-- Ad Soyad: SEBANUR DARK
-- Açıklama: Bu proje kapsamında SQL Server kullanılarak bir e-ticaret veri tabanı tasarlanmıştır.


-- Bölüm-1: Veri Tabanı Tasarımı
-- 1. Veri Tabanı Oluşturma

USE master;
GO

-- Veri tabanı oluşturma
CREATE DATABASE NovaStoreDB;
GO

-- Veri tabanına geçiş
USE NovaStoreDB;
GO

-- 2. Tablo Gereksinimleri
-- Categories Tablosu Oluşturma
CREATE TABLE Categories (
	CategoryID INT IDENTITY (1,1) PRIMARY KEY,
	CategoryName VARCHAR(50) NOT NULL
);
GO

-- Customers Tablosu Oluşturma
CREATE TABLE Customers (
	CustomerID INT IDENTITY (1,1) PRIMARY KEY,
	FullName VARCHAR(50),
	City VARCHAR(20),
	Email VARCHAR(100) UNIQUE
);
GO

-- Products Tablosu Oluşturma
CREATE TABLE Products (
	ProductID INT IDENTITY (1,1) PRIMARY KEY,
	ProductName VARCHAR(100) NOT NULL,
	Price DECIMAL(10,2),
	Stock INT DEFAULT 0,
	CategoryID INT,
	CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Orders Tablosu Oluşturma
CREATE TABLE Orders (
	OrderID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT,
	OrderDate DATETIME DEFAULT GETDATE(),
	TotalAmount DECIMAL(10,2),
	CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- OrderDetails (Sipariş Detayları) Tablosu Oluşturma
CREATE TABLE OrderDetails (
	DetailID INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT,
	ProductID INT,
	Quantity INT,
	CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO


-- Bölüm-2: Veri Girişi (DML- Insert)
-- Görev 1: Categories tablosuna 5 adet kategori ekleme
INSERT INTO Categories (CategoryName)
VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');
GO

-- Görev 2: Products tablosuna 12 adet ürün ekleme (CategoryID ile birlikte)
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES
-- Elektronik
('Laptop', 25000.00, 15, 1),
('Kablosuz Mouse', 350.00, 40, 1),
('Bluetooth Kulaklık', 1200.00, 25, 1),

-- Giyim
('Erkek Tişört', 300.00, 50, 2),
('Kadın Ceket', 1200.00, 18, 2),

-- Kitap
('SQL Öğreniyorum', 150.00, 30, 3),
('Yapay Zeka 101', 220.00, 12, 3),

-- Kozmetik
('Yüz Temizleme Jeli', 180.00, 35, 4),
('Parfüm', 950.00, 10, 4),

-- Ev ve Yaşam
('Kahve Makinesi', 3200.00, 8, 5),
('Masa Lambası', 450.00, 22, 5),
('Nevresim Takımı', 600.00, 17, 5);
GO

-- Görev 3: Customers tablosuna 6 adet müşteri ekleme
INSERT INTO Customers (FullName, City, Email)
VALUES
('Ahmet Yılmaz', 'İstanbul', 'ahmetyilmaz@gmail.com'),
('Ayşe Demir', 'Ankara', 'aysedemir@gmail.com'),
('Mehmet Kaya', 'İzmir', 'mehmetkaya@gmail.com'),
('Zeynep Çelik', 'Bursa', 'zeynepcelik@gmail.com'),
('Can Özkan', 'Antalya', 'canozkan@gmail.com'),
('Elif Şahin', 'Adana', 'elifsahin@gmail.com');
GO

-- Görev 4: Orders tablosuna 10 adet sipariş ekleme
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2026-01-10', 25350.00),
(2, '2026-01-12', 1200.00),
(3, '2026-01-15', 370.00),
(4, '2026-01-18', 950.00),
(5, '2026-01-20', 3650.00),
(6, '2026-01-22', 600.00),
(1, '2026-02-01', 150.00),
(3, '2026-02-05', 180.00),
(2, '2026-02-10', 3200.00),
(5, '2026-02-12', 450.00);
GO

-- Sipariş detaylarını ekleme
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1),   -- Laptop
(1, 2, 1),   -- Mouse
(2, 5, 1),   -- Kadın Ceket
(3, 2, 1),   -- Mouse
(4, 9, 1),   -- Parfüm
(5, 10, 1),  -- Kahve Makinesi
(5, 3, 1),   -- Bluetooth Kulaklık
(6, 12, 1),  -- Nevresim Takımı
(7, 6, 1),   -- SQL Kitabı
(8, 8, 1),   -- Yüz Temizleme
(9, 10, 1),  -- Kahve Makinesi
(10, 11, 1); -- Masa Lambası
GO


-- Bölüm-3: Sorgulama ve Analiz (DQL - Select ve Joins)
-- 1. Temel Listeleme: Stok miktarı 20’den az olan ürünleri azalan sırada listeleme
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- 2. Veri Birleştirme (JOIN): Customers ve Orders tablolarını INNER JOIN ile birleştirme
SELECT
	C.Fullname,
	C.City,
	O.OrderDate,
	O.TotalAmount
FROM Customers C
INNER JOIN Orders O
	ON C.CustomerID = O.CustomerID
ORDER BY O.OrderDate;
GO

-- 3. Çoklu Birleştirme ve Detay Raporu: Ahmet Yılmaz’ın aldığı ürünleri listeleme (Çoklu JOIN)
SELECT
	C.FullName,
	P.ProductName,
	P.Price,
	CAT.CategoryName
FROM Customers C
INNER JOIN Orders O
	ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD
	ON O.OrderID = OD.OrderID
INNER JOIN Products P
	ON OD.ProductID = P.ProductID
INNER JOIN Categories CAT
	ON P.CategoryID = CAT.CategoryID
WHERE C.FullName = 'Ahmet Yılmaz';
GO

-- 4. Gruplama ve Aggregate Fonksiyonlar: Her kategoride kaç ürün olduğunu listeleme
SELECT
	C.CategoryName,
	COUNT(P.ProductID) AS ToplamUrun
FROM Categories C
LEFT JOIN Products P
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY ToplamUrun DESC;
GO

-- 5. Ciro Analizi (Zor): Müşterilerin toplam ciro analizi
SELECT
	C.FullName,
	SUM(O.TotalAmount) AS ToplamCiro
FROM Customers C
INNER JOIN Orders O
	ON C.CustomerID = O.CustomerID
GROUP BY C.FullName
ORDER BY ToplamCiro DESC;
GO

-- 6. Zaman Analizi: Siparişlerin üzerinden kaç gün geçtiğini hesaplama
SELECT
	OrderID,
	OrderDate,
	DATEDIFF(DAY, OrderDate, GETDATE()) AS GunFarkı
FROM Orders
ORDER BY OrderDate;
GO


-- Bölüm-4: İleri Seviye Veri Tabanı Nesneleri
-- 1. View (Görünüm) Oluşturma:
CREATE VIEW vw_SiparisOzet AS
SELECT
	C.FullName,
	O.OrderDate,
	P.ProductName,
	OD.Quantity
FROM Customers C
INNER JOIN Orders O
	ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD
	ON O.OrderID = OD.OrderID
INNER JOIN Products P
	ON OD.ProductID = P.ProductID;
GO

-- Vıew'i test etmek için
SELECT * FROM vw_SiparisOzet;

-- 2. Yedekleme (Backup): NovaStoreDB veri tabanının yedeğini C:\Yedek\ klasörüne alma
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT,
	MEDIANAME = 'NovaStoreBackup',
	NAME = 'Full Backup of NovaStoreDB';