/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO
if db_id('QLNH') is not null
	drop database QLNH
go
/****** Object:  Database [QLNH]    Script Date: 8/9/2024 8:24:20 AM ******/
CREATE DATABASE [QLNH]
GO
USE [QLNH]
GO
/****** Object:  UserDefinedFunction [dbo].[TINHTONGSODU]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TINHTONGSODU](@MAKH VARCHAR(15))
RETURNS FLOAT
AS
BEGIN
	RETURN (SELECT SUM(SODU) FROM taikhoan WHERE MAKH = @MAKH)
END
GO
/****** Object:  Table [dbo].[TAIKHOAN]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOAN](
	[MaTK] [char](12) NOT NULL,
	[NgayLap] [datetime] NULL,
	[SoDu] [int] NULL,
	[LoaiTK] [int] NOT NULL,
	[MaKH] [char](20) NULL,
	[TinhTrang] [nvarchar](50) NULL,
 CONSTRAINT [PK_TAIKHOAN] PRIMARY KEY CLUSTERED 
(
	[MaTK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[DANHTAIKHOAN]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DANHTAIKHOAN](@MAKH VARCHAR(15))
RETURNS TABLE
AS
	RETURN (SELECT * FROM taikhoan WHERE MaKH = @MAKH)
GO
/****** Object:  Table [dbo].[GIAODICH]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAODICH](
	[MaGD] [int] NOT NULL,
	[MaTK] [char](12) NULL,
	[SoTien] [int] NULL,
	[ThoiGianGD] [datetime] NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK_GIAODICH] PRIMARY KEY CLUSTERED 
(
	[MaGD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[MaKH] [char](20) NOT NULL,
	[HoTen] [nvarchar](30) NULL,
	[NgaySinh] [datetime] NULL,
	[CMND] [char](9) NULL,
	[DiaChi] [nvarchar](40) NULL,
 CONSTRAINT [PK_KHACHHANG] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAITAIKHOAN]    Script Date: 8/9/2024 8:24:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAITAIKHOAN](
	[MaLoai] [int] NOT NULL,
	[TenLoai] [nvarchar](20) NULL,
 CONSTRAINT [PK_LOAITAIKHOAN] PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (1, N'190020110004', 25000, CAST(N'2024-06-10T00:00:00.000' AS DateTime), N'Thanh toán điện            ')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (2, N'190020110002', 45000, CAST(N'2013-02-14T12:00:00.000' AS DateTime), N'Gửi tiền')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (3, N'190020110003', 30000, CAST(N'2013-02-14T19:00:00.000' AS DateTime), N'Chuyển khoản')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (4, N'190020110003', 20000, CAST(N'2013-02-14T13:00:00.000' AS DateTime), N'Nạp tiền')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (5, N'190020110003', -2000, CAST(N'2013-02-17T07:00:00.000' AS DateTime), N'Chuyển khoản')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (6, N'190020110002', -5000, CAST(N'2013-02-19T09:00:00.000' AS DateTime), N'Rút tiền')
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (7, N'190020110002', 15000, CAST(N'2013-02-24T15:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[GIAODICH] ([MaGD], [MaTK], [SoTien], [ThoiGianGD], [GhiChu]) VALUES (8, N'190020110001', 0, CAST(N'2023-10-22T14:31:32.223' AS DateTime), NULL)
GO
INSERT [dbo].[KHACHHANG] ([MaKH], [HoTen], [NgaySinh], [CMND], [DiaChi]) VALUES (N'CID100001           ', N'Nguyễn Thành Trung', CAST(N'1985-05-18T00:00:00.000' AS DateTime), N'240112111', N'Hồ Chí Minh')
GO
INSERT [dbo].[KHACHHANG] ([MaKH], [HoTen], [NgaySinh], [CMND], [DiaChi]) VALUES (N'CID100002           ', N'Trần Thị Trà Hương', CAST(N'1986-06-24T00:00:00.000' AS DateTime), N'241000222', N'Cà Mau')
GO
INSERT [dbo].[KHACHHANG] ([MaKH], [HoTen], [NgaySinh], [CMND], [DiaChi]) VALUES (N'CID100003           ', N'Trần Minh Hùng', CAST(N'1985-05-29T00:00:00.000' AS DateTime), N'240112112', N'Hồ Chí Minh')
GO
INSERT [dbo].[KHACHHANG] ([MaKH], [HoTen], [NgaySinh], [CMND], [DiaChi]) VALUES (N'CID100004           ', N'Lý Thu Huyền', CAST(N'2000-05-29T00:00:00.000' AS DateTime), N'240112113', N'Hà Nội')
GO
INSERT [dbo].[LOAITAIKHOAN] ([MaLoai], [TenLoai]) VALUES (1, N'Có kỳ hạn')
GO
INSERT [dbo].[LOAITAIKHOAN] ([MaLoai], [TenLoai]) VALUES (2, N'Không kỳ hạn')
GO
INSERT [dbo].[LOAITAIKHOAN] ([MaLoai], [TenLoai]) VALUES (3, N'Thanh toán')
GO
INSERT [dbo].[TAIKHOAN] ([MaTK], [NgayLap], [SoDu], [LoaiTK], [MaKH], [TinhTrang]) VALUES (N'190020110001', CAST(N'2013-02-14T00:00:00.000' AS DateTime), 45000, 1, N'CID100002           ', N'Đang dùng')
GO
INSERT [dbo].[TAIKHOAN] ([MaTK], [NgayLap], [SoDu], [LoaiTK], [MaKH], [TinhTrang]) VALUES (N'190020110002', CAST(N'2023-02-14T00:00:00.000' AS DateTime), 45500, 1, N'CID100002           ', N'Đang dùng')
GO
INSERT [dbo].[TAIKHOAN] ([MaTK], [NgayLap], [SoDu], [LoaiTK], [MaKH], [TinhTrang]) VALUES (N'190020110003', CAST(N'2013-05-14T00:00:00.000' AS DateTime), 30000, 2, N'CID100001           ', N'Đã hủy')
GO
INSERT [dbo].[TAIKHOAN] ([MaTK], [NgayLap], [SoDu], [LoaiTK], [MaKH], [TinhTrang]) VALUES (N'190020110004', CAST(N'2024-05-14T00:00:00.000' AS DateTime), 30000, 3, N'CID100001           ', N'Đang dùng')
GO
ALTER TABLE [dbo].[GIAODICH]  WITH CHECK ADD  CONSTRAINT [FK_GIAODICH_TAIKHOAN] FOREIGN KEY([MaTK])
REFERENCES [dbo].[TAIKHOAN] ([MaTK])
GO
ALTER TABLE [dbo].[GIAODICH] CHECK CONSTRAINT [FK_GIAODICH_TAIKHOAN]
GO
ALTER TABLE [dbo].[TAIKHOAN]  WITH CHECK ADD  CONSTRAINT [FK_TAIKHOAN_KHACHHANG] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KHACHHANG] ([MaKH])
GO
ALTER TABLE [dbo].[TAIKHOAN] CHECK CONSTRAINT [FK_TAIKHOAN_KHACHHANG]
GO
ALTER TABLE [dbo].[TAIKHOAN]  WITH CHECK ADD  CONSTRAINT [FK_TAIKHOAN_LOAITAIKHOAN] FOREIGN KEY([LoaiTK])
REFERENCES [dbo].[LOAITAIKHOAN] ([MaLoai])
GO
ALTER TABLE [dbo].[TAIKHOAN] CHECK CONSTRAINT [FK_TAIKHOAN_LOAITAIKHOAN]
GO

SELECT * FROM GIAODICH
SELECT * FROM TAIKHOAN
SELECT * FROM LOAITAIKHOAN
SELECT * FROM KHACHHANG