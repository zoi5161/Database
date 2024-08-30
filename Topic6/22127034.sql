USE QLDT
GO

-- Q58: Cho biết tên giáo viên nào tham gia đề tài đủ tất cả các chủ đề
SELECT GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT, CHUDE CD
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.MaCD = CD.MaCD
GROUP BY GV.HoTen
HAVING COUNT(DISTINCT CD.MaCD) = (SELECT COUNT(*)
                                  FROM CHUDE)

-- Q59: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia
SELECT DT.TenDT
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND GV.MaBM = N'HTTT'
GROUP BY DT.TenDT
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                   FROM GIAOVIEN GV
                                   WHERE GV.MaBM = N'HTTT')

-- Q60: Cho biết tên đề tài có tất cả giảng viên bộ môn "Hệ thống thông tin" tham gia
SELECT DT.TenDT
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG, BOMON BM
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND GV.MaBM = BM.MaBM AND BM.TenBM = N'Hệ thống thông tin'
GROUP BY DT.TenDT
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                   FROM GIAOVIEN GV 
                                   JOIN BOMON BM ON GV.MaBM = BM.MaBM
                                   WHERE GV.MaBM = BM.MaBM AND BM.TenBM = N'Hệ thống thông tin')

-- Q61: Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD
SELECT GV.HoTen
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.MaCD = N'QLGD'
GROUP BY GV.HoTen
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                  FROM DETAI
                                  WHERE MaCD = N'QLGD')

-- Q62: Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên 
-- Trần Trà Hương đã tham gia
SELECT GV.HoTen
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MaDT
                  FROM DETAI DT
                  JOIN THAMGIADT TG ON DT.MaDT = TG.MaDT
                  WHERE TG.MaGV = (SELECT MaGV
                                   FROM GIAOVIEN
                                   WHERE HoTen = N'Trần Trà Hương')
                   AND NOT EXISTS (SELECT *
                                   FROM THAMGIADT TG2
                                   WHERE TG2.MaDT = DT.MaDT
                                   AND TG2.MaGV = GV.MaGV
                                   AND GV.HoTen <> N'Trần Trà Hương'))
    
-- Q63: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn
-- Hoá Hữu Cơ tham gia
SELECT DT.TenDT
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG, BOMON BM
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND GV.MaBM = BM.MaBM AND BM.TenBM = N'Hoá hữu cơ'
GROUP BY DT.TenDT
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                   FROM GIAOVIEN GV 
                                   JOIN BOMON BM ON GV.MaBM = BM.MaBM
                                   WHERE GV.MaBM = BM.MaBM AND BM.TenBM = N'Hoá hữu cơ')

-- Q64: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006
SELECT GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND TG.MaDT = '006'
GROUP BY GV.HoTen
HAVING COUNT(*) = (SELECT COUNT(*)
                   FROM DETAI DT
                   JOIN CONGVIEC CV ON DT.MaDT = CV.MaDT
                   WHERE CV.MaDT = '006')

-- Q65: Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của chủ đề
-- Ứng dụng công nghệ
SELECT GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT, CHUDE CD
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.MaCD = CD.MaCD AND CD.TenCD = N'Ứng dụng công nghệ'
GROUP BY GV.HoTen
HAVING COUNT(DISTINCT CD.MaCD) = (SELECT COUNT(*)
                                  FROM CHUDE CD
                                  JOIN DETAI DT ON CD.MaCD = DT.MaCD
                                  WHERE CD.TenCD = N'Ứng dụng công nghệ')

-- Q66: Cho biết tên giáo viên nào đã tham gia tất cả các đề tài do Trần Trà Hương
-- làm chủ nhiệm
SELECT GV.HoTen
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DISTINCT DT.MaDT
                  FROM DETAI DT
                  JOIN THAMGIADT TG ON TG.MaDT = DT.MaDT
                  WHERE DT.GVCNDT = (SELECT MaGV
                                     FROM GIAOVIEN
                                     WHERE HoTen = N'Trần Trà Hương')
                  AND NOT EXISTS (SELECT TG2.MaDT
                                  FROM THAMGIADT TG2
                                  WHERE TG2.MaDT = DT.MaDT
                                  AND TG2.MaGV = GV.MaGV
                                  AND GV.HoTen <> N'Trần Trà Hương'))

-- Q67: Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia
SELECT DT.TenDT, COUNT(DISTINCT TG.MaGV)
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG, BOMON BM
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND GV.MaBM = BM.MaBM AND BM.MaKhoa = N'CNTT'
GROUP BY DT.TenDT
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                  FROM GIAOVIEN GV 
                                  JOIN BOMON BM ON GV.MaBM = BM.MaBM
                                  WHERE GV.MaBM = BM.MaBM AND BM.MaKhoa = N'CNTT')

-- Q68: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 
-- Nghiên cứu tế bào gốc
SELECT GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.TenDT = N'Nghiên cứu tế bào gốc'
GROUP BY GV.HoTen
HAVING COUNT(*) = (SELECT COUNT(*)
                   FROM DETAI DT
                   JOIN CONGVIEC CV ON DT.MaDT = CV.MaDT
                   WHERE DT.TenDT = N'Nghiên cứu tế bào gốc')

-- Q69: Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí 
-- trên 100 triệu
SELECT GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.KinhPhi > 100
GROUP BY GV.HoTen
HAVING COUNT(DISTINCT TG.MaDT) = (SELECT COUNT(*)
                                  FROM DETAI DT
                                  WHERE DT.KinhPhi > 100)

-- Q70: Cho biết tên đề tài nào mà được tất cả giáo viên của khoa Sinh học tham gia
SELECT DT.TenDT
FROM DETAI DT, GIAOVIEN GV, THAMGIADT TG, BOMON BM, KHOA K
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND GV.MaBM = BM.MaBM AND BM.MaKhoa = K.MaKhoa
  AND K.TenKhoa = N'Sinh học'
GROUP BY DT.TenDT
HAVING COUNT(DISTINCT TG.MaGV) = (SELECT COUNT(*)
                                   FROM GIAOVIEN GV 
                                   JOIN BOMON BM ON GV.MaBM = BM.MaBM
                                   JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
                                   WHERE K.TenKhoa = N'Sinh học')


-- Q71: Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc
-- của đề tài "Ứng dụng hoá học xanh"
SELECT GV.MaGV, GV.HoTen, GV.NgaySinh
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.TenDT = N'Ứng dụng hoá học xanh'
GROUP BY GV.MaGV, GV.HoTen, GV.NgaySinh
HAVING COUNT(*) = (SELECT COUNT(*)
                   FROM DETAI DT
                   JOIN CONGVIEC CV ON DT.MaDT = CV.MaDT
                   WHERE DT.TenDT = N'Ứng dụng hoá học xanh')

-- Q72: Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của 
-- giáo viên tham  gia tất cả các đề tài thuộc chủ đề "Nghiên cứu phát triển"
SELECT GV.MaGV, GV.HoTen, BM.MaBM, GV.GVQLCM
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT, CHUDE CD, BOMON BM
WHERE GV.MaBM = BM.MaBM AND GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT
  AND DT.MaCD = CD.MaCD AND CD.TenCD = N'Nghiên cứu phát triển'
GROUP BY GV.MaGV, GV.HoTen, BM.MaBM, GV.GVQLCM
HAVING COUNT(DISTINCT CD.MaCD) = (SELECT COUNT(*)
                                  FROM CHUDE CD
                                  JOIN DETAI DT ON CD.MaCD = DT.MaCD
                                  WHERE CD.TenCD = N'Nghiên cứu phát triển')