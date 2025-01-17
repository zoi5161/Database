-- MSSV: 22127034
-- Họ tên: Trần Gia Bảo
-- Mã đề: 2
-- Vị trí: H3C5

CREATE DATABASE GK_22127034
GO
USE GK_22127034
GO

DROP DATABASE GK_22127034

-- Câu 1:
CREATE TABLE KHACHSAN(
    MaKS CHAR(2) CONSTRAINT PK_KHACHSAN PRIMARY KEY,
    TenKS NVARCHAR(20) NOT NULL CONSTRAINT UNI_KHACHSAN_TenKS UNIQUE,
    NamThanhLap INT DEFAULT YEAR(GETDATE()),
    XepHang INT CONSTRAINT CK_KHACHSAN_XEPHANG CHECK (XepHang >= 1 AND XepHang <= 5)
)

CREATE TABLE SANHTIEC(
    MaSanh CHAR(4),
    MaCN CHAR(3),
    MaKS CHAR(2),
    TenSanh NVARCHAR(20) NOT NULL,
    SucChua INT CONSTRAINT CK_SANHTIEC_SUCCHUA CHECK (SucChua > 0),
    GiaThue INT DEFAULT 5000

    CONSTRAINT PK_SANHTIEC PRIMARY KEY (MaSanh, MaCN, MaKS)
)

CREATE TABLE CHINHANH(
    MaCN CHAR(3),
    MaKS CHAR(2),
    DiaChi NVARCHAR(50),
    SanhTiecChinh CHAR(4)

    CONSTRAINT PK_CHINHANH PRIMARY KEY(MaCN, MaKS)
)

ALTER TABLE CHINHANH ADD CONSTRAINT FK_CHINHANH_KHACHSAN
FOREIGN KEY (MaKS) REFERENCES KHACHSAN

ALTER TABLE CHINHANH ADD CONSTRAINT FK_CHINHANH_SANHTIEC
FOREIGN KEY (SanhTiecChinh, MaCN, MaKS) REFERENCES SANHTIEC(MaSanh, MaCN, MaKS)

ALTER TABLE SANHTIEC ADD CONSTRAINT FK_SANHTIEC_CHINHANH
FOREIGN KEY (MaCN, MaKS) REFERENCES CHINHANH(MaCN, MaKS)

ALTER TABLE SANHTIEC ADD CONSTRAINT FK_SANHTIEC_KHACHSAN
FOREIGN KEY (MaKS) REFERENCES KHACHSAN

-- Câu 2:
INSERT INTO KHACHSAN VALUES ('K1', N'Rex', 2000, 5),
                            ('K2', N'Sofitel', 2015, 5),
                            ('K3', N'Biển xanh', 2020, 3)

INSERT INTO CHINHANH(MaCN, MaKS, DiaChi) VALUES ('CN1', 'K1', N'118 Cách Mạng Tháng Tám, HCM'),
                                                ('CN2', 'K1', N'21 Đồng Khởi, HCM'),
                                                ('CN1', 'K2', N'889 Trần Hưng Đạo, HCM'),
                                                ('CN2', 'K2', N'408 Đường 3/2, HCM')

INSERT INTO SANHTIEC VALUES ('S001', 'CN1', 'K1', N'Hoa hồng', 300, 5000),
                            ('S002', 'CN1', 'K1', N'Sen vàng', 800, 8000),
                            ('S003', 'CN1', 'K1', N'Phượng hoàng', 400, 6000),
                            ('S001', 'CN1', 'K2', N'Silver', 250, 4000),
                            ('S001', 'CN2', 'K2', N'Ruby', 500, 5000)

UPDATE CHINHANH SET SanhTiecChinh = 'S003' WHERE MaCN = 'CN1' AND MaKS = 'K1'
UPDATE CHINHANH SET SanhTiecChinh = 'S001' WHERE MaCN = 'CN1' AND MaKS = 'K2'
UPDATE CHINHANH SET SanhTiecChinh = 'S001' WHERE MaCN = 'CN2' AND MaKS = 'K2'

-- Câu 3:
SELECT DISTINCT KS.TenKS, KS.XepHang
FROM KHACHSAN KS JOIN SANHTIEC ST ON KS.MaKS = ST.MaKS
WHERE ST.GiaThue >= 5000 AND ST.GiaThue <= 7000

-- Câu 4:
SELECT KS.TenKS, CN.DiaChi
FROM KHACHSAN KS LEFT JOIN CHINHANH CN ON KS.MaKS = CN.MaKS
LEFT JOIN SANHTIEC ST ON KS.MaKS = ST.MaKS
WHERE KS.XepHang < 5 OR ST.MaSanh IS NULL

-- Câu 5:
SELECT KS.TenKS, COUNT(CN.SanhTiecChinh) SLCN
FROM KHACHSAN KS LEFT JOIN CHINHANH CN ON KS.MaKS = CN.MaKS
LEFT JOIN SANHTIEC ST ON (CN.SanhTiecChinh = ST.MaSanh AND CN.MaCN = ST.MaCN AND CN.MaKS = ST.MaKS)
WHERE ST.SucChua >= 500
GROUP BY KS.MaKS, KS.TenKS

-- Test
SELECT * FROM KHACHSAN
SELECT * FROM CHINHANH
SELECT * FROM SANHTIEC