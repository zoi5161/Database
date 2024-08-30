CREATE DATABASE QLHN
GO
USE QLHN
GO

-- Câu 1:
CREATE TABLE BAIBAO(
    STT INT,
    HoiNghi VARCHAR(4),
    NamToChuc INT,
    LoaiBaiBao NVARCHAR(20) CONSTRAINT CK_BaiBao_LBB CHECK (LoaiBaiBao = N'Toàn văn' OR LoaiBaiBao = N'Tóm tắt'),
    ChuDe NVARCHAR(20),

    CONSTRAINT PK_BaiBao PRIMARY KEY (STT, HoiNghi, NamToChuc)
)

CREATE TABLE HOINGHI(
    MaHoiNghi VARCHAR(4),
    QuocGia NVARCHAR(20),
    TenHoiNghi NVARCHAR(50) NOT NULL CONSTRAINT UNI_HN_TenHoiNghi UNIQUE,
    NamThanhLap INT DEFAULT YEAR(GETDATE()),
    NhaXuatBan NVARCHAR(20),

    CONSTRAINT PK_HoiNghi PRIMARY KEY(MaHoiNghi)
)

CREATE TABLE TOCHUC(
    HoiNghi VARCHAR(4),
    NamToChuc INT NOT NULL,
    DiaDiem NVARCHAR(50),
    BaiBaoTieuBieu INT,

    CONSTRAINT PK_ToChuc PRIMARY KEY(HoiNghi, NamToChuc)
)

ALTER TABLE TOCHUC ADD CONSTRAINT FK_ToChuc_HoiNghi
FOREIGN KEY (HoiNghi) REFERENCES HOINGHI

ALTER TABLE TOCHUC ADD CONSTRAINT FK_ToChuc_BaiBao
FOREIGN KEY (BaiBaoTieuBieu, HoiNghi, NamToChuc) REFERENCES BAIBAO(STT, HoiNghi, NamToChuc)

ALTER TABLE BAIBAO ADD CONSTRAINT FK_BaiBao_ToChuc
FOREIGN KEY (HoiNghi, NamToChuc) REFERENCES TOCHUC(HoiNghi, NamToChuc)

-- Câu 2:
INSERT INTO HOINGHI VALUES ('CITA', N'Việt Nam', N'Công nghệ thông tin và ứng dụng', 2023, N'Giáo dục'),
                           ('KES', N'Hoa Kỳ', N'Tri thức và dữ liệu', 2022, N'IEEE')

INSERT INTO TOCHUC VALUES ('CITA', 2023, N'Đà Nẵng, Việt Nam', NULL),
                          ('KES', 2022, N'Tokyo, Nhật Bản', NULL),
                          ('KES', 2023, N'Paris, Pháp', NULL)

INSERT INTO BAIBAO VALUES (1, 'CITA', 2023, N'Toàn văn', N'Ứng dụng'),
                          (2, 'CITA', 2023, N'Tóm tắt', N'Nghiên cứu'),
                          (1, 'KES', 2022, N'Tóm tắt', N'Nghiên cứu'),
                          (1, 'KES', 2023, N'Toàn văn', N'Ứng dụng'),
                          (2, 'KES', 2023, N'Toàn văn', N'Ứng dụng')

UPDATE TOCHUC SET BaiBaoTieuBieu = 2 WHERE HoiNghi = 'CITA'
UPDATE TOCHUC SET BaiBaoTieuBieu = 1 WHERE (HoiNghi = 'KES' AND NamToChuc = 2022)
UPDATE TOCHUC SET BaiBaoTieuBieu = 2 WHERE (HoiNghi = 'KES' AND NamToChuc = 2023)

-- Câu 3:
SELECT TC.DiaDiem
FROM TOCHUC TC JOIN HOINGHI HN ON (HN.TenHoiNghi = N'Tri thức và dữ liệu' AND HN.MaHoiNghi = TC.HoiNghi AND TC.NamToChuc = 2023)

-- Câu 4:
SELECT HN.TenHoiNghi, HN.QuocGia
FROM HOINGHI HN JOIN TOCHUC TC ON (HN.MaHoiNghi = TC.HoiNghi AND TC.DiaDiem LIKE N'%Nhật Bản')
JOIN BAIBAO BB ON (TC.BaiBaoTieuBieu = BB.STT AND TC.HoiNghi = BB.HoiNghi AND TC.NamToChuc = BB.NamToChuc)
EXCEPT
SELECT HN.TenHoiNghi, HN.QuocGia
FROM HOINGHI HN JOIN TOCHUC TC ON (HN.MaHoiNghi = TC.HoiNghi)
JOIN BAIBAO BB ON (TC.BaiBaoTieuBieu = BB.STT AND TC.HoiNghi = BB.HoiNghi AND TC.NamToChuc = BB.NamToChuc)
WHERE BB.LoaiBaiBao = N'Toàn văn' AND BB.ChuDe = N'Ứng dụng'

-- Câu 5:
SELECT HN.MaHoiNghi, HN.TenHoiNghi, COUNT(DISTINCT BB.NamToChuc) SLTC, COUNT(*) SLBB
FROM HOINGHI HN JOIN BAIBAO BB ON HN.MaHoiNghi = BB.HoiNghi 
GROUP BY HN.MaHoiNghi, HN.TenHoiNghi

SELECT HN.MaHoiNghi, HN.TenHoiNghi, COUNT(DISTINCT BB.NamToChuc) SLTC, COUNT(*) SLBB
FROM HOINGHI HN JOIN BAIBAO BB ON HN.MaHoiNghi = BB.HoiNghi
JOIN TOCHUC TC ON TC.HoiNghi = HN.MaHoiNghi
GROUP BY HN.MaHoiNghi, HN.TenHoiNghi

SELECT * FROM BAIBAO
SELECT * FROM HOINGHI
SELECT * FROM TOCHUC