create database QLCB
go
use QLCB
go

CREATE TABLE PHANCONG (
	MANV nvarchar (15)  NOT NULL ,
	NGAYDI smalldatetime NOT NULL ,
	MACB nvarchar (3)  NOT NULL 
) 
GO

CREATE TABLE CHUYENBAY (
	MACB nvarchar (3)  NOT NULL ,
	SBDI nvarchar (3)  NULL ,
	SBDEN nvarchar (3)  NULL ,
	GIODI smalldatetime NULL ,
	GIODEN smalldatetime NULL 
) 
GO

CREATE TABLE KHACHHANG (
	MAKH nvarchar (15) NOT NULL,
	TEN nvarchar (15)  NULL ,
	DCHI nvarchar (50)  NULL ,
	DTHOAI nvarchar (15)  NULL 
) 
GO

CREATE TABLE DATCHO (
	MAKH nvarchar (15)  NOT NULL ,
	NGAYDI smalldatetime NOT NULL ,
	MACB nvarchar (3)  NOT NULL 
) 
GO

CREATE TABLE KHANANG (
	MANV nvarchar (15)  NOT NULL ,
	MALOAI nvarchar (15)  NOT NULL 
) 
GO

CREATE TABLE LICHBAY (
	NGAYDI smalldatetime NOT NULL ,
	MACB nvarchar (3)  NOT NULL ,
	SOHIEU smallint NULL ,
	MALOAI nvarchar (15)  NULL 
) 
GO

CREATE TABLE LOAIMB (
	HANGSX nvarchar (15)  NULL ,
	MALOAI nvarchar (15)  NOT NULL 
) 
GO

CREATE TABLE MAYBAY (
	SOHIEU smallint NOT NULL ,
	MALOAI nvarchar (15)  NOT NULL 
) 
GO

CREATE TABLE NHANVIEN (
	MANV nvarchar (15)  NOT NULL ,
	TEN nvarchar (15)  NULL ,
	DCHI nvarchar (50)  NULL ,
	DTHOAI nvarchar (15)  NULL ,
	LUONG float NULL ,
	LOAINV bit NULL 
) 
GO

ALTER TABLE PHANCONG  ADD 
	CONSTRAINT PK_PHANCONG PRIMARY KEY   
	(
		MANV,
		NGAYDI,
		MACB
	)   
GO

ALTER TABLE CHUYENBAY  ADD 
	CONSTRAINT PK_CHUYENBAY PRIMARY KEY   
	(
		MACB
	)   
GO

ALTER TABLE KHACHHANG  ADD 
	CONSTRAINT PK_KHACHHANG PRIMARY KEY   
	(
		MAKH
	)   
GO

ALTER TABLE DATCHO  ADD 
	CONSTRAINT PK_DATCHO PRIMARY KEY   
	(
		MAKH,
		NGAYDI,
		MACB
	)   
GO

ALTER TABLE KHANANG  ADD 
	CONSTRAINT PK_KHANANG PRIMARY KEY   
	(
		MANV,
		MALOAI
	)   
GO

ALTER TABLE LICHBAY  ADD 
	CONSTRAINT PK_LICHBAY PRIMARY KEY   
	(
		NGAYDI,
		MACB
	)   
GO

ALTER TABLE LOAIMB  ADD 
	CONSTRAINT PK_LOAIMB PRIMARY KEY   
	(
		MALOAI
	)   
GO

ALTER TABLE MAYBAY  ADD 
	CONSTRAINT PK_MAYBAY PRIMARY KEY   
	(
		SOHIEU,
		MALOAI
	)   
GO

ALTER TABLE NHANVIEN  ADD 
	CONSTRAINT PK_NHANVIEN PRIMARY KEY   
	(
		MANV
	)   
GO

ALTER TABLE PHANCONG ADD 
	CONSTRAINT FK_PHANCONG_LICHBAY FOREIGN KEY 
	(
		NGAYDI,
		MACB
	) REFERENCES LICHBAY (
		NGAYDI,
		MACB
	),
	CONSTRAINT FK_PHANCONG_NHANVIEN FOREIGN KEY 
	(
		MANV
	) REFERENCES NHANVIEN (
		MANV
	)
GO

ALTER TABLE DATCHO ADD 
	CONSTRAINT FK_DATCHO_KHACHHANG FOREIGN KEY 
	(
		MAKH
	) REFERENCES KHACHHANG (
		MAKH
	),
	CONSTRAINT FK_DATCHO_LICHBAY FOREIGN KEY 
	(
		NGAYDI,
		MACB
	) REFERENCES LICHBAY (
		NGAYDI,
		MACB
	)
GO

ALTER TABLE KHANANG ADD 
	CONSTRAINT FK_KHANANG_LOAIMB FOREIGN KEY 
	(
		MALOAI
	) REFERENCES LOAIMB (
		MALOAI
	),
	CONSTRAINT FK_KHANANG_NHANVIEN FOREIGN KEY 
	(
		MANV
	) REFERENCES NHANVIEN (
		MANV
	)
GO

ALTER TABLE LICHBAY ADD 
	CONSTRAINT FK_LICHBAY_CHUYENBAY FOREIGN KEY 
	(
		MACB
	) REFERENCES CHUYENBAY (
		MACB
	),
	CONSTRAINT FK_LICHBAY_MAYBAY FOREIGN KEY 
	(
		SOHIEU,
		MALOAI
	) REFERENCES MAYBAY (
		SOHIEU,
		MALOAI
	)
GO

ALTER TABLE MAYBAY ADD 
	CONSTRAINT FK_MAYBAY_LOAIMB FOREIGN KEY 
	(
		MALOAI
	) REFERENCES LOAIMB (
		MALOAI
	)
GO


INSERT INTO KHACHHANG
VALUES ('0101','Anh','567 Tran Phu','8826729')
INSERT INTO KHACHHANG
VALUES ('0009','Nga','223 Nguyen Trai','8932320')
INSERT INTO KHACHHANG
VALUES ('0045','Thu','285 Le Loi','8932203')
INSERT INTO KHACHHANG
VALUES ('0012','Ha','435 Quang Trung','8933232')
INSERT INTO KHACHHANG
VALUES ('0238','Hung','456 Pasteur','9812101')
INSERT INTO KHACHHANG
VALUES ('0397','Huong','234 Le van Sy','8952943')
INSERT INTO KHACHHANG
VALUES ('0582','Mai','789 Nguyen Du','')
INSERT INTO KHACHHANG
VALUES ('0934','Minh','678 Le Lai','')
INSERT INTO KHACHHANG
VALUES ('0091','Hai','345 Hung Vuong','8893223')
INSERT INTO KHACHHANG
VALUES ('0314','Phuong','395 Vo van Tan','8232320')
INSERT INTO KHACHHANG
VALUES ('0613','Vu','348 CMT8','8343232')
INSERT INTO KHACHHANG
VALUES ('0586','Son','123 Bach Dang','8556223')
INSERT INTO KHACHHANG
VALUES ('0422','Tien','75 Nguyen Thong','8332222')
GO

INSERT INTO NHANVIEN
VALUES ('1001','Huong','8 Dien Bien Phu','8330733',50000,1)
INSERT INTO NHANVIEN
VALUES ('1002','Phong','1 Ly Thuong Kiet', '8308117',45000,1)
INSERT INTO NHANVIEN
VALUES ('1003','Quang','78 Truong Dinh', '8234461',35000,1)
INSERT INTO NHANVIEN
VALUES ('1004','Phuong','351 Lac Long Quan', '8308155',25000,0)
INSERT INTO NHANVIEN
VALUES ('1005','Giao','65 Nguyen Thai Son','8324467',5000000,0)
INSERT INTO NHANVIEN
VALUES ('1006','Chi','12/6 Nguyen Kiem','8120012',150000,0)
INSERT INTO NHANVIEN
VALUES ('1007','Tam','36 Nguyen Van Cu', '8458188',500000,0)
GO

INSERT INTO CHUYENBAY
VALUES ('100','SLC','BOS','08:00','17:50')
INSERT INTO CHUYENBAY
VALUES ('112','DCA','DEN','14:00','18:07')
INSERT INTO CHUYENBAY
VALUES ('121','STL','SLC','07:00','09:13')
INSERT INTO CHUYENBAY
VALUES ('122','STL','YYV','08:03','10:19')
INSERT INTO CHUYENBAY
VALUES ('206','DFW','STL','09:00','11:40')
INSERT INTO CHUYENBAY
VALUES ('330','JFK','YYV','16:00','18:53')
INSERT INTO CHUYENBAY
VALUES ('334','ORD','MIA','12:00','14:14')
INSERT INTO CHUYENBAY
VALUES ('335','MIA','ORD','15:00','17:14')
INSERT INTO CHUYENBAY
VALUES ('336','ORD','MIA','18:00','20:14')
INSERT INTO CHUYENBAY
VALUES ('337','MIA','ORD','20:30','23:53')
INSERT INTO CHUYENBAY
VALUES ('394','DFW','MIA','19:00','21:30')
INSERT INTO CHUYENBAY
VALUES ('395','MIA','DFW','21:00','23:43')
INSERT INTO CHUYENBAY
VALUES ('449','CDG','DEN','10:00','19:29')
INSERT INTO CHUYENBAY
VALUES ('930','YYV','DCA','13:00','16:10')
INSERT INTO CHUYENBAY
VALUES ('931','DCA','YYV','17:00','18:10')
INSERT INTO CHUYENBAY
VALUES ('932','DCA','YYV','18:00','19:10')
INSERT INTO CHUYENBAY
VALUES ('991','BOS','ORD','17:00','18:22')
GO

INSERT INTO LOAIMB
VALUES ('Airbus','A310')
INSERT INTO LOAIMB
VALUES ('Airbus','A320')
INSERT INTO LOAIMB
VALUES ('Airbus','A330')
INSERT INTO LOAIMB
VALUES ('Airbus','A340')
INSERT INTO LOAIMB
VALUES ('Boeing','B727')
INSERT INTO LOAIMB
VALUES ('Boeing','B747')
INSERT INTO LOAIMB
VALUES ('Boeing','B757')
INSERT INTO LOAIMB
VALUES ('MD','DC10')
INSERT INTO LOAIMB
VALUES ('MD','DC9')
GO

INSERT INTO MAYBAY
VALUES (10,'B747')
INSERT INTO MAYBAY
VALUES (11,'B727')
INSERT INTO MAYBAY
VALUES (13,'B727')
INSERT INTO MAYBAY
VALUES (13,'B747')
INSERT INTO MAYBAY
VALUES (21,'DC10')
INSERT INTO MAYBAY
VALUES (21,'DC9')
INSERT INTO MAYBAY
VALUES (22,'B757')
INSERT INTO MAYBAY
VALUES (22,'DC9')
INSERT INTO MAYBAY
VALUES (23,'DC9')
INSERT INTO MAYBAY
VALUES (24,'DC9')
INSERT INTO MAYBAY
VALUES (70,'A310')
INSERT INTO MAYBAY
VALUES (80,'A320')
INSERT INTO MAYBAY
VALUES (93,'B757')
GO

INSERT INTO KHANANG
VALUES ('1001','B727')
INSERT INTO KHANANG
VALUES ('1001','B747')
INSERT INTO KHANANG
VALUES ('1001','DC10')
INSERT INTO KHANANG
VALUES ('1002','A320')
INSERT INTO KHANANG
VALUES ('1002','A340')
INSERT INTO KHANANG
VALUES ('1002','B757')
INSERT INTO KHANANG
VALUES ('1002','DC9')
INSERT INTO KHANANG
VALUES ('1003','A310')
INSERT INTO KHANANG
VALUES ('1003','DC9')
GO

INSERT INTO LICHBAY
VALUES ('2000-10-31','100',10,'B747')
INSERT INTO LICHBAY
VALUES ('2000-10-31','112',11,'B727')
INSERT INTO LICHBAY
VALUES ('2000-10-31','206',13,'B727')
INSERT INTO LICHBAY
VALUES ('2000-10-31','334',10 ,'B747')
INSERT INTO LICHBAY
VALUES ('2000-10-31','335',10,'B747')
INSERT INTO LICHBAY
VALUES ('2000-10-31','337',24,'DC9')
INSERT INTO LICHBAY
VALUES ('2000-10-31','449',70,'A310')
INSERT INTO LICHBAY
VALUES ('2000-11-01','100',80,'A320')
INSERT INTO LICHBAY
VALUES ('2000-11-01','112',21,'DC10')
INSERT INTO LICHBAY
VALUES ('2000-11-01','206',22,'DC9')
INSERT INTO LICHBAY
VALUES ('2000-11-01','334',10,'B747')
INSERT INTO LICHBAY
VALUES ('2000-11-01','337',10,'B747')
INSERT INTO LICHBAY
VALUES ('2000-11-01','395',23,'DC9')
INSERT INTO LICHBAY
VALUES ('2000-11-01','991',22,'B757')
GO

INSERT INTO PHANCONG
VALUES ('1001','2000-10-31','100')
INSERT INTO PHANCONG
VALUES ('1001','2000-11-01','100')
INSERT INTO PHANCONG
VALUES ('1002','2000-10-31','100')
INSERT INTO PHANCONG
VALUES ('1002','2000-11-01','100')
INSERT INTO PHANCONG
VALUES ('1003','2000-10-31','100')
INSERT INTO PHANCONG
VALUES ('1003','2000-10-31','337')
INSERT INTO PHANCONG
VALUES ('1004','2000-10-31','100')
INSERT INTO PHANCONG
VALUES ('1004','2000-10-31','337')
INSERT INTO PHANCONG
VALUES ('1005','2000-10-31','337')
INSERT INTO PHANCONG
VALUES ('1006','2000-10-31','337')
INSERT INTO PHANCONG
VALUES ('1006','2000-11-01','991')
INSERT INTO PHANCONG
VALUES ('1007','2000-10-31','206')
INSERT INTO PHANCONG
VALUES ('1007','2000-11-01','112')
INSERT INTO PHANCONG
VALUES ('1007','2000-11-01','991')
GO

INSERT INTO DATCHO
VALUES ('0009','2000-10-31','449')
INSERT INTO DATCHO
VALUES ('0009','2000-11-01','100')
INSERT INTO DATCHO
VALUES ('0045','2000-11-01','991')
INSERT INTO DATCHO
VALUES ('0012','2000-10-31','206')
INSERT INTO DATCHO
VALUES ('0238','2000-10-31','334')
INSERT INTO DATCHO
VALUES ('0582','2000-11-01','991')
INSERT INTO DATCHO
VALUES ('0091','2000-11-01','100')
INSERT INTO DATCHO
VALUES ('0314','2000-10-31','449')
INSERT INTO DATCHO
VALUES ('0613','2000-11-01','100')
INSERT INTO DATCHO
VALUES ('0586','2000-10-31','100')
INSERT INTO DATCHO
VALUES ('0586','2000-11-01','991')
INSERT INTO DATCHO
VALUES ('0422','2000-10-31','449')
GO