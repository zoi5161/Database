CREATE DATABASE QLTQ
GO
USE QLTQ
GO

-- Câu 1:
CREATE TABLE TINH_THANH(
    QuocGia VARCHAR(5),
    MaTinhThanh VARCHAR(5),
    TenTT NVARCHAR(30),
    DanSo INT,
    DienTich DECIMAL(12, 2)

    CONSTRAINT PK_TINHTHANH PRIMARY KEY(MaTinhThanh, QuocGia)
)

CREATE TABLE DIEM_THAM_QUAN(
    MaDTQ VARCHAR(10) CONSTRAINT PK_DIEMTHAMQUAN PRIMARY KEY,
    TenDTQ NVARCHAR(30),
    TinhThanh VARCHAR(5),
    QuocGia VARCHAR(5),
    DacDiem NVARCHAR(50)
)

CREATE TABLE QUOC_GIA(
    MaQG VARCHAR(5) CONSTRAINT PK_QUOCGIA PRIMARY KEY,
    TenQG NVARCHAR(20),
    ThuDo VARCHAR(5),
    DanSo INT,
    DienTich DECIMAL(12,2)
)

-- Câu 2:
ALTER TABLE TINH_THANH ADD CONSTRAINT FK_TINHTHANH_QUOCGIA
FOREIGN KEY (QuocGia) REFERENCES QUOC_GIA

ALTER TABLE QUOC_GIA ADD CONSTRAINT FK_QUOCGIA_TINHTHANH
FOREIGN KEY (ThuDo, MaQG) REFERENCES TINH_THANH(MaTinhThanh, QuocGia)

ALTER TABLE DIEM_THAM_QUAN ADD CONSTRAINT FK_DIEMTHAMQUAN_QUOCGIA
FOREIGN KEY (QuocGia) REFERENCES QUOC_GIA

-- Câu 3:
INSERT INTO QUOC_GIA VALUES ('QG001', N'Việt Nam', NULL, 115000000, 331688),
                            ('QG002', N'Nhật Bản', NULL, 129500000, 337834)

INSERT INTO TINH_THANH VALUES ('QG001', 'TT001', N'Hà Nội', 25000000, 927.39),
                              ('QG001', 'TT002', N'Huế', 5344000, 5009),
                              ('QG002', 'TT003', N'Tokyo', 12084000, 2187)

INSERT INTO DIEM_THAM_QUAN VALUES ('DTQ001', N'Văn Miếu', 'TT001', 'QG001', N'Di tích cổ'),
                                  ('DTQ002', N'Hoàng lăng', 'TT002', 'QG001', N'Di tích cổ'),
                                  ('DTQ003', N'Tháp Tokyo', 'TT003', 'QG002', N'Công trình hiện đại')

UPDATE QUOC_GIA SET ThuDo = 'TT001' WHERE MaQG = 'QG001'
UPDATE QUOC_GIA SET ThuDo = 'TT003' WHERE MaQG = 'QG002'

-- Câu 4:
SELECT DTQ.MaDTQ, DTQ.TenDTQ
FROM DIEM_THAM_QUAN DTQ JOIN TINH_THANH TT ON DTQ.TinhThanh = TT.MaTinhThanh
JOIN QUOC_GIA QG ON (TT.QuocGia = QG.MaQG AND TT.DienTich > (QG.DienTich / 100))

-- Câu 5:
SELECT QG.MaQG, QG.TenQG, COUNT(TT.MaTinhThanh) SLTT
FROM QUOC_GIA QG JOIN TINH_THANH TT ON QG.MaQG = TT.QuocGia
GROUP BY QG.MaQG, QG.TenQG
HAVING COUNT(TT.MaTinhThanh) > 30

SELECT * FROM TINH_THANH
SELECT * FROM QUOC_GIA
SELECT * FROM DIEM_THAM_QUAN