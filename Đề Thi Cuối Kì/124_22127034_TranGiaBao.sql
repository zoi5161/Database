USE QLNH
GO

-- Mã lớp: 22CLC03
-- MSSV: 22127034
-- Họ tên: Trần Gia Bảo
-- Mã đề:
-- Vị trí: Dòng 6 - Cột 8

-- Câu 1:
SELECT KH.*, COUNT(*) SoLuongTaiKhoan, ISNULL(SUM(TK.SoDu), 0) TongSoDu
FROM KHACHHANG KH
JOIN TAIKHOAN TK ON KH.MaKH = TK.MaKH
GROUP BY KH.MaKH, KH.HoTen, KH.NgaySinh, KH.CMND, KH.DiaChi
HAVING COUNT(DISTINCT TK.LoaiTK) = (SELECT COUNT(*) FROM LOAITAIKHOAN)

-- Câu 2:
SELECT DISTINCT TK.*
FROM GIAODICH GD
JOIN TAIKHOAN TK ON GD.MaTK = TK.MaTK
WHERE GD.GhiChu = N'Rút tiền' AND YEAR(GD.ThoiGianGD) = YEAR(GETDATE())
AND GD.MaTK NOT IN (SELECT DISTINCT GD.MaTK
                    FROM GIAODICH GD
                    JOIN TAIKHOAN TK ON GD.MaTK = TK.MaTK
                    WHERE GD.GhiChu <> N'Rút tiền' AND YEAR(GD.ThoiGianGD) = YEAR(GETDATE()))

-- Câu 3:
GO
CREATE OR ALTER PROCEDURE sp_ThemGD_22127034(
    @MaGD INT, @MaTK CHAR(12), @SoTien INT, @GhiChu NVARCHAR(50))
AS
BEGIN
    DECLARE @TenLoai NVARCHAR(20)
    SELECT @TenLoai = LTK.TenLoai
    FROM TAIKHOAN TK
    JOIN LOAITAIKHOAN LTK ON TK.LoaiTK = LTK.TenLoai
    WHERE TK.MaTK = @MaTK

    -- Mã giao dịch chưa tồn tại
    IF @MaGD = (SELECT GD.MaGD FROM GIAODICH GD WHERE GD.MaGD = @MaGD)
    BEGIN
        PRINT N'Mã giao dịch đã tồn tại'
        RETURN 0
    END

    -- Số tiền khác 0
    IF @SoTien = 0
    BEGIN
        PRINT N'Số tiền không hợp lệ'
        RETURN 0
    END

    -- Số tiền > 0
    IF @SoTien > 0
    BEGIN
        IF @GhiChu <> N'Nạp tiền' AND @GhiChu <> N'Chuyển khoản' AND @GhiChu <> N'Gửi tiền'
        BEGIN
            PRINT N'Ghi chú lỗi với số tiền > 0'
            RETURN 0
        END
    END

    -- Số tiền < 0
    IF @SoTien < 0
    BEGIN
        IF @GhiChu <> N'Rút tiền' AND @GhiChu <> N'Thanh toán' AND @GhiChu <> N'Chuyển khoản'
        BEGIN
            PRINT N'Ghi chú lỗi với số tiền < 0'
            RETURN 0
        END
    END

    -- Mã tài khoản đã tồn tại
    IF NOT EXISTS (SELECT * FROM TAIKHOAN TK WHERE TK.MaTK = @MaTK)
    BEGIN
        PRINT N'Mã tài khoản không tồn tại'
        RETURN 0
    END

    -- Ghi chú là thanh toán
    IF @GhiChu = N'Thanh toán'
    BEGIN
        IF @TenLoai <> N'Thanh toán'
        BEGIN
            PRINT N'Tài khoản không thuộc loại thanh toán nhưng có ghi chú là thanh toán'
            RETURN 0
        END
    END

    -- Ghi chú khác thanh toán
    IF @GhiChu <> N'Thanh toán'
    BEGIN
        IF @TenLoai <> N'Không kỳ hạn'
        BEGIN
            PRINT N'Tài khoản không thuộc loại thanh toán nhưng có ghi chú là thanh toán'
            RETURN 0
        END
    END

    -- Thời gian giao dịch = thời gian hiện tại
    INSERT GIAODICH(MaGD, MaTK, SoTien, ThoiGianGD, GhiChu)
    VALUES (@MaGD, @MaTK, @SoTien, GETDATE(), @GhiChu)
    PRINT N'Thêm thành công'
    RETURN 1
END

-- Câu 4:
GO
CREATE OR ALTER PROCEDURE sp_TaiKhoanView_22127034(
    @MaTK CHAR(12))
AS
BEGIN
    PRINT N'-Mã TK: ' + @MaTK

    DECLARE @MaKH CHAR(20)
    SELECT @MaKH = KH.MaKH
    FROM KHACHHANG KH
    JOIN TAIKHOAN TK ON KH.MaKH = TK.MaKH
    WHERE TK.MaTK = @MaTK
    PRINT N'-Họ tên KH: ' + @MaKH

    DECLARE @SoDu INT
    SELECT @SoDu = TK.SoDu
    FROM TAIKHOAN TK
    WHERE TK.MaTK = @MaTK
    PRINT N'-Số dư: ' + ISNULL(CAST(@SoDu AS VARCHAR(5)), 0)

    DECLARE @SoLuongGiaoDich INT
    SELECT @SoLuongGiaoDich = COUNT(*)
    FROM TAIKHOAN TK
    JOIN GIAODICH GD ON TK.MaTK = GD.MaTK
    WHERE TK.MaTK = @MaTK
    PRINT N'-Số lượng giao dịch: ' + ISNULL(CAST(@SoLuongGiaoDich AS VARCHAR(5)), 0)

    DECLARE @SoLuongGiaoDichRut INT
    SELECT @SoLuongGiaoDichRut = COUNT(*)
    FROM TAIKHOAN TK
    JOIN GIAODICH GD ON TK.MaTK = GD.MaTK
    WHERE TK.MaTK = @MaTK AND GD.GhiChu = N'Rút tiền'
    PRINT N'-Số lượng giao dịch rút: ' + ISNULL(CAST(@SoLuongGiaoDichRut AS VARCHAR(5)), 0)

    DECLARE @SoLuongGiaoDichNap INT
    SELECT @SoLuongGiaoDichNap = COUNT(*)
    FROM TAIKHOAN TK
    JOIN GIAODICH GD ON TK.MaTK = GD.MaTK
    WHERE TK.MaTK = @MaTK AND GD.GhiChu = N'Nạp tiền'
    PRINT N'-Số lượng giao dịch nạp: ' + ISNULL(CAST(@SoLuongGiaoDichNap AS VARCHAR(5)), 0)
END