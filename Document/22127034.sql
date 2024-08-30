USE QLDT
GO

-- Câu 1: Cho biết thông tin mã và tên người quản lý của giáo viên tham gia nhiều đề tài thuộc chủ đề giáo dục nhất. 
SELECT GV2.MaGV, GV2.HoTen
FROM (SELECT GV.MaGV, COUNT(DISTINCT TG.MaDT) SL
      FROM GIAOVIEN GV
      JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
      JOIN DETAI DT ON DT.MaDT = TG.MaDT
      JOIN CHUDE CD ON DT.MaCD = CD.MaCD
      WHERE CD.TenCD LIKE N'%giáo dục%'
      GROUP BY GV.MaGV) SLTG
JOIN GIAOVIEN GV ON SLTG.MaGV = GV.MaGV
JOIN GIAOVIEN GV2 ON GV.GVQLCM = GV2.MaGV
WHERE SLTG.SL = (SELECT MAX(SLTG.SL) 
                 FROM (SELECT GV.MaGV, COUNT(DISTINCT TG.MaDT) SL
                       FROM GIAOVIEN GV
                       JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
                       JOIN DETAI DT ON DT.MaDT = TG.MaDT
                       JOIN CHUDE CD ON DT.MaCD = CD.MaCD
                       WHERE CD.TenCD LIKE N'%giáo dục%'
                       GROUP BY GV.MaGV) SLTG)

-- Câu 2: Cho biết trưởng khoa của giáo viên chủ nhiệm đề tài có tất cả giáo viên có họ Nguyễn hơn 30 tuổi tham gia.
SELECT K.TruongKhoa
FROM (SELECT TG.MaDT, COUNT(DISTINCT TG.MaGV) SL
      FROM GIAOVIEN GV
      JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
      WHERE GV.HoTen LIKE N'Nguyễn%' AND (YEAR(GETDATE()) - YEAR(GV.NgaySinh) <= 30)
      GROUP BY TG.MaDT) SLDT
JOIN DETAI DT ON SLDT.MaDT = DT.MaDT
JOIN GIAOVIEN GV ON GV.MaGV = DT.GVCNDT
JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
JOIN GIAOVIEN GVQL ON GVQL.MaGV = K.TruongKhoa
WHERE SLDT.SL = (SELECT COUNT(*) FROM GIAOVIEN GV WHERE GV.HoTen LIKE N'Nguyễn%' AND (YEAR(GETDATE()) - YEAR(GV.NgaySinh) <= 30))

-- Câu 3: Cài đặt stored procedure sp_ThemPC_MSSV (thay MSSV bằng mã số của sinh viên) nhận vào mã giáo viên, 
-- mã đề tài, số thứ tự, phụ cấp và thêm phân công này cho giáo viên thoả các điều kiện sau:
---- Giáo viên và đề tài phải tồn tại.
---- Mức phụ cấp của đề tài phải > 0.
---- Trong một đề tài, mỗi giáo viên chỉ được tham gia tối đa 3 công việc (sử dụng function để đếm số lượng công việc cho một đề tài mà một giáo viên tham gia).
---- Trong một đề tài, nếu có trưởng bộ môn hay trưởng khoa của giáo viên cùng tham gia thì mức phụ cấp của giáo viên không được vượt quá trưởng bộ môn hay trưởng khoa của họ.
-- Khi các điều kiện thoả mã thì thêm phân công vào và trả về 1 báo hiệu thành công, ngược lại trả về mã lỗi thất bại. Lưu ý: sinh viên cần có chú thích ghi chú các bước làm.
GO
CREATE OR ALTER FUNCTION F_TinhSLCV(
    @MaGV CHAR(3), @MaDT CHAR(3))
RETURNS INT
AS
BEGIN
    DECLARE @SL INT
    SET @SL = (SELECT COUNT(*)
              FROM GIAOVIEN GV
              JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
              WHERE TG.MaDT = @MaDT AND GV.MaGV = @MaGV)
    RETURN ISNULL(@SL, 0)
END

GO
CREATE OR ALTER PROCEDURE sp_ThemPC_22127034(
    @MaGV CHAR(3), @MaDT CHAR(3), @STT INT, @PhuCap DECIMAL(2, 1))
AS
BEGIN
    -- Giáo viên và đề tài phải tồn tại.
    IF NOT EXISTS(SELECT * FROM GIAOVIEN GV WHERE GV.MaGV = @MaGV) OR NOT EXISTS(SELECT * FROM DETAI DT WHERE DT.MaDT = @MaDT) RETURN 0
    
    -- Mức phụ cấp của đề tài phải > 0.
    IF (@PhuCap <= 0) RETURN 0

    -- Trong một đề tài, mỗi giáo viên chỉ được tham gia tối đa 3 công việc (sử dụng function để đếm số lượng công việc cho một đề tài mà một giáo viên tham gia).
    IF ((SELECT DBO.F_TinhSLCV(@MaGV, @MaDT) SL) > 3) RETURN 0

    -- Trong một đề tài, nếu có trưởng bộ môn hay trưởng khoa của giáo viên cùng tham gia thì mức phụ cấp của giáo viên không được vượt quá trưởng bộ môn hay trưởng khoa của họ.
    -- IF NOT EXISTS (SELECT *
    --                FROM GIAOVIEN GV
    --                JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    --                JOIN BOMON BM ON BM.MaBM = GV.MaBM)
END

-- Câu 4: Cài đặt stored procedure sp_InKhoa_MSSV (thay MSSV bằng mã số của sinh viên) nhận vào mã khoa và in thông tin của khoa theo mẫu sau. 
---- Khoa: mã khoa – tên khoa
---- Trưởng khoa: mã gv – tên gv
---- Số lượng bộ môn thuộc khoa: … 
---- Số lượng giảng viên của khoa: …
GO
CREATE OR ALTER PROCEDURE sp_InKhoa_22127034(
    @MaKhoa VARCHAR(4))
AS
BEGIN
    DECLARE @TenKhoa NVARCHAR(50)
    SELECT @TenKhoa = K.TenKhoa
    FROM KHOA K
    WHERE K.MaKhoa = @MaKhoa
    PRINT N'Khoa: ' + @MaKhoa + ' - ' + @TenKhoa

    DECLARE @MaTK CHAR(3)
    SELECT @MaTK = K.TruongKhoa
    FROM GIAOVIEN GV
    JOIN BOMON BM ON BM.MaBM = GV.MaBM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    WHERE K.MaKhoa = @MaKhoa

    DECLARE @TenTK NVARCHAR(50)
    SELECT @TenTK = GV.HoTen
    FROM GIAOVIEN GV
    WHERE GV.MaGV = @MaTK
    PRINT N'Trưởng khoa: ' + @MaTK + ' - ' + @TenTK

    DECLARE @SLBM INT
    SET @SLBM = (SELECT COUNT(*)
                 FROM BOMON BM
                 JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
                 WHERE K.MaKhoa = @MaKhoa)
    PRINT N'Số lượng bộ môn thuộc khoa: ' + CAST(@SLBM AS VARCHAR(5))

    DECLARE @SLGV INT
    SET @SLGV = (SELECT COUNT(*)
                 FROM GIAOVIEN GV
                 JOIN BOMON BM ON GV.MaBM = BM.MaBM
                 JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
                 WHERE K.MaKhoa = @MaKhoa)
    PRINT N'Số lượng giảng viên của khoa: ' + CAST(@SLGV AS VARCHAR(5))
END

GO
EXEC sp_InKhoa_22127034 'CNTT'