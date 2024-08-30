CREATE DATABASE QLBH
GO
USE QLBH

CREATE TABLE KH(
	MaKH CHAR(5) CONSTRAINT PK_KH PRIMARY KEY,
	HoTen NVARCHAR(150) NOT NULL,
	SoCCCD CHAR(12) NOT NULL CONSTRAINT UQ_KH_SoCCCD UNIQUE,
	Phai NCHAR(3) CONSTRAINT CK_KH_Phai CHECK (Phai = N'Nam' OR Phai = N'Nữ'),
	NgayTao DATE CONSTRAINT DF_KH_NgayTao DEFAULT GetDate()
)

CREATE TABLE SP(
	MaSP CHAR(5),
	TenSP NVARCHAR(50) NOT NULL,
	DonGia DECIMAL(8, 2),
	SLTon INT CONSTRAINT DF_SP_SLTon DEFAULT 0,
	CONSTRAINT PK_SP PRIMARY KEY(MaSP),
	CONSTRAINT UQ_SP_TenSP UNIQUE (TenSP),
	CONSTRAINT CK_SP_DonGia CHECK (DonGia between 100 and 1000),
	CONSTRAINT CK_SP_SLTon CHECK (SLTon between 0 and 200)
)

CREATE TABLE DH(
	MaDH CHAR(5) CONSTRAINT PK_DH PRIMARY KEY,
	NgayLap DATE CONSTRAINT DF_DH_NgayLap DEFAULT GetDate(),
	MaKH CHAR(5) NOT NULL,
	NgayGiaoDuKien DATE
)

ALTER TABLE DH ADD CONSTRAINT CK_DH_NgayGiaoDuKien
	CHECK (NgayGiaoDuKien > NgayLap)


ALTER TABLE DH ADD CONSTRAINT FK_DH_KH
	FOREIGN KEY (MaKH) REFERENCES KH

CREATE TABLE CT_DH(
	MaDon CHAR(5),
	MaSP CHAR(5),
	SoLuong INT CONSTRAINT CK_CTDH_SoLuong CHECK (SoLuong > 0)

	CONSTRAINT PK_CTDH PRIMARY KEY (MaDon, MaSP),
	CONSTRAINT FK_CTDH_DH FOREIGN KEY (MaDon) REFERENCES DH,
	CONSTRAINT FK_CTDH_SP FOREIGN KEY (MaSP) REFERENCES SP
)

-- Nhap lieu ngay thang: mm/dd/yyyy

-- INSERT du lieu khong tuong minh
INSERT INTO KH VALUES('KH001', N'Nguyễn Văn A', '007913981111', NULL, '01/22/2024'),
					 ('KH002', N'Nguyễn Văn B', '007913981112', NULL, NULL)

-- INSERT du lieu tuong minh
INSERT INTO SP(DonGia, MaSP, TenSP) VALUES (200.20, 'SP001', N'Dầu gội'),
										   (500.30, 'SP002', N'Bột giặt'),
										   (250.50, 'SP003', N'Sữa rửa mặt')

INSERT INTO DH(MaDH, MaKH) VALUES ('DH001', 'KH002')

INSERT INTO CT_DH VALUES ('DH001', 'SP001', 3),
						 ('DH001', 'SP002', 5)

-- Cap nhat du lieu
/*
UPDATE KH
SET Col1 = ..., Col2 = ...
WHERE Col3 = ...
*/

UPDATE DH SET NgayGiaoDuKien = DATEADD(DD, 3, NgayLap)
UPDATE DH SET TONGTIEN = CT.SoLuong * S.DonGia



-- xoa bang: drop table KH
-- them, xoa, sua cot:
/*
alter table KH add newCol char(20) not null
alter table KH alter newCol char(5) null                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
alter table KH alter newCol char(50) not null
alter table KH drop newCol
*/

-- xem du lieu
SELECT * FROM KH
SELECT * FROM SP
SELECT * FROM DH
SELECT * FROM CT_DH

DROP DATABASE QLBH