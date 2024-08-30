CREATE DATABASE QLTV
GO
USE QLTV
GO

-- Câu 1:
CREATE TABLE DOI(
    IDDoi INT CONSTRAINT PK_Doi PRIMARY KEY,
    TenDoi NVARCHAR(20),
    DoiTruong INT
)

CREATE TABLE BOTRI(
    IDDOI INT,
    IDThanhVien INT,
    DiaChi NVARCHAR(50),
    NhiemVu NVARCHAR(50),
    QuanLi INT

    CONSTRAINT PK_BoTri PRIMARY KEY (IDDOI, IDThanhVien)
)

CREATE TABLE THANHVIEN(
    IDThanhVien INT CONSTRAINT PK_ThanhVien PRIMARY KEY,
    HoTen NVARCHAR(20),
    SoCMND INT,
    DiaChi NVARCHAR(20),
    NgaySinh DATE
)

-- Câu 2:
ALTER TABLE DOI ADD CONSTRAINT FK_Doi_ThanhVien
FOREIGN KEY (DoiTruong) REFERENCES THANHVIEN

ALTER TABLE BOTRI ADD CONSTRAINT FK_BoTri_ThanhVien
FOREIGN KEY (IDThanhVien) REFERENCES THANHVIEN

ALTER TABLE BOTRI ADD CONSTRAINT FK_BoTri_Doi
FOREIGN KEY (IDDOI) REFERENCES DOI

-- Câu 3:
INSERT INTO THANHVIEN VALUES (1, N'Nguyễn Quan Tùng', 240674018, N'TPHCM', '1/30/2000'),
                             (2, N'Lưu Phi Nam', 240674027, N'Quảng Nam', '3/12/2001'),
                             (3, N'Lê Quang Bảo', 240674063, N'Quảng Ngãi', '5/14/1999'),
                             (4, N'Hà Ngọc Thuý', 240674504, N'TPHCM', '7/26/1998'),
                             (5, N'Trương Thị Minh', 240674405, N'Hà Nội', NULL),
                             (6, N'Ngô Thị Thuỷ', 240674306, NULL, '9/18/2000')

INSERT INTO DOI VALUES (2, N'Đội Tân Phú', 1),
                       (7, N'Đội Bình Phú', 5)

INSERT INTO BOTRI VALUES (2, 2, N'123 Vườn Lài Tân Phú', N'Trực khu vực vòng xoay 1', 1),
                         (2, 1, N'45 Phú Thọ Hoà Tân Phú', N'Theo dõi hoạt động', 1),
                         (7, 3, N'11 Chợ lớn Bình Phú', NULL, 5),
                         (7, 4, N'2 Bis Nguyễn Văn Cừ Q5', NULL, 3),
                         (7, 5, N'1Bis Trần Đình Xu Q1', NULL, NULL)

-- Câu 4:
SELECT DISTINCT D.TenDoi, TV.HoTen
FROM THANHVIEN TV JOIN DOI D ON TV.IDThanhVien = D.DoiTruong
JOIN BOTRI BT ON BT.DiaChi LIKE N'%Tân Phú' AND BT.IDDOI = D.IDDoi


-- Câu 5:
SELECT TV1.HoTen, COUNT(BT.IDThanhVien) SLTV
FROM BOTRI BT JOIN THANHVIEN TV1 ON TV1.IDThanhVien = BT.QuanLi
JOIN THANHVIEN TV2 ON BT.IDThanhVien = TV2.IDThanhVien
WHERE TV2.NgaySinh IS NOT NULL
GROUP BY TV1.HoTen, BT.QuanLi

SELECT * FROM DOI
SELECT * FROM BOTRI
SELECT * FROM THANHVIEN