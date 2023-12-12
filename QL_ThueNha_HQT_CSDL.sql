CREATE DATABASE QL_THUENHA
ON PRIMARY 
(
	name = 'QLTN_PRIMARY',
	Filename = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QLTN_PRIMARY.mdf',
	Size = 5MB,
	Maxsize = 10MB,
	Filegrowth = 10%
)
LOG ON
(
	name = 'QLTN_LOG',
	Filename = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QLTN_LOG.ldf',
	Size = 3MB,
	Maxsize = 5MB,
	Filegrowth = 15%
)
GO

USE QL_THUENHA
GO

CREATE TABLE NHA
(
	MANHA VARCHAR(10) NOT NULL PRIMARY KEY,
	SONHA VARCHAR(30),
	DUONG NVARCHAR(30),
	PHUONG NVARCHAR(30),
	QUAN NVARCHAR(30),
	TIENTHUE FLOAT,
	MOTA NVARCHAR(MAX),
	TINHTRANG NVARCHAR(30)
)

CREATE TABLE KHACHHANG
(
	MAKH VARCHAR(10) NOT NULL PRIMARY KEY,
	HOTENKH NVARCHAR(50),
	NGAYSINH DATE,
	PHAI NVARCHAR(10),
	DIACHI NVARCHAR(50),
	DTHOAI NVARCHAR(30),
	KHANANGTHUE FLOAT
)

CREATE TABLE HOPDONG
(
	SOHD VARCHAR(10) NOT NULL PRIMARY KEY,
	MANHA VARCHAR(10),
	MAKH VARCHAR(10),
	NGAYLAP DATE,
	NGAYBD DATE,
	THOIHANTHUE INT,
	TRIGIAHD FLOAT,
	CONSTRAINT FK_MANHA_HOPDONG FOREIGN KEY (MANHA) REFERENCES NHA(MANHA),
	CONSTRAINT FK_MAKH_HOPDONG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
)
GO

INSERT INTO NHA (MANHA, SONHA, DUONG, PHUONG, QUAN, TIENTHUE, MOTA, TINHTRANG)
VALUES
('NHA001', '10', N'Đường 1', N'Phường A', N'Quận 1', 1000, N'Mô tả về nhà 1', N'Cho thuê'),
('NHA002', '20', N'Đường 2', N'Phường B', N'Quận 2', 1200, N'Mô tả về nhà 2', N'Cho thuê'),
('NHA003', '30', N'Đường 3', N'Phường C', N'Quận 3', 800, N'Mô tả về nhà 3', N'Đã thuê'),
('NHA004', '40', N'Đường 4', N'Phường D', N'Quận 4', 1500, N'Mô tả về nhà 4', N'Cho thuê'),
('NHA005', '50', N'Đường 5', N'Phường E', N'Quận 5', 900, N'Mô tả về nhà 5', N'Đã thuê')

INSERT INTO KHACHHANG (MAKH, HOTENKH, NGAYSINH, PHAI, DIACHI, DTHOAI, KHANANGTHUE)
VALUES
('KH001', N'Nguyễn Văn A', '1990-01-01', N'Nam', N'Địa chỉ A', N'0901234567', 1200),
('KH002', N'Trần Thị B', '1985-05-05', N'Nữ', N'Địa chỉ B', N'0912345678', 1500),
('KH003', N'Lê Thị C', '1995-10-10', N'Nam', N'Địa chỉ C', N'0923456789', 1000),
('KH004', N'Phạm Thị D', '1988-03-15', N'Nữ', N'Địa chỉ D', N'0934567890', 1300),
('KH005', N'Hoàng Văn E', '1992-08-20', N'Nam', N'Địa chỉ E', N'0945678901', 1100)

INSERT INTO HOPDONG (SOHD, MANHA, MAKH, NGAYLAP, NGAYBD, THOIHANTHUE, TRIGIAHD)
VALUES
('HD001', 'NHA001', 'KH001', '2023-01-01', '2023-02-01', 6, 7200),
('HD002', 'NHA002', 'KH002', '2023-02-01', '2023-03-01', 12, 18000),
('HD003', 'NHA003', 'KH003', '2023-03-01', '2023-04-01', 9, 7200),
('HD004', 'NHA004', 'KH004', '2023-04-01', '2023-05-01', 6, 7800),
('HD005', 'NHA005', 'KH005', '2023-05-01', '2023-06-01', 12, 13200)
GO

-- Câu 2:
-- a/ Viết trigger thực hiện kiểm tra khi lập mới một hợp đồng thì trị giá của hợp đồng tự động được cập nhật 
-- theo quy định: Trị giá hợp đồng = Thời hạn thuê * tiền thuê căn nhà.
CREATE TRIGGER Trig_CapNhatTuDongTriGiaHopHong
ON HOPDONG
AFTER INSERT
AS
BEGIN
    UPDATE HOPDONG
    SET TRIGIAHD = I.THOIHANTHUE * N.TIENTHUE
    FROM  inserted I , Nha N
	WHERE I.MANHA = N.MANHA
END

SELECT * FROM HOPDONG

-- Kiểm thử Trigger
INSERT INTO HOPDONG (SOHD, MANHA, MAKH, NGAYLAP, NGAYBD, THOIHANTHUE, TRIGIAHD)
VALUES
('HD006', 'NHA001', 'KH001', '2023-01-01', '2023-02-01', 6, null)
GO

-- Câu 3: Viết thủ tục nhập vào mã căn nhà, trả về số lượng hợp đồng đã thuê căn nhà đó. Viết lệnh gọi thực hiện thủ tục
CREATE PROC PROC_SoLuongHopDongDaThue @maNha VARCHAR(10)
AS
BEGIN
	SELECT COUNT(*) AS N'Số hợp đồng đã thuê' FROM HOPDONG H, NHA N
	WHERE H.MANHA = N.MANHA
	AND N.MANHA = @maNha
	AND N.TINHTRANG = N'Đã Thuê'
END

-- Thực thi
EXEC PROC_SoLuongHopDongDaThue 'NHA003'
GO

-- Câu 4: Viết hàm nhập vào mã khách hàng, trả về địa chỉ và giá thuê các căn nhà mà khách hàng đó có thể thuê. Viết lệnh gọi thực hiện hàm.
CREATE FUNCTION FUNC_CanNhaKhachThue (@maKH VARCHAR(10))
RETURNS TABLE
AS
RETURN (
		SELECT SONHA, DUONG, PHUONG, QUAN, TIENTHUE FROM NHA N, KHACHHANG KH
		WHERE N.TIENTHUE <= KH.KHANANGTHUE
		AND KH.MAKH = @maKH
	)

-- Thực thi
SELECT * FROM dbo.FUNC_CanNhaKhachThue('KH001')
GO

-- Câu 5: a/ Viết lệnh tạo và gán quyền cho các nhóm quyền 'KhachHang' & 'NhanVien'
--Tạo nhóm quyền: sp_addrole 'Tên nhóm quyền'
sp_addrole 'KhachHang'
GO
sp_addrole 'NhanVien'
GO

-- Gán quyền cho nhóm quyền KhachHang
GRANT SELECT (DUONG, PHUONG, QUAN, TIENTHUE)
ON NHA
TO KhachHang

-- Gán quyền cho nhóm quyền NhanVien
GRANT SELECT, INSERT, DELETE, UPDATE
ON KHACHHANG
TO NhanVien

GRANT SELECT, INSERT, UPDATE
ON NHA
TO NhanVien

GRANT SELECT, INSERT
ON HOPDONG
TO NhanVien

GO
-- b/ Viết lệnh tạo các tài khoản đăng nhập sau với xác thực SQL
-- Tạo SQL Server login ID: sp_addlogin 'Tên đăng nhập' , 'mật khẩu' [, 'cơ sở dữ liệu mặc định']
sp_addlogin 'Lan' , 'gauyeu'
GO
sp_addlogin 'Hong', 'thocon'
GO
sp_addlogin 'Cuc', 'cucdep'
GO

-- c/ Viết lệnh tạo các user tương ứng với tên đăng nhập và thuộc các nhóm quyền sau
-- sp_adduser 'Tên đăng nhập', 'Tên người dùng'
-- sp_addrolemember 'Tên nhóm quyền', 'Tên người dùng'
sp_adduser 'Lan', 'Lan'
GO
sp_addrolemember 'NhanVien', 'Lan'
GO
sp_adduser 'Hong', 'Hong'
GO
sp_addrolemember 'KhachHang', 'Lan'
GO
sp_adduser 'Cuc', 'Cuc'
GO
sp_addrolemember 'KhachHang', 'Lan'
GO

-- Câu 6:
-- a/ Tại mỗi thời điểm ti (i≥1) sinh viên tự thêm một dòng dữ liệu vào bảng KHACHHANG để đảm bảo có sự thay đổi dữ liệu trong cơ sở dữ liệu và thực hiện backup bằng lệnh.


-- thời điểm t1 : Full Backup
BACKUP DATABASE QL_THUENHA TO DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Full.bak' WITH INIT
-- Thêm thông tin khách hàng mới
INSERT INTO KHACHHANG (MAKH, HOTENKH, NGAYSINH, PHAI, DIACHI, DTHOAI, KHANANGTHUE)
VALUES
('KH006', N'Nguyễn Thị F', '1993-04-25', N'Nữ', N'Địa chỉ F', N'0956789012', 1400)


-- thời điểm t2 : Log Backup
BACKUP LOG QL_THUENHA TO DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Log_1.trn'
-- Thêm thông tin khách hàng mới
INSERT INTO KHACHHANG (MAKH, HOTENKH, NGAYSINH, PHAI, DIACHI, DTHOAI, KHANANGTHUE)
VALUES
('KH007', N'Trần Văn G', '1987-11-30', N'Nam', N'Địa chỉ G', N'0967890123', 1600)


-- thời điểm t3 : Differential Backup
BACKUP DATABASE QL_THUENHA TO DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Diff.bak' WITH DIFFERENTIAL
-- Thêm thông tin khách hàng mới
INSERT INTO KHACHHANG (MAKH, HOTENKH, NGAYSINH, PHAI, DIACHI, DTHOAI, KHANANGTHUE)
VALUES
('KH008', N'Lê Văn H', '1998-07-05', N'Nam', N'Địa chỉ H', N'0978901234', 1800)

-- thời điểm t4 : Log Backup
BACKUP LOG QL_THUENHA TO DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Log_2.trn'
-- Thêm thông tin khách hàng mới
INSERT INTO KHACHHANG (MAKH, HOTENKH, NGAYSINH, PHAI, DIACHI, DTHOAI, KHANANGTHUE)
VALUES
('KH009', N'Phạm Thị I', '1989-12-10', N'Nữ', N'Địa chỉ I', N'0989012345', 2000)


-- b/ Hãy viết lệnh phục hồi CSDL trên khi sự cố xảy ra.

-- Khôi phục Full Backup (tại thời điểm t1)
RESTORE DATABASE QL_THUENHA
FROM DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Full.bak'
WITH NORECOVERY

-- Khôi phục Log Backup đầu tiên (tại thời điểm t2)
RESTORE LOG QL_THUENHA
FROM DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Log_1.trn'
WITH NORECOVERY

-- Khôi phục Differential Backup (tại thời điểm t3)
RESTORE DATABASE QL_THUENHA
FROM DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Diff.bak'
WITH NORECOVERY

-- Khôi phục Log Backup thứ hai (tại thời điểm t4)
RESTORE LOG QL_THUENHA
FROM DISK = 'D:\HUIT\HK5\HeQuanTriCoSoDuLieu\Thuc Hanh\DE 01\QL_THUENHA_Log_2.trn'
WITH RECOVERY