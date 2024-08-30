IF DB_ID('QLDT') IS NOT NULL
BEGIN
    DROP DATABASE QLDT
END

CREATE DATABASE QLDT
GO
USE QLDT
GO

CREATE TABLE GIAOVIEN(
    MaGV CHAR(3) CONSTRAINT PK_GV PRIMARY KEY,
    HoTen NVARCHAR(50) NOT NULL,
    Luong DECIMAL(6, 1) DEFAULT 0.0,
    Phai NVARCHAR(3) CONSTRAINT CK_GV_Phai CHECK (Phai = N'Nam' OR Phai = N'Nữ'),
    NgaySinh DATE,
    DiaChi NVARCHAR(100),
    GVQLCM CHAR(3),
    MaBM NVARCHAR(4) NOT NULL
)

CREATE TABLE GV_DT(
    MaGV CHAR(3),
    DienThoai VARCHAR(15)

    CONSTRAINT PK_GVDT PRIMARY KEY(MaGV, DienThoai)
)

CREATE TABLE BOMON(
    MaBM NVARCHAR(4) CONSTRAINT PK_BM PRIMARY KEY,
    TenBM NVARCHAR(50) NOT NULL,
    Phong CHAR(3) NOT NULL,
    DienThoai VARCHAR(15) NOT NULL,
    TruongBM CHAR(3),
    MaKhoa VARCHAR(4) NOT NULL,
    NgayNhanChuc DATE
)

CREATE TABLE KHOA(
    MaKhoa VARCHAR(4) CONSTRAINT PK_Khoa PRIMARY KEY,
    TenKhoa NVARCHAR(50) NOT NULL,
    NamTL INT NOT NULL,
    Phong CHAR(3) NOT NULL,
    DienThoai VARCHAR(15) NOT NULL,
    TruongKhoa CHAR(3),
    NgayNhanChuc DATE CONSTRAINT DF_Khoa_NgayNhanChuc DEFAULT GETDATE()
)

CREATE TABLE DETAI(
    MaDT CHAR(3) CONSTRAINT PK_DT PRIMARY KEY,
    TenDT NVARCHAR(50) NOT NULL,
    CapQL NCHAR(8),
    KinhPhi DECIMAL(6, 1) DEFAULT 0.0,
    NgayBD DATE,
    NgayKT DATE,
    MaCD NCHAR(4) NOT NULL,
    GVCNDT CHAR(3) NOT NULL
)

ALTER TABLE DETAI ADD CONSTRAINT CK_DT_NgayKT_NgayBD 
    CHECK (NgayKT >= NgayBD)

CREATE TABLE CHUDE(
    MaCD NCHAR(4) CONSTRAINT PK_CD PRIMARY KEY,
    TenCD NVARCHAR(50) NOT NULL
)

CREATE TABLE CONGVIEC(
    MaDT CHAR(3),
    STT INT,
    TenCV NVARCHAR(50),
    NgayBD DATE CONSTRAINT DF_CV_NgayBD DEFAULT GETDATE(),
    NgayKT DATE CONSTRAINT DF_CV_NgayKT DEFAULT GETDATE()

    CONSTRAINT PK_CV PRIMARY KEY (MaDT, STT)
)

ALTER TABLE DETAI ADD CONSTRAINT CK_CV_NgayKT_NgayBD 
    CHECK (NgayKT >= NgayBD)

CREATE TABLE THAMGIADT(
    MaGV CHAR(3),
    MaDT char(3),
    STT INT,
    PhuCap DECIMAL(2, 1) DEFAULT 0.0,
    KetQua NVARCHAR(3) CONSTRAINT CK_ThamGiaDT_KQ CHECK (KetQua = N'Đạt' OR KetQua = NULL)

    CONSTRAINT PK_ThamGiaDT PRIMARY KEY(MaGV, MaDT, STT)
)

CREATE TABLE NGUOITHAN(
    MaGV CHAR(3) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    NgaySinh DATE CONSTRAINT DF_NguoiThan_NgaySinh DEFAULT GETDATE(),
    Phai NVARCHAR(3) CONSTRAINT CK_NguoiThan_Phai CHECK (Phai = N'Nam' OR Phai = N'Nữ')
)

ALTER TABLE THAMGIADT ADD CONSTRAINT FK_TGDT_GV
    FOREIGN KEY (MaGV) REFERENCES GIAOVIEN

ALTER TABLE THAMGIADT ADD CONSTRAINT FK_TGDT_CV
    FOREIGN KEY (MaDT, STT) REFERENCES CONGVIEC

/*_*/
ALTER TABLE KHOA ADD CONSTRAINT FK_Khoa_GV
    FOREIGN KEY (TruongKhoa) REFERENCES GIAOVIEN

ALTER TABLE BOMON ADD CONSTRAINT FK_BoMon_GV
    FOREIGN KEY (TruongBM) REFERENCES GIAOVIEN

ALTER TABLE BOMON ADD CONSTRAINT FK_BoMon_Khoa
    FOREIGN KEY (MaKhoa) REFERENCES KHOA

ALTER TABLE CONGVIEC ADD CONSTRAINT FK_CV_DT
    FOREIGN KEY (MaDT) REFERENCES DETAI

ALTER TABLE DETAI ADD CONSTRAINT FK_DT_GV
    FOREIGN KEY (GVCNDT) REFERENCES GIAOVIEN

ALTER TABLE DETAI ADD CONSTRAINT FK_DT_CD
    FOREIGN KEY (MaCD) REFERENCES CHUDE

ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_GV_GV
    FOREIGN KEY (GVQLCM) REFERENCES GIAOVIEN

ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_GV_BoMon
    FOREIGN KEY (MaBM) REFERENCES BOMON

ALTER TABLE GV_DT ADD CONSTRAINT FK_GVDT_GV
    FOREIGN KEY (MaGV) REFERENCES GIAOVIEN

ALTER TABLE NGUOITHAN ADD CONSTRAINT FK_NT_GV
    FOREIGN KEY (MaGV) REFERENCES GIAOVIEN

INSERT INTO CHUDE VALUES (N'NCPT', N'Nghiên cứu phát triển'),
                         (N'QLGD', N'Quản lý giáo dục'),
                         (N'ƯDCN', N'Ứng dụng công nghệ')

INSERT INTO KHOA(MaKhoa, TenKhoa, NamTL, Phong, DienThoai, NgayNhanChuc) VALUES ('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0838123456', '2005-02-20'),
                                                                                ('HH', N'Hoá học', 1980, 'B41', '0838456456', '2001-10-15'),
                                                                                ('SH', N'Sinh học', 1980, 'B31', '0838454545', '2000-10-11'),
                                                                                ('VL', N'Vật lý', 1976, 'B21', '0838223223', '2003-09-18')                                                                                

INSERT INTO BOMON(MaBM, TenBM, Phong, DienThoai, MaKhoa, NgayNhanChuc) VALUES (N'CNTT', N'Công nghệ tri thức', 'B15', '0838126126', 'CNTT', NULL),
                                                                              (N'HHC', N'Hóa hữu cơ', 'B44', '838222222', 'HH', NULL),
                                                                              (N'HL', N'Hóa lý', 'B42', '0838878787', 'HH', NULL),
                                                                              (N'HPT', N'Hóa phân tích', 'B43', '0838777777', 'HH', '2007-10-15'),
                                                                              (N'HTTT', N'Hệ thống thông tin', 'B13', '0838125125', 'CNTT', '2004-09-20'),
                                                                              (N'MMT', N'Mạng máy tính', 'B16', '0838676767', 'CNTT', '2005-05-15'),
                                                                              (N'SH', N'Sinh hóa', 'B33', '0838898989', 'SH', NULL),
                                                                              (N'VLƯD', N'Vật lý ứng dụng', 'B24', '0838454545', 'VL', '2006-02-18'),
                                                                              (N'VLĐT', N'Vật lý điện tử', 'B23', '0838234234', 'VL', NULL),
                                                                              (N'VS', N'Vi sinh', 'B32', '0838909090', 'SH', '2007-01-01')

INSERT INTO GIAOVIEN VALUES ('001', N'Nguyễn Hoài An', 2000.0, N'Nam', '1973-02-15', N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, N'MMT'),
                            ('002', N'Trần Trà Hương', 2500.0, N'Nữ', '1960-06-20', N'125 Trần Hưng Đạo, Q.1, TP HCM', NULL, N'HTTT'),
                            ('003', N'Nguyễn Ngọc Ánh', 2200.0, N'Nữ', '1975-05-11', N'12/21 Võ Văn Ngân Thủ Đức, TPHCM', '002', N'HTTT'),
                            ('004', N'Trương Nam Sơn', 2300.0, N'Nam', '1959-06-20', N'215 Lý Thường Kiệt, TP Biên Hoà', NULL, N'VS'),
                            ('005', N'Lý Hoàng Hà', 2500, N'Nam', '1954-10-23', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', NULL, N'VLĐT'),
                            ('006', N'Trần Bạch Tuyết',1500.0, N'Nữ', '1980-05-20', N'127 Hùng Vương, TP Mỹ Tho', '004', N'VS'),
                            ('007', N'Nguyễn An Trung', 2100.0, N'Nam', '1976-06-05', N'234 3/2, TP Biên Hoà', NULL, N'HPT'),
                            ('008', N'Trần Trung Hiếu', 1800.0, N'Nam', '1977-08-06', N'22/11 Lý Thường Kiệt, TP Mỹ Tho', '007', N'HPT'),
                            ('009', N'Trần Hoàng Nam', 2000.0, N'Nam', '1975-11-22', N'234 Trần Não, An Phú, TP HCM', '001', N'MMT'),
                            ('010', N'Phạm Nam Thanh', 1500.0, N'Nam', '1980-12-12', N'221 Hùng Vương, Q.5, TP HCM', '007', N'HPT')

INSERT INTO GV_DT VALUES ('001', '0838912112'),
                         ('001', '0903123123'),
                         ('002', '0913454545'),
                         ('003', '0838121212'),
                         ('003', '0903656565'),
                         ('003', '0937125125'),
                         ('006', '0937888888'),
                         ('008', '0653717171'),
                         ('008', '0913232323')

INSERT INTO NGUOITHAN VALUES ('001', N'Hùng', '1990-01-14', N'Nam'),
                             ('001', N'Thuỷ', '1994-12-08', N'Nữ'),
                             ('003', N'Hà', '1998-09-03', N'Nữ'),
                             ('003', N'Thu', '1998-09-03', N'Nữ'),
                             ('007', N'Mai', '2003-03-26', N'Nữ'),
                             ('007', N'Vy', '2000-02-14', N'Nữ'),
                             ('008', N'Nam', '1991-05-06', N'Nam'),
                             ('009', N'An', '1996-08-19', N'Nam'),
                             ('010', N'Nguyệt', '2006-01-14', N'Nữ')

INSERT INTO DETAI VALUES ('001', N'HTTT quản lý các trường ĐH', N'ĐHQG', 20.0, '2007-10-20', '2008-10-20', N'QLGD', '002'),
                         ('002', N'HTTT quản lý giáo vụ cho một Khoa', N'Trường', 20.0, '2000-10-12', '2001-10-12', N'QLGD', '002'),
                         ('003', N'Nghiên cứu chế tạo sợi Nanô Platin', N'ĐHQG', 300.0, '2008-05-15', '2010-05-15', N'NCPT', '005'),
                         ('004', N'Tạo vật liệu sinh học bằng màng ối người', N'Nhà nước', 100.0, '2007-01-01', '2009-12-31', N'NCPT', '004'),
                         ('005', N'Ứng dụng hoá học xanh', N'Trường', 200.0, '2003-10-10', '2004-12-10', N'ƯDCN', '007'),
                         ('006', N'Nghiên cứu tế bào gốc', N'Nhà nước', 4000.0, '2006-10-20', '2009-10-20', N'NCPT', '004'),
                         ('007', N'HTTT quản lý thư viện ở các trường ĐH', N'Trường', 20.0, '2009-05-10', '2010-05-10', N'QLGD', '001')

INSERT INTO CONGVIEC VALUES ('001', 1, N'Khởi tạo và Lập kế hoạch', '2007-10-20', '2008-12-20'),
                            ('001', 2, N'Xác định yêu cầu', '2008-12-21', '2008-03-21'),
                            ('001', 3, N'Phân tích hệ thống', '2008-03-22', '2008-05-22'),
                            ('001', 4, N'Thiết kế hệ thống', '2008-05-23', '2008-06-23'),
                            ('001', 5, N'Cài đặt thử nghiệm', '2008-06-24', '2008-10-20'),
                            ('002', 1, N'Khởi tạo và Lập kế hoạch', '2009-05-10', '2009-07-10'),
                            ('002', 2, N'Xác định yêu cầu', '2009-07-11', '2009-10-11'),
                            ('002', 3, N'Phân tích hệ thống', '2009-10-12', '2009-12-20'),
                            ('002', 4, N'Thiết kế hệ thống', '2009-12-21', '2010-03-22'),
                            ('002', 5, N'Cài đặt thử nghiệm', '2010-03-23', '2010-05-10'),
                            ('006', 1, N'Lấy mẫu', '2006-10-20', '2007-02-20'),
                            ('006', 2, N'Nuôi cấy', '2007-02-21', '2008-08-21')

INSERT INTO THAMGIADT VALUES ('001', '002', 1, 0.0, NULL),
                             ('001', '002', 2, 2.0, NULL),
                             ('002', '001', 4, 2.0, N'Đạt'),
                             ('003', '001', 1, 1.0, N'Đạt'),
                             ('003', '001', 2, 0.0, N'Đạt'),
                             ('003', '001', 4, 1.0, N'Đạt'),
                             ('003', '002', 2, 0.0, NULL),
                             ('004', '006', 1, 0.0, N'Đạt'),
                             ('004', '006', 2, 1.0, N'Đạt'),
                             ('006', '006', 2, 1.5, N'Đạt'),
                             ('009', '002', 3, 0.5, NULL),
                             ('009', '002', 4, 1.5, NULL)

UPDATE KHOA SET TruongKhoa = '002' WHERE MaKhoa = 'CNTT'
UPDATE KHOA SET TruongKhoa = '007' WHERE MaKhoa = 'HH'
UPDATE KHOA SET TruongKhoa = '004' WHERE MaKhoa = 'SH'
UPDATE KHOA SET TruongKhoa = '005' WHERE MaKhoa = 'VL'

UPDATE BOMON SET TruongBM = '007' WHERE MaBM = N'HPT'
UPDATE BOMON SET TruongBM = '002' WHERE MaBM = N'HTTT'
UPDATE BOMON SET TruongBM = '001' WHERE MaBM = N'MMT'
UPDATE BOMON SET TruongBM = '005' WHERE MaBM = N'VLƯD'
UPDATE BOMON SET TruongBM = '004' WHERE MaBM = N'VS'

SELECT * FROM GIAOVIEN
SELECT * FROM GV_DT
SELECT * FROM BOMON
SELECT * FROM KHOA
SELECT * FROM DETAI
SELECT * FROM CHUDE
SELECT * FROM CONGVIEC
SELECT * FROM THAMGIADT
SELECT * FROM NGUOITHAN