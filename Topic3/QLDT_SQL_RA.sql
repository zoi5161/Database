USE QLDT
GO

-- Câu 1: Cho giáo viên (mã gv, họ tên) có tham gia đề tài do trưởng bộ môn họ chủ nhiệm.
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV 
JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN DETAI DT ON DT.GVCNDT = BM.TruongBM
JOIN THAMGIADT TGDT ON TGDT.MaDT = DT.MaDT

-- Câu 2: Cho trưởng khoa (mã gv, họ tên) của khoa có giáo viên “Nguyễn Thanh” làm việc.
SELECT DISTINCT TK.MaGV, TK.HoTen
FROM GIAOVIEN TK 
JOIN KHOA K ON TK.MaGV = K.TruongKhoa
JOIN BOMON BM ON BM.MaKhoa = K.MaKhoa
JOIN GIAOVIEN GV ON GV.MaBM = BM.MaBM
WHERE GV.HoTen = N'Nguyễn Thanh'

-- Câu 3: Cho bộ môn (mã BM, tên BM) có trưởng bộ môn nhỏ hơn 35 tuổi lúc nhận chức.
SELECT BM.MaBM, BM.TenBM
FROM BOMON BM 
JOIN GIAOVIEN GV ON GV.MaGV = BM.TruongBM
WHERE YEAR(BM.NgayNhanChuc) - YEAR(GV.NgaySinh) < 35

-- Câu 4: Cho giáo viên (mã gv, họ tên) đã từng tham gia công việc có tên là “Thiết kế” hoặc đã
-- từng chủ nhiệm đề tài có công việc có tên là “Xác định yêu cầu”.
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
JOIN CONGVIEC CV ON TG.MaDT = CV.MaDT
WHERE CV.TenCV LIKE N'%Thiết kế%'
UNION
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN DETAI DT ON DT.GVCNDT = GV.MaGV
JOIN CONGVIEC CV ON DT.MaDT = CV.MaDT
WHERE CV.TenCV LIKE N'%Xác định yêu cầu%'

-- Câu 5: Cho trưởng khoa (mã gv, họ tên) có tham gia đề tài thuộc chủ đề “nghiên cứu” nhưng
-- chưa từng tham gia đề tài nào thuộc chủ đề “ứng dụng”.
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MaGV = K.TruongKhoa
JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
JOIN DETAI D ON TG.MaDT = D.MaDT
JOIN CHUDE C ON D.MaCD = C.MaCD
WHERE C.TenCD LIKE N'%nghiên cứu%' 
AND NOT EXISTS (SELECT *
                FROM DETAI D2
                JOIN CHUDE C2 ON D2.MaCD = C2.MaCD
                JOIN THAMGIADT TG2 ON D2.MaDT = TG2.MaDT
                WHERE TG2.MaGV = GV.MaGV AND C2.TenCD LIKE N'%ứng dụng%')

-- Câu 6: Cho giáo viên (mã gv, họ tên) của giáo viên có tham gia đề tài cấp trường nhưng không
-- chủ nhiệm đề tài nào cấp trường.
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
JOIN DETAI DT ON DT.MaDT = TG.MaDT
WHERE DT.CapQL = N'Trường'
AND NOT EXISTS (SELECT *
                FROM DETAI D2
                WHERE GV.MaGV = D2.GVCNDT)

-- Câu 7: Cho trưởng bộ môn (mã gv, họ tên) có chủ nhiệm ít nhất một đề tài cấp nhà nước và
-- tham gia bất kỳ đề tài nào có công việc liên quan đến "nuôi cấy".
SELECT DISTINCT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MaGV = BM.TruongBM
JOIN DETAI DT ON  DT.GVCNDT = GV.MaGV
WHERE DT.CapQL = N'Nhà nước' 
AND EXISTS(SELECT *
           FROM THAMGIADT TG
           JOIN CONGVIEC CV ON TG.MaDT = CV.MaDT
           WHERE CV.TenCV LIKE N'%Nuôi cấy%')
GROUP BY GV.MaGV, GV.HoTen
HAVING COUNT(CapQL) > 1

-- Câu 8: Cho giáo viên (mã gv, họ tên) chỉ tham gia đề tài cấp nhà nước.
SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
JOIN DETAI DT ON TG.MaDT = DT.MaDT
WHERE DT.CapQL = N'Nhà nước'
EXCEPT
SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
JOIN DETAI DT ON TG.MaDT = DT.MaDT
WHERE DT.CapQL <> N'Nhà nước'


-- Câu 9: Cho đề tài (mã đt, tên đt) chỉ có giáo viên có vai trò quản lý chuyên môn tham gia.
SELECT DISTINCT DT.MaDT, DT.TenDT
FROM DETAI DT
JOIN THAMGIADT TGDT ON DT.MaDT = TGDT.MaDT
JOIN GIAOVIEN GV ON TGDT.MaGV = GV.MaGV
WHERE GV.MaGV IN (
    SELECT DISTINCT GVQLCM
    FROM GIAOVIEN
    WHERE GVQLCM IS NOT NULL
)
AND NOT EXISTS (
    SELECT *
    FROM THAMGIADT TG
    JOIN GIAOVIEN G ON TG.MaGV = G.MaGV
    WHERE TG.MaDT = DT.MaDT AND G.GVQLCM IS NULL
)

-- Câu 10: Cho mã, họ tên giáo viên và số lượng giáo viên mà họ quản lý chuyên môn (nếu có).
SELECT QL.MaGV, QL.HoTen, COUNT(GV.MaGV) SLGV
FROM GIAOVIEN QL
LEFT JOIN GIAOVIEN GV ON GV.GVQLCM = QL.MaGV
GROUP BY QL.MaGV, QL.HoTen

-- Câu 11: Cho mã, họ tên giáo viên, tên khoa mà giáo viên thuộc về của các giáo viên từng chủ
-- nhiệm trên 2 đề tài có kinh phí >= 100 triệu.
SELECT GV.MaGV, GV.HoTen, K.TenKhoa
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
JOIN DETAI DT ON GV.MaGV = DT.GVCNDT
WHERE DT.KinhPhi >= 100.0
GROUP BY GV.MaGV, GV.HoTen, K.TenKhoa
HAVING COUNT(*) > 2

-- Câu 12: Cho mã, tên bộ môn, tên trưởng bộ môn của bộ môn có mức lương trung bình của các
-- giáo viên thấp nhất ở từng khoa.
WITH AvgLuongGV AS (
    SELECT BM.MaBM, BM.TenBM, BM.TruongBM, K.MaKhoa, AVG(gv.Luong) AvgLuongGV
    FROM BOMON BM
    JOIN GIAOVIEN GV ON BM.MaBM = GV.MaBM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    GROUP BY BM.MaBM, BM.TenBM, BM.TruongBM, K.MaKhoa
),
MinAvgLuongGV AS (
    SELECT MaKhoa, MIN(AvgLuongGV) MinAvgLuong
    FROM AvgLuongGV
    GROUP BY MaKhoa
)
SELECT AVG.MaBM, AVG.TenBM, AVG.TruongBM
FROM AvgLuongGV AVG
JOIN MinAvgLuongGV M ON AVG.AvgLuongGV = M.MinAvgLuong

-- Câu 13: Cho biết mã, tên khoa, tên trưởng khoa của khoa có số lượng giáo viên có tham gia
-- đề tài là nhiều nhất.
WITH SUMKHOA AS (
    SELECT K.MaKhoa, K.TenKhoa, K.TruongKhoa, COUNT(DISTINCT GV.MaGV) SLTGDT
    FROM GIAOVIEN GV 
    JOIN BOMON BM ON GV.MABM = BM.MaBM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    GROUP BY K.MaKhoa, K.TenKhoa, K.TruongKhoa
)
SELECT MaKhoa, TenKhoa, GV.HoTen
FROM SUMKHOA S
JOIN GIAOVIEN GV ON TruongKhoa = GV.MaGV
WHERE S.SLTGDT = (SELECT MAX(SLTGDT) FROM SUMKHOA)

-- Câu 14: Cho mã, tên chủ đề, cấp quản lý và số lượng đề tài có kinh phí từ 100 triệu trở lên theo
-- từng cấp quản lý của mỗi chủ đề.
SELECT CD.MaCD, CD.TenCD, DT.CapQL, COUNT(*) SLDT
FROM DETAI DT
JOIN CHUDE CD ON DT.MaCD = CD.MaCD
WHERE DT.KinhPhi >= 100.0
GROUP BY CD.MaCD, CD.TenCD, DT.CapQL;

-- Câu 15: Cho mã và tên đề tài của đề tài có đông giáo viên tham gia nhất.
-- Cách 1:
WITH SUMGV AS (
    SELECT DT.MaDT, DT.TenDT, COUNT(DISTINCT TG.MaGV) SLGV
    FROM DETAI DT
    JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
    GROUP BY DT.MaDT, DT.TenDT
)
SELECT TOP 1 MaDT, TenDT 
FROM SUMGV
ORDER BY SLGV DESC

-- Cách 2:
WITH SUMGV AS (
    SELECT DT.MaDT, DT.TenDT, COUNT(DISTINCT TG.MaGV) AS SLGV
    FROM DETAI DT
    JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
    GROUP BY DT.MaDT, DT.TenDT
)
SELECT MaDT, TenDT
FROM SUMGV
WHERE SLGV = (
    SELECT MAX(SLGV) 
    FROM SUMGV
);

-- Câu 16: Cho trưởng khoa (mã gv, họ tên, tên khoa) của khoa có số lượng bộ môn nhiều nhất
-- hoặc có lương trung bình của giáo viên trong khoa là thấp nhất.
WITH AVGLUONG AS (
    SELECT TK.MaGV, TK.HoTen, K.TenKhoa, AVG(GV.Luong) AVGLUONG
    FROM GIAOVIEN GV
    JOIN BOMON BM ON GV.MaBM = BM.MaBM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    JOIN GIAOVIEN TK ON TK.MaGV = K.TruongKhoa
    GROUP BY TK.MaGV, TK.HoTen, K.TenKhoa
), MINLUONG AS (
    SELECT TOP 1 A.MaGV, A.HoTen, A.TenKhoa
    FROM AVGLUONG A
    ORDER BY A.AVGLUONG ASC
), SUMBM AS (
    SELECT TK.MaGV, TK.HoTen, K.TenKhoa, COUNT(DISTINCT BM.MaBM) SLBM
    FROM BOMON BM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    JOIN GIAOVIEN TK ON TK.MaGV = K.TruongKhoa
    GROUP BY TK.MaGV, TK.HoTen, K.TenKhoa
)
SELECT *
FROM MINLUONG
UNION
SELECT S.MaGV, S.HoTen, S.TenKhoa
FROM SUMBM S
WHERE SLBM = (SELECT MAX(SLBM) FROM SUMBM)

-- Câu 17: Cho mã và tên giáo viên chủ nhiệm nhiều đề tài cấp nhà nước nhất hoặc tham gia
-- nhiều đề tài thuộc chủ đề giáo dục nhất.
WITH SUMGVCNDT AS (
    SELECT GV.MaGV, GV.HoTen, COUNT(DT.GVCNDT) SLDT
    FROM GIAOVIEN GV
    JOIN DETAI DT ON GV.MaGV = DT.GVCNDT
    WHERE DT.CapQL = N'Nhà nước'
    GROUP BY GV.MaGV, GV.HoTen
), MAXGVCNDT AS (
    SELECT MaGV, HoTen, SLDT
    FROM SUMGVCNDT
    WHERE SLDT = (SELECT MAX(SLDT) FROM SUMGVCNDT)
), SUMTGDT AS (
    SELECT GV.MaGV, GV.HoTen, COUNT(TG.MaDT) SLDTTG
    FROM GIAOVIEN GV
    JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    JOIN DETAI DT ON TG.MaDT = DT.MaDT
    JOIN CHUDE CD ON DT.MaCD = CD.MaCD
    WHERE CD.TenCD LIKE N'%giáo dục%'
    GROUP BY GV.MaGV, GV.HoTen
), MAXTGDT AS (
    SELECT MaGV, HoTen, SLDTTG
    FROM SUMTGDT
    WHERE SLDTTG = (SELECT MAX(SLDTTG) FROM SUMTGDT)
)
SELECT MGVCN.MaGV, MGVCN.HoTen
FROM MAXGVCNDT MGVCN
UNION
SELECT MTGDT.MaGV, MTGDT.HoTen
FROM MAXTGDT MTGDT;

-- Câu 18: Xuất mã và họ tên giáo viên thuộc khoa “Công nghệ thông tin” có tham gia tất cả đề tài
-- thuộc cấp ĐHQG.
WITH COUNTDT AS (
    SELECT COUNT(*) SLDT
    FROM DETAI DT
    WHERE DT.CapQL = N'ĐHQG'
), SUMDT AS (
    SELECT GV.MaGV, GV.HoTen, COUNT(DISTINCT DT.MaDT) SLDT
    FROM GIAOVIEN GV
    JOIN BOMON BM ON GV.MaBM = BM.MaBM
    JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
    JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    JOIN DETAI DT ON TG.MaDT = DT.MaDT
    WHERE K.TenKhoa = N'Công nghệ thông tin' AND DT.CapQL = N'ĐHQG'
    GROUP BY GV.MaGV, GV.HoTen
)
SELECT S.MaGV, S.HoTen
FROM SUMDT S
WHERE S.SLDT = (SELECT C.SLDT FROM COUNTDT C)

-- Câu 19: Xuất mã, họ tên trưởng khoa có các đề tài tham gia bao phủ tất cả các chủ đề.
WITH SUMCD AS (
    SELECT COUNT(*) SLCD
    FROM CHUDE
), SLDTTG AS (
    SELECT GV.MaGV, GV.HoTen, COUNT(DISTINCT DT.MaCD) SLCDTG
    FROM GIAOVIEN GV
    JOIN KHOA K ON GV.MaGV = K.TruongKhoa
    JOIN THAMGIADT TG ON K.TruongKhoa = TG.MaGV
    JOIN DETAI DT ON TG.MaDT = DT.MaDT
    GROUP BY GV.MaGV, GV.HoTen
)
SELECT S.MaGV, S.HoTen
FROM SLDTTG S
WHERE S.SLCDTG = (SELECT SLCD FROM SUMCD)

-- Câu 20: Xuất mã, tên đề tài, tên công việc có tất cả giáo viên có lương 2000-3000 tham gia.
WITH SUMGV AS (
    SELECT COUNT(*) SLGV
    FROM GIAOVIEN GV
    WHERE GV.Luong >= 2000 AND GV.Luong <= 3000
), SLGVTG AS (
    SELECT DT.MaDT, DT.TenDT, CV.TENCV, COUNT(DISTINCT TG.MaGV) SLGVTGCV
    FROM GIAOVIEN GV
    JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    JOIN DETAI DT ON TG.MaDT = DT.MaDT
    JOIN CONGVIEC CV ON (TG.STT = CV.STT AND TG.MaDT = CV.MaDT)
    WHERE GV.Luong >= 2000 AND GV.Luong <= 3000
    GROUP BY DT.MaDT, DT.TenDT, CV.TENCV
)
SELECT S.MaDT, S.TenDT, S.TenCV
FROM SLGVTG S
WHERE S.SLGVTGCV = (SELECT SLGV FROM SUMGV)

-- Test
-- C1:
SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
JOIN DETAI DT ON GV.MaGV = DT.GVCNDT
JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
WHERE NT.QuanHe = N'Vợ chồng'

-- C2:
SELECT DT.MaDT, DT.TenDT
FROM DETAI DT
JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
JOIN GIAOVIEN GV ON TG.MaGV = GV.MaGV
JOIN BOMON BM ON GV.MaBM = BM.MaBM
WHERE BM.TenBM = N'Công nghệ phần mềm'
EXCEPT
SELECT DT.MaDT, DT.TenDT
FROM DETAI DT
JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
JOIN GIAOVIEN GV ON TG.MaGV = GV.MaGV
JOIN BOMON BM ON GV.MaBM = BM.MaBM
WHERE BM.TenBM <> N'Công nghệ phần mềm'

-- C3:
WITH SUMGV AS (
    SELECT DT.MaDT, DT.TenDT, COUNT(DISTINCT TG.MaGV) SLGV
    FROM GIAOVIEN GV
    JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
    JOIN DETAI DT ON TG.MaDT = DT.MaDT
    JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
    WHERE NT.QuanHe = N'Vợ chồng'
    GROUP BY DT.MaDT, DT.TenDT
)
SELECT MaDT, TenDT
FROM SUMGV
WHERE SLGV = (
    SELECT MAX(SLGV) 
    FROM SUMGV
)

-- C4:
WITH SUMGVCoCon AS (
    SELECT COUNT(*) SLGVCoCon
    FROM GIAOVIEN GV
    JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
    WHERE NT.QuanHe = N'Con cái'
)