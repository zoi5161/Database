USE QLDT
GO 

/*
SELECT k.*, TK.*
FROM KHOA k LEFT JOIN GIAOVIEN TK ON k.TruongKhoa = TK.MaGV
ORDER BY TK.MaGV

-- LEFT JOIN: giữ toàn bộ bảng bên trái (Nếu không thoả điều kiện -> Bên phải sẽ là NULL)
-- RIGHT JOIN: giữ toàn bộ bảng bên phải
*/


-- Q1: Cho biết họ tên và mức lương giáo viên nữ
SELECT GV.HoTen, GV.Luong, GV.Phai
FROM GIAOVIEN GV
WHERE GV.Phai = N'Nữ'

-- Q2: Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%
SELECT GV.HoTen, GV.Luong * 1.1 LuongTang
FROM GIAOVIEN GV

-- Q3: Cho biết mã của các giáo viên có họ tên bắt đầu là "Nguyễn" và lương trên $2000 hoặc, giáo viên là trưởng bộ môn nhận chức sau năm 1995
SELECT DISTINCT GV.MaGV
FROM GIAOVIEN GV, BOMON BM
WHERE (GV.HoTen LIKE N'Nguyễn%' AND GV.Luong > 2000.0) 
OR (GV.MaGV = BM.TruongBM AND (YEAR(BM.NgayNhanChuc) > 1995))
ORDER BY GV.MaGV

-- Q4: Cho biết tên những giáo viên khoa Công nghệ thông tin
SELECT GV.HoTen
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN KHOA K ON (BM.MaKhoa = K.MaKhoa AND K.TenKhoa = N'Công nghệ thông tin')

-- Q5: Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
SELECT GV.*, BM.TenBM, BM.Phong, BM.DienThoai, BM.TruongBM, BM.MaKhoa, BM.NgayNhanChuc
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaGV = BM.TruongBM

-- Q6: Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
SELECT GV.MaGV, GV.HoTen, BM.*
FROM GIAOVIEN GV LEFT JOIN BOMON BM ON GV.MaBM = BM.MaBM

-- Q7: Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
SELECT DT.TenDT, GV.HoTen
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MaGV = DT.GVCNDT

-- Q8: Với mỗi khoa cho biết thông tin trưởng khoa
SELECT K.MaKhoa, K.TenKhoa, GV.*
FROM GIAOVIEN GV LEFT JOIN KHOA K ON GV.MaGV = K.TruongKhoa

-- Q9: Cho biết các giáo viên của bộ môn "Vi sinh" có tham gia đề tài 006
SELECT DISTINCT GV.MaGV
FROM GIAOVIEN GV, THAMGIADT TG, BOMON BM
WHERE GV.MaBM = BM.MaBM AND BM.TenBM = N'Vi sinh' 
AND GV.MaGV = TG.MaGV AND TG.MaDT = '006'

-- Q10: Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài, 
-- đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng ngày sinh và địa chỉ của người ấy
SELECT DT.MaDT, DT.TenDT, DT.CapQL, CD.MaCD, CD.TenCD, DT.GVCNDT, GV.HoTen, GV.NgaySinh, GV.DiaChi
FROM GIAOVIEN GV, DETAI DT, CHUDE CD
WHERE DT.CapQL = N'Thành phố' AND DT.MaCD = CD.MaCD
AND DT.GVCNDT = GV.MaGV

-- Q11: Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT GV.HoTen, QLCM.GVQLCM
FROM GIAOVIEN GV LEFT JOIN GIAOVIEN QLCM ON GV.GVQLCM = QLCM.GVQLCM

-- Q12: Tìm họ tên của những giáo viên được "Nguyễn Thanh Tùng" phụ trách trực tiếp
SELECT GV.HoTen
FROM GIAOVIEN GV JOIN GIAOVIEN QL ON (GV.GVQLCM = QL.MaGV AND QL.HoTen = N'Nguyễn An Trung')

-- Q13: Cho biết tên giáo viên là trưởng bộ môn "Hệ thống thông tin"
SELECT GV.HoTen
FROM GIAOVIEN GV JOIN BOMON BM ON (GV.MaGV = BM.TruongBM AND BM.TenBM = N'Hệ thống thông tin')

-- Q14: Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục
SELECT DISTINCT GV.HoTen
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MaGV = DT.GVCNDT
JOIN CHUDE CD ON (DT.MaCD = CD.MaCD AND CD.TenCD = N'Quản lý giáo dục')

-- Q15: Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008
SELECT CV.TenCV
From DETAI DT JOIN CONGVIEC CV ON (DT.MaDT = CV.MaDT AND DT.TenDT = N'HTTT quản lý các trường ĐH'
AND MONTH(CV.NgayBD) = 3 AND YEAR(CV.NgayBD) = 2008)

-- Q16: Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
SELECT GV.HoTen, QL.HoTen
FROM GIAOVIEN GV LEFT JOIN GIAOVIEN QL ON GV.GVQLCM = QL.MaGV

-- Q17: Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
SELECT CV.*
FROM CONGVIEC CV
WHERE CV.NgayBD >= '2007-01-01' AND CV.NgayBD <= '2007-08-01'

-- Q18: Cho biết họ tên các giáo viên cùng bộ môn với giáo viên "Trần Trà Hương"
SELECT BM.HoTen
FROM GIAOVIEN GV, GIAOVIEN BM
WHERE GV.MaBM = BM.MaBM AND GV.HoTen = N'Trần Trà Hương' AND BM.HoTen <> N'Trần Trà Hương'

-- Q19: Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài
SELECT DISTINCT GV.*
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaGV = BM.TruongBM
JOIN DETAI DT ON GV.MaGV = DT.GVCNDT

-- Q20: Cho biết tên những giáo viên vừa là trưởng khoa vừa là trưởng bộ môn
SELECT GV.HoTen
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaGV = BM.TruongBM
JOIN KHOA K ON GV.MaGV = K.TruongKhoa
ORDER BY GV.MaGV

-- Q21: Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
SELECT DISTINCT GV.HoTen
FROM BOMON BM JOIN GIAOVIEN GV ON BM.TruongBM = GV.MaGV
JOIN DETAI DT ON GV.MaGV = DT.GVCNDT

-- Q22: Cho biết mã số các trưởng khoa có chủ nhiệm đề tài
SELECT DISTINCT TruongKhoa
FROM KHOA
INTERSECT
SELECT DISTINCT GVCNDT
FROM DETAI

-- Q23: Cho biết mã số các giáo viên thuộc bộ môn "HTTT" hoặc có tham gia đề tài mã "001"
SELECT DISTINCT GV.MaGV
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MaBM = N'HTTT' OR (GV.MaGV = TG.MaGV AND TG.MaDT = '001')

-- Q24: Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
SELECT BM.*
FROM GIAOVIEN GV JOIN GIAOVIEN BM ON (GV.MaBM = BM.MaBM AND GV.MaGV = '002' AND BM.MaGV <> '002')

-- Q25: Tìm những giáo viên là trưởng bộ môn
SELECT GV.*
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaGV = BM.TruongBM
ORDER BY GV.MaGV

-- Q26: Cho biết họ tên và mức lương của các giáo viên
SELECT GV.HoTen, GV.Luong
FROM GIAOVIEN GV

-- DEMO GROUP HAVING
SELECT COUNT(DISTINCT MADT) SLDT 
FROM THAMGIADT
WHERE MaGV = '001'

SELECT MaGV, COUNT(DISTINCT MaDT) SLDT 
FROM THAMGIADT
GROUP BY MaGV
HAVING MaGV = '001'

SELECT GVCNDT, COUNT(*) SLDT
FROM DETAI
GROUP BY GVCNDT

SELECT DT.MaDT, DT.TenDT, COUNT(TG.MaGV) SLGVTG
FROM DETAI DT LEFT JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
GROUP BY TG.MaGV
 
-- Test
/*
SELECT * FROM GIAOVIEN
SELECT * FROM GV_DT
SELECT * FROM BOMON
SELECT * FROM KHOA
SELECT * FROM DETAI
SELECT * FROM CHUDE
SELECT * FROM CONGVIEC
SELECT * FROM THAMGIADT
SELECT * FROM NGUOITHAN
*/