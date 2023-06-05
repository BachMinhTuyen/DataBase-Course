CREATE DATABASE QL_THUETRUYEN
GO

USE QL_THUETRUYEN
GO

CREATE TABLE THELOAI
(
	MATHELOAI NCHAR(10) PRIMARY KEY,
	TENTHELOAI NVARCHAR(30),
	MOTA NVARCHAR(50)
)
CREATE TABLE TRUYEN
(
	MATRUYEN NCHAR(10) PRIMARY KEY,
	TENTRUYEN NVARCHAR(50),
	MATHELOAI NCHAR(10),
	GIA INT, 
	GIATHUE INT
	FOREIGN KEY (MATHELOAI) REFERENCES THELOAI(MATHELOAI)
)
CREATE TABLE KHACH
(
	MAKH NCHAR(10) PRIMARY KEY,
	HOTEN NVARCHAR(30),
	SOTRUYENTHUE INT
)
CREATE TABLE THUETRUYEN
(
	 MAKH NCHAR(10) NOT NULL,
	 MATRUYEN NCHAR(10) NOT NULL,
	 NGAYTHUE DATE NOT NULL,
	 NGAYTRA DATE,
	 TIENDATCOC INT,
	 PRIMARY KEY (MAKH, MATRUYEN, NGAYTHUE),
	 FOREIGN KEY (MAKH) REFERENCES KHACH(MAKH),
	 FOREIGN KEY (MATRUYEN) REFERENCES TRUYEN(MATRUYEN)
)
GO

ALTER TABLE THUETRUYEN
ADD CONSTRAINT CHK_THUETRUYEN_NGAYTHUE_TRA CHECK (NGAYTHUE <= NGAYTRA)

ALTER TABLE THELOAI
ADD CONSTRAINT UNI_THELOAI_TENTHELOAI UNIQUE (TENTHELOAI)

ALTER TABLE TRUYEN
ADD CONSTRAINT CHK_TRUYEN_GIATHUE CHECK (GIATHUE < 0.5 * GIA)
GO

CREATE TRIGGER KiemTraTienDatCoc ON THUETRUYEN
FOR INSERT
AS
IF EXISTS(SELECT * FROM TRUYEN T, inserted I
			WHERE T.MATRUYEN = I.MATRUYEN
			AND I.TIENDATCOC < T.GIA
			)
	BEGIN
		PRINT N'Tiền đặt cọc phải lớn hơn giá quyển truyện'
		ROLLBACK TRAN
	END
GO

CREATE TRIGGER CapNhatSoTruyenThue ON THUETRUYEN
FOR INSERT
AS
BEGIN
	UPDATE KHACH
	SET SOTRUYENTHUE = SOTRUYENTHUE + 1
	WHERE MAKH IN (SELECT MAKH FROM inserted)
END
GO

-- INSERT INTO THELOAI
INSERT INTO THELOAI (MATHELOAI, TENTHELOAI, MOTA)
VALUES ('TL001', N'Tiểu thuyết', N'Thể loại tiểu thuyết'),
       ('TL002', N'Trinh thám', N'Thể loại trinh thám'),
       ('TL003', N'Khoa học viễn tưởng', N'Thể loại khoa học viễn tưởng');

-- INSERT INTO TRUYEN
INSERT INTO TRUYEN (MATRUYEN, TENTRUYEN, MATHELOAI, GIA, GIATHUE)
VALUES ('TR001', N'Truyện A', 'TL001', 20000, 5000),
       ('TR002', N'Truyện B', 'TL002', 25000, 6000),
       ('TR003', N'Chú khủng long của Nobita', 'TL003', 18000, 4500)

-- INSERT INTO KHACH
INSERT INTO KHACH (MAKH, HOTEN, SOTRUYENTHUE)
VALUES ('KH001', N'Nguyễn Văn A', 3),
       ('KH002', N'Trần Thị B', 2),
       ('KH003', N'Lê Văn C', 5)

-- INSERT INTO THUETRUYEN
INSERT INTO THUETRUYEN (MAKH, MATRUYEN, NGAYTHUE, NGAYTRA, TIENDATCOC)
VALUES ('KH001', 'TR001', '2023-04-01', '2023-04-03', 25000),
       ('KH003', 'TR003', '2023-04-02', '2023-04-04', 25000),
       ('KH002', 'TR001', '2023-04-03', '2023-04-05', 25000)

SELECT K.MAKH, K.HOTEN FROM KHACH AS K, TRUYEN AS TR, THUETRUYEN AS T
WHERE K.MAKH = T.MAKH AND T.MATRUYEN = TR.MATRUYEN 
AND TR.TENTRUYEN = N'Chú khủng long của Nobita'

SELECT TR.MATRUYEN, TR.TENTRUYEN, COUNT(T.MATRUYEN) AS TONGSOLANTHUE
FROM TRUYEN TR
LEFT JOIN THUETRUYEN T ON TR.MATRUYEN = T.MATRUYEN
GROUP BY TR.MATRUYEN, TR.TENTRUYEN
ORDER BY TR.MATRUYEN

SELECT TOP(1) TH.MATHELOAI
FROM THUETRUYEN T, TRUYEN TR, THELOAI TH
WHERE T.MATRUYEN = TR.MATRUYEN AND TR.MATHELOAI = TH.MATHELOAI
GROUP BY TH.MATHELOAI
ORDER BY COUNT(*) DESC