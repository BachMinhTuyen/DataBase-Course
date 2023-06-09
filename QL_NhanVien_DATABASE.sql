﻿CREATE DATABASE QL_NHANVIEN
GO

USE QL_NHANVIEN
GO

CREATE TABLE PHONGBAN
(
	MAPH CHAR(5) NOT NULL PRIMARY KEY,
	TENPH NVARCHAR(30) NOT NULL,
	DIADIEM NVARCHAR(40),
)

CREATE TABLE NHANVIEN
(
	MANV CHAR(6) NOT NULL PRIMARY KEY,
	HOTEN NVARCHAR(40),
	NGAYSINH DATE,
	PHAI NCHAR(3),
	DIACHI NVARCHAR(40),
	LUONG MONEY,
	MANQL CHAR(6),
	MAPH CHAR(5),
	CONSTRAINT FK_MANGL FOREIGN KEY(MANQL) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_MAPH FOREIGN KEY(MAPH) REFERENCES PHONGBAN(MAPH)
)

CREATE TABLE DEAN
(
	MADA CHAR(5) NOT NULL PRIMARY KEY,
	TENDA NVARCHAR(50),
	DIADIEMDA NVARCHAR(30),
	NGAYBD DATE
)

CREATE TABLE PHANCONG
(
	MANV CHAR(6) NOT NULL,
	MADA CHAR(5) NOT NULL,
	NGAYTG DATE,
	CONSTRAINT PK_PHANCONG PRIMARY KEY(MANV, MADA),
	CONSTRAINT FK_MANV FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_MADA FOREIGN KEY(MADA) REFERENCES DEAN(MADA)
)

CREATE TABLE THANNHAN
(
	MANV CHAR(6) NOT NULL,
	TENTN NVARCHAR(40) NOT NULL,
	PHAI NCHAR(3),
	NGAYSINH DATE,
	QUANHE NVARCHAR(15)
	CONSTRAINT PK_THANNHAN PRIMARY KEY(MANV, TENTN),
	CONSTRAINT FK_MANV_TN FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)
)

CREATE TABLE THENHANVIEN
(
	MATHE CHAR(10) NOT NULL PRIMARY KEY,
	MANV CHAR(6) NOT NULL,
	NGAYCAP DATETIME,
	CONSTRAINT FK_MANV_TNV FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)
)

INSERT INTO PHONGBAN(MAPH, TENPH, DIADIEM)
VALUES ('PH001', N'Kế hoạch', N'Tầng 1 nhà A'),
('PH002', N'Quản trị', N'Tầng 1 nhà B'),
('PH003', N'Nhân sự', N'Tầng 2 nhà A'),
('PH004', N'Tài vụ', N'Tầng 3 nhà A'),
('PH005', N'Đầu tư', N'Tầng 2 nhà B'),
('PH006', N'Vật tư', N'Tầng 3 nhà B'),
('PH007', N'Tư vấn', N'Tầng 3 nhà B')

INSERT INTO NHANVIEN(MANV, HOTEN, NGAYSINH, PHAI, DIACHI, LUONG, MANQL, MAPH)
VALUES ('NV0001', N'Nguyễn Văn Nam', '1988-07-12',N'Nam', N'Tây Ninh', 15000000, 'NV0009', 'PH003'),
('NV0002', N'Nguyễn Kim Ánh', '1990-02-10',N'Nữ', N'TP.HCM', 8000000, 'NV0009', 'PH003'),
('NV0003', N'Nguyễn Thị Châu', '1979-10-12',N'Nữ', N'Vũng Tàu', 12000000, 'NV0006', 'PH003'),
('NV0004', N'Trần Văn Út', '1977-08-23',N'Nam', N'Hà Nội', 7000000, 'NV0005', 'PH002'),
('NV0005', N'Trần Lệ Quyên', '1987-12-22',N'Nữ', N'Hà Nội', 9000000, 'NV0005', 'PH002'),
('NV0006', N'Bùi Đức Chí', '1987-12-22',N'Nam', N'TP.HCM', 10000000 , 'NV0008', 'PH003'),
('NV0007', N'Nguyễn Tuấn Anh', '1991-09-06',N'Nam', N'Tây Ninh', 35000000, 'NV0002', 'PH003'),
('NV0008', N'Đỗ Xuân Thuỷ', '1985-05-14',N'Nam', N'TP.HCM', 21000000 , 'NV0002', 'PH002'),
('NV0009', N'Trần Minh Tú', '1985-09-17',N'Nam', N'Đồng Nai', 18000000 , null, 'PH001'),
('NV0010', N'Trần Khánh An', '1987-11-13',N'Nữ', N'Khánh Hoà', 12000000, null, null),
('NV0011', N'Nguyễn Ngọc Phan', '1995-06-02',N'Nam', N'Đồng Nai', 13000000 , null, null)

INSERT INTO DEAN(MADA, TENDA, DIADIEMDA, NGAYBD)
VALUES ('DA001', N'Đề bù giải toả', N'Phường 12, Q. Tân Bình', '2015-01-01'),
('DA002', N'Giải phòng mặt bằng', N'Phường 12, Q. Tân Bình', '2015-06-01'),
('DA003', N'Cải tạo mặt đường số 9', N'Phường Tây Thạnh, Q. Tân Phú', '2016-01-01'),
('DA004', N'Bắt đầu thi công', N'Phường 26, Q. Bình Thạnh', '2016-05-04'),
('DA005', N'Hoàn thiện mặt bằng', N'Phường Tân Quy, Q. 7', '2016-12-10')

INSERT INTO PHANCONG(MANV, MADA, NGAYTG)
VALUES ('NV0001', 'DA001', '2015-02-05'),
('NV0001', 'DA003', '2016-03-17'),
('NV0003', 'DA003', '2016-01-01'),
('NV0005', 'DA004', '2016-05-10'),
('NV0007', 'DA005', '2016-12-20')

INSERT INTO THANNHAN(MANV, TENTN, PHAI, NGAYSINH, QUANHE)
VALUES ('NV0001', N'Nguyễn Thị Tám', N'Nữ', '2015-09-05', N'Con'),
('NV0001', N'Nguyễn Văn Bình', N'Nam', '1983-05-22', N'Anh'),
('NV0002', N'Nguyễn Chính Nghĩa', N'Nam', '1998-03-07', N'Em'),
('NV0005', N'Lê Anh Hùng', N'Nam', '1978-04-05', N'Chồng'),
('NV0006', N'Bùi Đại An', N'Nam', '1976-12-03', N'Anh'),
('NV0008', N'Lê Thảo Nguyên', N'Nữ', '1985-06-12', N'Vợ'),
('NV0009', N'Trần Thanh Nhàn', N'Nữ', '1979-05-30', N'Chị')

INSERT INTO THENHANVIEN(MATHE, MANV, NGAYCAP)
VALUES ('T0001', 'NV0001', '2018-03-05'),
('T0002', 'NV0002', '2019-03-17'),
('T0003', 'NV0003', '2020-01-01'),
('T0004', 'NV0004', '2020-05-10'),
('T0005', 'NV0005', '2021-12-20')