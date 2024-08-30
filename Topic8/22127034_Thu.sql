USE QLDT
GO

-- Câu j: XUất ra toàn bộ danh sách giáo viên.
CREATE OR ALTER PROCEDURE SP_PrintAllGV
AS
BEGIN
    SELECT *
    FROM GIAOVIEN
END

EXEC SP_PrintAllGV

-- Câu k: Tính số lượng đề tài mà một giáo viên đang thực hiện.
GO
CREATE OR ALTER FUNCTION F_TinhSLDT(
    @MaGV CHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) 
            FROM THAMGIADT TG
            WHERE TG.MaGV = @MaGV)
END
GO
SELECT *, DBO.F_TinhSLDT(MaGV) SLDT
FROM GIAOVIEN

-- Câu l: In thông tin chi tiết của một giáo viên (sử dụng lệnh print): Thông tin cá nhân, 
-- số Lượng đề tài tham gia, số lượng thân nhân của giáo viên đó
GO
CREATE OR ALTER PROCEDURE SP_PrintInforGV
    @MaGV CHAR(3)
AS
BEGIN
    DECLARE @HoTen NVARCHAR(50), @Luong DECIMAL(6, 1), @Phai NVARCHAR(3), 
    @NgaySinh DATE, @DiaChi NVARCHAR(100), @GVQLCM CHAR(3), @MaBM NVARCHAR(4)

    SELECT @HoTen = HoTen, @Luong = Luong, @Phai = Phai, @NgaySinh = NgaySinh, 
    @DiaChi = DiaChi, @GVQLCM = GVQLCM, @MaBM = MaBM
    FROM GIAOVIEN
    WHERE MaGV = @MaGV

    DECLARE @SLDTTG INT
    SELECT @SLDTTG = COUNT(*)
    FROM THAMGIADT TG
    WHERE TG.MaGV = @MaGV

    DECLARE @SLNT INT
    SELECT @SLNT = COUNT(*)
    FROM NGUOITHAN NT
    WHERE NT.MaGV = @MaGV

    PRINT N'Thông tin cá nhân:'
    PRINT N'Mã GV: ' + @MaGV
    PRINT N'Họ Tên: ' + @HoTen
    PRINT N'Lương: ' + CAST(@Luong AS NVARCHAR(10))
    PRINT N'Phái: ' + @Phai
    PRINT N'Ngày Sinh: ' + CAST(@NgaySinh AS NVARCHAR(10))
    PRINT N'Địa Chỉ: ' + @DiaChi
    PRINT N'GVQLCM: ' + ISNULL(@GVQLCM, 'NULL')
    PRINT N'Mã BM: ' + @MaBM

    PRINT N'Số lượng đề tài tham gia: ' + CAST(@SLDTTG AS NVARCHAR(10))
    PRINT N'Số lượng thân nhân: ' + CAST(@SLNT AS NVARCHAR(10))
END
GO

EXEC SP_PrintInforGV '003'

-- Câu m: Kiểm tra xem một giáo viên có tồn tại hay không
GO
CREATE OR ALTER PROCEDURE SP_CheckExistsGV
    @MaGV CHAR(3)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM GIAOVIEN GV WHERE GV.MaGV = @MaGV)
    BEGIN
        PRINT N'Không tồn tại giáo viên có mã số ' + @MaGV
        RETURN 0
    END

    PRINT N'Tồn tại giáo viên có mã số ' + @MaGV
    RETURN 1
END
GO

EXEC SP_CheckExistsGV '001'

-- Câu n: Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài 
-- mà bộ môn của giáo viên đó làm chủ nhiệm.
GO
CREATE OR ALTER PROCEDURE SP_CheckRegulationGV
    @MaGV CHAR(3)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM GIAOVIEN GV WHERE GV.MaGV = @MaGV)
    BEGIN
        PRINT N'Không tồn tại giáo viên có mã số ' + @MaGV
        RETURN 0
    END

    DECLARE @MaBM NVARCHAR(4)

    SELECT @MaBM = GV.MaBM
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaGV

    IF NOT EXISTS (
        SELECT *
        FROM THAMGIADT TG
        JOIN DETAI DT ON TG.MaDT = DT. MaDT
        JOIN BOMON BM ON DT.GVCNDT = BM.TruongBM
        WHERE TG.MaGV = @MaGV AND @MaBM = BM.MaBM
    )
    BEGIN
        PRINT N'Giáo viên có mã số ' + @MaGV + N' có thực hiện các đề tài mà bộ môn của trưởng bộ môn của mình không chủ nhiệm'
        RETURN 0
    END
    ELSE
    BEGIN
        PRINT N'Giáo viên có mã số ' + @MaGV + N' chỉ thực hiện các đề tài mà bộ môn của trưởng bộ môn của mình làm chủ nhiệm'
        RETURN 1
    END
END

EXEC SP_CheckRegulationGV @MaGV = '003'

-- Câu n: Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài:
--    Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc phải tồn tại, thời gian tham gia phải >0
--    Kiểm tra quy định ở câu n.
GO
CREATE OR ALTER PROCEDURE SP_AddTGDT(
        @MaGV CHAR(3), 
        @MaDT CHAR(3), 
        @SoTT INT,
        @PhuCap DECIMAL(2, 1),
        @KetQua NVARCHAR(3))
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM GIAOVIEN GV WHERE @MaGV = GV.MaGV)
    BEGIN
        PRINT N'Không tồn tại giáo viên có mã số ' + @MaGV
        RETURN 0        
    END

    IF NOT EXISTS (SELECT * FROM CONGVIEC CV WHERE @MaDT = CV.MaDT AND @SoTT = CV.STT)
    BEGIN
        PRINT N'Không tồn tại công việc có STT ' + CAST(@SoTT AS NVARCHAR) + N' thuộc mã đề tài ' + @MaDT
        RETURN 0
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT * FROM CONGVIEC CV WHERE @MaDT = CV.MaDT AND @SoTT = CV.STT AND CV.NgayBD < CV.NgayKT)
        BEGIN
            PRINT N'Thời gian tham gia < 0'
            RETURN 0
        END
    END

    DECLARE @MaBM NVARCHAR(4), @GVCNDT CHAR(3)

    SELECT @MaBM = GV.MaBM
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaGV

    SELECT @GVCNDT = DT.GVCNDT
    FROM DETAI DT
    WHERE DT.MaDT = @MaDT

    IF NOT EXISTS (
        SELECT *
        FROM THAMGIADT TG
        JOIN DETAI DT ON TG.MaDT = DT. MaDT
        JOIN BOMON BM ON DT.GVCNDT = BM.TruongBM
        WHERE TG.MaGV = @MaGV AND @MaBM = BM.MaBM AND @GVCNDT = BM.TruongBM
    )
    BEGIN
        PRINT N'Giáo viên có mã số ' + @MaGV + N' có thực hiện các đề tài mà bộ môn của trưởng bộ môn của mình không chủ nhiệm'
        RETURN 0
    END
    ELSE
    BEGIN
        INSERT THAMGIADT(MaDT, MaGV, STT, PhuCap, KetQua)
        VALUES (@MaDT, @MaGV, @SoTT, @PhuCap, @KetQua)
        PRINT N'Thêm thành công'
        RETURN 1
    END
END

EXEC SP_AddTGDT '003', '002', 4, 0.0, NULL

-- Câu p: Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan 
-- (Có thân nhân, có làm đề tài, ...) thì báo lỗi.
GO
CREATE OR ALTER PROCEDURE SP_DeleteGV(
        @MaGV CHAR(3))
AS
BEGIN
    IF EXISTS (SELECT * FROM THAMGIADT TG WHERE TG.MaGV = @MaGV)
    BEGIN 
        PRINT N'Giáo viên có tham gia đề tài không thể xoá'
        RETURN 0
    END

    IF EXISTS (SELECT * FROM NGUOITHAN NT WHERE NT.MaGV = @MaGV)
    BEGIN 
        PRINT N'Giáo viên có người thân không thể xoá'
        RETURN 0
    END

    IF EXISTS (SELECT * FROM BOMON BM WHERE BM.TruongBM = @MaGV)
    BEGIN 
        PRINT N'Giáo viên là trưởng bộ môn không thể xoá'
        RETURN 0
    END

    IF EXISTS (SELECT * FROM KHOA K WHERE K.TruongKhoa = @MaGV)
    BEGIN 
        PRINT N'Giáo viên là trưởng khoa không thể xoá'
        RETURN 0
    END

    DELETE FROM GIAOVIEN
    WHERE MaGV = @MaGV
    RETURN 1
END

EXEC SP_DeleteGV '005'

-- Câu q: In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề tài
-- mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có, ...
GO
CREATE OR ALTER PROCEDURE SP_InforAllGV(
        @MaBM NVARCHAR(4))
AS
BEGIN
    SELECT GV.MaGV, GV.HoTen, GV.Luong, GV.Phai, GV.NgaySinh, GV.DiaChi, GV.GVQLCM, GV.MaBM, BM.TenBM,
           COUNT(DISTINCT TG.MaDT) AS SoLuongDeTai,
           COUNT(DISTINCT NT.Ten) AS SoLuongNguoiThan,
           COUNT(DISTINCT GV2.MaGV) AS SoLuongGVQuanLy
    FROM GIAOVIEN GV
    LEFT JOIN BOMON BM ON GV.MaBM = BM.MaBM
    LEFT JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    LEFT JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
    LEFT JOIN GIAOVIEN GV2 ON GV.MaGV = GV2.GVQLCM
    WHERE BM.MaBM = @MaBM
    GROUP BY GV.MaGV, GV.HoTen, GV.Luong, GV.Phai, GV.NgaySinh, GV.DiaChi, GV.GVQLCM, GV.MaBM, BM.TenBM
    ORDER BY GV.MaGV
END
GO

EXEC SP_InforAllGV 'HTTT'

-- Câu r: Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì lương
-- của a phải cao hơn lương của b. (a, b: mã giáo viên)
GO
CREATE OR ALTER PROCEDURE SP_Regulation2GV(
    @MaGV1 CHAR(3), @MaGV2 CHAR(3))
AS
BEGIN
    DECLARE @MaBM1 NVARCHAR(4), @Luong1 DECIMAL(6, 1)
    SELECT @MaBM1 = GV.MaBM, @Luong1 = GV.Luong
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaGV1

    DECLARE @MaBM2 NVARCHAR(4), @Luong2 DECIMAL(6, 1)
    SELECT @MaBM2 = GV.MaBM, @Luong2 = GV.Luong
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaGV2

    IF NOT EXISTS(
        SELECT *
        FROM BOMON BM
        WHERE (BM.TruongBM = @MaGV1 OR BM.TruongBM = @MaGV2)
    )
    BEGIN
        PRINT N'Giáo viên có mã số ' + @MaGV1 + N' và giáo viên có mã số ' + @MaGV2 + N' không phải là trưởng bộ môn'
        RETURN 0
    END

    IF (@MaBM1 <> @MaBM2)
    BEGIN
        PRINT N'Giáo viên có mã số ' + @MaGV1 + N' và giáo viên có mã số ' + @MaGV2 + N' không cùng bộ môn'
        RETURN 0
    END

    IF EXISTS(
        SELECT *
        FROM BOMON BM
        WHERE BM.TruongBM = @MaBM1 AND @Luong1 < @Luong2
    )
    BEGIN
        PRINT N'Không đúng quy định về lương vì giáo viên có mã số ' + @MaGV1 + N' là trưởng phòng nhưng lương lại thấp hơn giáo viên có mã số ' + @MaGV2
        RETURN 0
    END

    IF EXISTS(
        SELECT *
        FROM BOMON BM
        WHERE BM.TruongBM = @MaBM2 AND @Luong2 < @Luong1
    )
    BEGIN
        PRINT N'Không đúng quy định về lương vì giáo viên có mã số ' + @MaGV2 + N' là trưởng phòng nhưng lương lại thấp hơn giáo viên có mã số ' + @MaGV1
        RETURN 0
    END

    PRINT N'Đúng quy định về lương'
    RETURN 1
END

EXEC SP_Regulation2GV '006', '004'

-- Câu s: Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18, lương > 0
GO
CREATE OR ALTER PROCEDURE SP_AddGV(
    @MaGV CHAR(3), @HoTen NVARCHAR(50), @Luong DECIMAL(6, 1), @Phai NVARCHAR(3), @NgaySinh DATE, @DiaChi NVARCHAR(100), @GVQLCM CHAR(3), @MaBM NVARCHAR(4))
AS
BEGIN
    IF EXISTS (SELECT * FROM GIAOVIEN GV WHERE GV.HoTen = @HoTen)
    BEGIN
        PRINT N'Vi phạm trùng tên'
        RETURN 0
    END

    IF ((YEAR(GETDATE()) - YEAR(@NgaySinh)) <= 18)
    BEGIN
        PRINT N'Lỗi độ tuổi không phù hợp'
        RETURN 0
    END

    IF (@Luong <= 0)
    BEGIN
        PRINT N'Lỗi lương không phù hợp'
        RETURN 0
    END

    INSERT GIAOVIEN(MaGV, HoTen, Luong, Phai, NgaySinh, DiaChi, GVQLCM, MaBM)
    VALUES (@MaGV, @HoTen, @Luong, @Phai, @NgaySinh, @DiaChi, @GVQLCM, @MaBM)
    RETURN 1
END

EXEC SP_AddGV '011', N'Nguyễn Hoài An', 2000.0, N'Nam', '2005-05-19', N'2/3 Lý Thái Tổ, Q.10, TP HCM', NULL, N'VS'
EXEC SP_AddGV '011', N'Nguyễn Hoài Anh', 2000.0, N'Nam', '2007-05-19', N'2/3 Lý Thái Tổ, Q.10, TP HCM', NULL, N'VS'
EXEC SP_AddGV '011', N'Nguyễn Hoài Anh', 0, N'Nam', '2005-05-19', N'2/3 Lý Thái Tổ, Q.10, TP HCM', NULL, N'VS'
EXEC SP_AddGV '011', N'Nguyễn Hoài Anh', 2000.0, N'Nam', '2005-05-19', N'2/3 Lý Thái Tổ, Q.10, TP HCM', NULL, N'VS'

-- Câu t: Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 
-- 001, 002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 
-- 001, 002, 005 thì MAGV của giáo viên mới là 003.
GO
CREATE OR ALTER PROCEDURE Sp_TaoMaGV(
    @HoTen NVARCHAR(50), @Luong DECIMAL(6, 1), @Phai NVARCHAR(3), @NgaySinh DATE, @DiaChi NVARCHAR(100), @GVQLCM CHAR(3) = NULL, @MaBM NVARCHAR(4))
AS
BEGIN
    DECLARE @MaGV CHAR(3);
    DECLARE @NextID INT = 1;

    -- Tạo bảng tạm để lưu trữ các mã giáo viên
    CREATE TABLE #TempGV (
        MaGV CHAR(3)
    )

    -- Chèn các mã giáo viên hiện có vào bảng tạm
    INSERT INTO #TempGV (MaGV)
    SELECT MaGV
    FROM GIAOVIEN;

    -- Tìm mã giáo viên mới
    WHILE EXISTS (SELECT 1 FROM #TempGV WHERE MaGV = RIGHT('000' + CAST(@NextID AS VARCHAR), 3))
    BEGIN
        SET @NextID = @NextID + 1;
    END

    SET @MaGV = RIGHT('000' + CAST(@NextID AS VARCHAR), 3);

    -- Chèn giáo viên mới vào bảng GIAOVIEN
    INSERT INTO GIAOVIEN (MaGV, HoTen, Luong, Phai, NgaySinh, DiaChi, GVQLCM, MaBM)
    VALUES (@MaGV, @HoTen, @Luong, @Phai, @NgaySinh, @DiaChi, @GVQLCM, @MaBM);
    
    -- Trả về mã giáo viên mới
    SELECT @MaGV AS MaGVMoi;

    -- Xóa bảng tạm
    DROP TABLE #TempGV;
END

EXEC Sp_TaoMaGV N'Nguyễn Hoài Anh', 2000.0, N'Nam', '2005-05-19', N'2/3 Lý Thái Tổ, Q.10, TP HCM', NULL, N'VS'

-- Function
-- Câu 1: Viết hàm truyền vào mã gv tính số đề tài tham gia
GO
CREATE OR ALTER FUNCTION F_TinhSLDT(
    @MaGV CHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(DISTINCT TG.MaDT)
            FROM GIAOVIEN GV
            JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
            WHERE GV.MaGV = @MaGV
            GROUP BY GV.MaGV
    )
END

GO
SELECT *, DBO.F_TinhSLDT('001') SLDTTG
FROM GIAOVIEN
-- Câu 2: Viết hàm truyền vào madt tính số công việc chưa hoàn thành
GO
CREATE OR ALTER FUNCTION F_TinhSCVChuaHoanThanh(
    @MaDT CHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*)
            FROM (SELECT CV.MaDT, CV.STT
                  FROM CONGVIEC CV
                  WHERE CV.MaDT = @MaDT
                  EXCEPT
                  SELECT TG.MaDT, TG.STT
                  FROM THAMGIADT TG
                  WHERE TG.MaDT = @MaDT AND TG.KetQua = N'Đạt') AS SubQuery)
END

GO
SELECT dbo.F_TinhSCVChuaHoanThanh('001') AS SoCongViecChuaHoanThanh

-- Câu 3: Viết hàm truyền vào madt tính số công việc đã hoàn thành
GO
CREATE OR ALTER FUNCTION F_TinhSCVDaHoanThanh(
    @MaDT CHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(DISTINCT TG.STT)
            FROM THAMGIADT TG
            WHERE TG.MaDT = @MaDT AND TG.KetQua = N'Đạt')
END

GO
SELECT dbo.F_TinhSCVDaHoanThanh('001') AS SoCongViecDaHoanThanh

-- Câu 4: Viết hàm truyền vào madt xuất danh sách công việc trong đề tài 
-- (stt, tencv, số giáo viên tham gia, tổng phụ cấp)
GO
CREATE OR ALTER FUNCTION F_PrintCV(
    @MaDT CHAR(3))
RETURNS TABLE
AS
    RETURN (SELECT CV.STT, CV.TenCV, COUNT(TG.MaGV) SLGV, ISNULL(SUM(TG.PhuCap), 0) TongPhuCap
            FROM CONGVIEC CV
            LEFT JOIN THAMGIADT TG ON TG.MaDT = CV.MaDT AND TG.STT = CV.STT
            WHERE @MaDT = CV.MaDT
            GROUP BY CV.STT, CV.TenCV)

GO
SELECT * FROM dbo.F_PrintCV('001')
ORDER BY STT

-- Câu 5: Viết hàm truyền vào MaGV tính số đề tài tham gia
GO
CREATE OR ALTER FUNCTION F_TinhSLDTTG(
    @MaGV CHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(DISTINCT TG.MaDT)
            FROM GIAOVIEN GV
            JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
            WHERE GV.MaGV = @MaGV
            GROUP BY GV.MaGV
    )
END

GO
SELECT * , DBO.F_TinhSLDTTG('001') SLDTTG

-- Câu 6: Viết hàm truyền vào magv xuất danh sách đề tài tham gia
GO
CREATE OR ALTER FUNCTION F_PrintDTTG(
    @MaGV CHAR(3))
RETURNS TABLE
AS
    RETURN (SELECT DISTINCT DT.*
            FROM THAMGIADT TG
            JOIN DETAI DT ON TG.MaDT = DT.MaDT
            WHERE TG.MaGV = @MaGV)

GO
SELECT * FROM DBO.F_PrintDTTG('003')

-- Thủ tục
-- Câu 1: VIẾT THỦ TỤC THÊM ĐỀ TÀI
-- INPUT: CÁC THUỘC TÍNH CỦA ĐỀ TÀI
-- OUTPUT: 1 -> NẾU THÊM KO ĐC, 0 -> THÊM ĐƯỢC
-- ĐIỀU KIỆN:
---> MÃ ĐỀ TÀI KHÔNG ĐƯỢC TRÙNG
---> TÊN ĐỀ TÀI KHÔNG RỖNG
---> GIÁO VIÊN CHỦ NHIỆM PHẢI LÀ GIÁO VIÊN TRÊN 35 TUỔI
---> KINH PHÍ CỦA ĐỀ TÀI CẤP TRƯỜNG < 100; ĐHQG < 1000
---> NGÀY BẮT ĐẦU < NGÀY KẾT THÚC
GO
CREATE OR ALTER PROCEDURE SP_AddDT(
    @MaDT CHAR(3), @TenDT NVARCHAR(50), @CapQL NCHAR(8), @KinhPhi DECIMAL(6, 1), 
    @NgayBD DATE, @NgayKT DATE, @MaCD NCHAR(4), @GVCNDT CHAR(3)
)
AS
BEGIN
    IF EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT)
    BEGIN
        RETURN 0
    END

    IF (@TenDT IS NULL)
    BEGIN
        RETURN 0
    END

    DECLARE @NgaySinh DATE
    SELECT @NgaySinh = GV.NgaySinh
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @GVCNDT

    IF (YEAR(GETDATE()) - YEAR(@NgaySinh) <= 35)
    BEGIN
        RETURN 0
    END

    IF ((@CapQL = N'Trường' AND @KinhPhi >= 100) OR (@CapQL = N'ĐHQG' AND @KinhPhi >= 1000))
    BEGIN
        RETURN 0
    END

    IF (@NgayBD >= @NgayKT)
    BEGIN
        RETURN 0
    END

    RETURN 1
END

-- Câu 2: VIẾT THỦ TỤC XÓA ĐỀ TÀI CHƯA CÓ GIÁO VIÊN THAM GIA
-- INPUT: MÃ ĐT
-- OUTPUT: XÓA THÀNH CÔNG HAY KHÔNG
-- ĐIỀU KIỆN:
---> ĐỀ TÀI ĐÃ KẾT THÚC VÀ KHÔNG CÓ NGƯỜI THAM GIA
---> ĐỀ TÀI KHÔNG CÓ CHỦ NHIỆM
GO
CREATE OR ALTER PROCEDURE SP_DeleteDT(
    @MaDT CHAR(3))
AS
BEGIN
    IF EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT AND DT.NgayKT > GETDATE())
    BEGIN
        PRINT N'Không thể xoá đề tài có mã số ' + @MaDT + N' vì đề tài chưa kết thúc.' 
        RETURN 0
    END

    IF EXISTS (SELECT * FROM THAMGIADT TG WHERE TG.MaDT = @MaDT) 
    BEGIN
        PRINT N'Không thể xoá đề tài có mã số ' + @MaDT + N' vì đề tài có người tham gia'
        RETURN 0
    END

    IF EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT AND DT.GVCNDT IS NOT NULL)
    BEGIN
        PRINT N'Không thể xoá đề tài có mã số ' + @MaDT + N' vì đề tài có giáo viên chủ nhiệm.'
        RETURN 0
    END

    DELETE FROM DETAI
    WHERE MaDT = @MaDT
    PRINT N'Xoá thành công đề tài có mã số ' + @MaDT
    RETURN 1
END

-- Câu 3: VIẾT THỦ TỤC GIA HẠN ĐỀ TÀI
-- INPUT: MADT, NGAYKT
-- OUTPUT: GIA HẠN THÀNH CÔNG KHÔNG
-- ĐIỀU KIỆN
---> ĐỀ TÀI TỒN TẠI
---> ĐỀ TÀI ĐÃ BẮT ĐẦU VÀ CHƯA KẾT THÚC
---> ĐỀ TÀI ĐÃ CÓ ÍT NHẤT 1 GIÁO VIÊN THAM GIA
GO
CREATE OR ALTER PROCEDURE SP_ExtendDT(
    @MaDT CHAR(3), @NgayKT DATE)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT)
    BEGIN
        PRINT N'Không tồn tại đề tài có mã số ' + @MaDT
        RETURN 0
    END

    IF NOT EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT AND DT.NgayBD <= GETDATE())
    BEGIN
        PRINT N'Đề tài có mã số ' + @MaDT + N' chưa bắt đầu'
        RETURN 0
    END

    IF NOT EXISTS (SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT AND DT.NgayKT > GETDATE())
    BEGIN
        PRINT N'Đề tài có mã số ' + @MaDT + N' đã kết thúc'
        RETURN 0
    END

    IF NOT EXISTS (SELECT * FROM THAMGIADT TG WHERE TG.MaDT = @MaDT)
    BEGIN 
        PRINT N'Đề tài có mã số ' + @MaDT + N' không có giáo viên tham gia'
        RETURN 0
    END

    UPDATE DETAI SET NgayKT = @NgayKT WHERE MaDT = @MaDT
    PRINT N'Gia hạn đề tài có mã số ' + @MaDT + N' thành công'
    RETURN 1
END

-- Câu 4: VIẾT THỦ TỤC IN THÔNG TIN THỐNG KÊ SAU
-- INPUT: MAGV
-- MẪU THỐNG KÊ
---> MÃ GV:
---> HỌ TÊN:
---> TÊN BM:
---> SỐ ĐỀ TÀI THAM GIA:
---> DANH SÁCH ĐỀ TÀI THAM GIA
---	 MADT	TENDT	PHUCAP	KETQUA
GO
CREATE OR ALTER PROCEDURE SP_PrintGV(
    @MaGV CHAR(3))
AS
BEGIN
    PRINT N'MÃ GV: ' + @MaGV

    DECLARE @HoTen NVARCHAR(50)
    SELECT @HoTen = GV.HoTen
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaGV
    PRINT N'HỌ TÊN: ' + @HoTen

    DECLARE @TenBM NVARCHAR(50)
    SELECT @TenBM = BM.TenBM
    FROM GIAOVIEN GV
    JOIN BOMON BM ON BM.MaBM = GV.MaBM
    WHERE GV.MaGV = @MaGV
    PRINT N'TÊN BM: ' + @TenBM

    DECLARE @SLDTTG INT
    SELECT @SLDTTG = COUNT(DISTINCT TG.MaGV)
    FROM THAMGIADT TG
    WHERE TG.MaGV = @MaGV
    PRINT N'SỐ ĐỀ TÀI THAM GIA: ' + CAST(@SLDTTG AS NVARCHAR(5))

    PRINT N'DANH SÁCH ĐỀ TÀI THAM GIA: '

    DECLARE @I INT = 1
    DECLARE @N INT
    SELECT @N = COUNT(*)
    FROM (
        SELECT DISTINCT TG.MaDT
        FROM THAMGIADT TG
        WHERE TG.MaGV = @MaGV
    ) AS D

    DECLARE @MaDT CHAR(3), @TenDT NVARCHAR(50), @PhuCap DECIMAL(6, 1), @KetQua NVARCHAR(3)

    WHILE @I <= @N
    BEGIN
        SELECT @MaDT = MaDT, @TenDT = TenDT, @PhuCap = ISNULL(PhuCap, 0), @KetQua = ISNULL(KetQua, N'NULL')
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY DT.MaDT) AS STT, DT.MaDT, DT.TenDT, SUM(ISNULL(TG.PhuCap, 0)) AS PhuCap, MAX(ISNULL(TG.KetQua, N'NULL')) AS KetQua
            FROM DETAI DT
            JOIN THAMGIADT TG ON TG.MaDT = DT.MaDT
            WHERE TG.MaGV = @MaGV
            GROUP BY DT.MaDT, DT.TenDT
        ) AS DTG
        WHERE DTG.STT = @I
        
        PRINT @MaDT + CHAR(9) + @TenDT + CHAR(9) + CAST(@PhuCap AS NVARCHAR) + CHAR(9) + @KetQua
        
        SET @I = @I + 1
    END
END
GO

EXEC SP_PrintGV '001'

-- Câu 5: VIẾT THỦ TỤC IN THÔNG TIN THỐNG KÊ SAU
-- INPUT: MADT
-- MẪU THỐNG KÊ
--> MADT:
--> TÊN DT:
--> TÊN GVCN:
--> SỐ CÔNG VIỆC HOÀN THÀNH:
--> SỐ CÔNG VIỆC CHƯA HOÀN THÀNH:
--> DANH SÁCH CÔNG VIỆC TRONG ĐỀ TÀI
-- STT	TÊN CV	SỐGVTG	TỔNGPHUCAP
GO
CREATE OR ALTER PROCEDURE SP_PrintDT(
    @MaDT CHAR(3))
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_WARNINGS OFF;

    PRINT N'MADT: ' + @MaDT

    DECLARE @TenDT NVARCHAR(50)
    SELECT @TenDT = DT.TenDT
    FROM DETAI DT
    WHERE DT.MaDT = @MaDT
    PRINT N'Tên DT: ' + @TenDT

    DECLARE @GVCNDT CHAR(3)
    SELECT @GVCNDT = DT.GVCNDT
    FROM DETAI DT
    WHERE DT.MaDT = @MaDT
    PRINT N'Tên GVCN:' + @GVCNDT

    DECLARE @NC INT
    SELECT @NC = (SELECT COUNT(DISTINCT TG.STT)
                         FROM CONGVIEC CV 
                         LEFT JOIN THAMGIADT TG ON CV.MaDT = TG.MaDT
                         WHERE CV.MaDT = @MaDT AND TG.KetQua = N'Đạt')
    PRINT N'SỐ CÔNG VIỆC HOÀN THÀNH: ' + CAST(@NC AS NVARCHAR(5))

    DECLARE @ND INT
    SELECT @ND = (SELECT COUNT(*)
                         FROM (SELECT CV.STT
                               FROM CONGVIEC CV
                               WHERE CV.MaDT = @MaDT
                               EXCEPT
                               SELECT TG.STT
                               FROM CONGVIEC CV 
                               LEFT JOIN THAMGIADT TG ON CV.MaDT = TG.MaDT
                               WHERE CV.MaDT = @MaDT AND TG.KetQua = N'Đạt') SL)
    PRINT N'SỐ CÔNG VIỆC CHƯA HOÀN THÀNH: ' + CAST(@ND AS NVARCHAR(5))

    PRINT N'Danh sách công việc trong đề tài: '

    DECLARE @I INT, @N INT, @TenCV NVARCHAR(50), @SoGVTG INT, @TongPhuCap DECIMAL(6, 1)
    SELECT @I = 1, @N = (SELECT COUNT(*) FROM CONGVIEC WHERE MaDT = @MaDT)

    WHILE @I <= @N
    BEGIN
        SELECT @TenCV = DTG.TenCV, 
               @SoGVTG = ISNULL(DTG.SoGVTG, 0), 
               @TongPhuCap = ISNULL(DTG.TongPhuCap, 0)
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY CV.TenCV) AS STT, 
                   CV.TenCV, 
                   COUNT(DISTINCT TG.MaGV) AS SoGVTG, 
                   SUM(ISNULL(TG.PhuCap, 0)) AS TongPhuCap
            FROM CONGVIEC CV
            LEFT JOIN THAMGIADT TG ON TG.MaDT = CV.MaDT AND TG.STT = CV.STT
            WHERE CV.MaDT = @MaDT
            GROUP BY CV.MaDT, CV.TenCV
        ) AS DTG
        WHERE DTG.STT = @I
        
        PRINT CAST(@I AS NVARCHAR(5)) + SPACE(5) + @TenCV + SPACE(50 - LEN(@TenCV)) + CAST(@SoGVTG AS NVARCHAR(3)) + SPACE(5) + CAST(@TongPhuCap AS NVARCHAR(10))
        
        SET @I = @I + 1
    END
END 

EXEC SP_PrintDT '001'