USE QLDT
GO

-- Q35: Cho biết mức lương cao nhất của các giảng viên.
SELECT MAX(Luong) MaxLuong
FROM GIAOVIEN

-- Q36: Cho biết những giáo viên có lương lớn nhất.
SELECT *
FROM GIAOVIEN GV 
WHERE GV.Luong = (SELECT MAX(Luong)
                  FROM GIAOVIEN)

-- Q37: Cho biết lương cao nhất trong bộ môn “HTTT”.
SELECT MAX(Luong) MaxLuong
FROM GIAOVIEN GV
WHERE MaBM = N'HTTT'

-- Q38: Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin.
SELECT GV.HoTen
FROM GIAOVIEN GV
WHERE GV.NgaySinh IN (SELECT MIN(NgaySinh)
                      FROM GIAOVIEN GV 
                      JOIN BOMON BM ON GV.MaBM = BM.MaBM
                      WHERE BM.TenBM = N'Hệ thống thông tin')

-- Q39: Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin.
SELECT GV.HoTen
FROM GIAOVIEN GV
WHERE GV.NgaySinh IN (SELECT MAX(NgaySinh)
                      FROM GIAOVIEN GV 
                      JOIN BOMON BM ON GV.MaBM = BM.MaBM
                      JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
                      WHERE K.TenKhoa = N'Công nghệ thông tin')

-- Q40: Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất.
SELECT GV.HoTen, K.TenKhoa
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
WHERE GV.LUONG IN (SELECT MAX(Luong) MaxLuong
                   FROM GIAOVIEN GV)

-- Q41: Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.
SELECT GV.*
FROM GIAOVIEN GV JOIN (SELECT MaBM, MAX(LUONG) MaxLuong
                       FROM GIAOVIEN
                       GROUP BY MaBM) M
ON GV.MaBM = M.MaBM AND GV.Luong = M.MaxLuong

-- Q42: Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
SELECT DISTINCT DT.TenDT
FROM DETAI DT
WHERE DT.MaDT NOT IN (SELECT DISTINCT TG.MaDT
                  FROM GIAOVIEN GV
                  JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
                  WHERE GV.HoTen = N'Nguyễn Hoài An')

-- Q43: Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài,
-- tên người chủ nhiệm đề tài.
SELECT DISTINCT DT.TenDT, GV.HoTen
FROM DETAI DT 
JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MaGV
WHERE DT.MaDT NOT IN (SELECT DISTINCT TG.MaDT
                  FROM GIAOVIEN GV
                  JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
                  WHERE GV.HoTen = N'Nguyễn Hoài An')

-- Q44: Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.
SELECT GV.HoTen
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MaBM = BM.MaBM
JOIN KHOA K ON BM.MaKhoa = K.MaKhoa
WHERE K.TenKhoa = N'Công nghệ thông tin' AND GV.MaGV NOT IN (SELECT MaGV
                                                             FROM THAMGIADT)

-- Q45: Tìm những giáo viên không tham gia bất kỳ đề tài nào
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.MaGV NOT IN (SELECT MaGV
                      FROM THAMGIADT)

-- Q46: Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An”
SELECT *
FROM GIAOVIEN GV
WHERE GV.Luong > (SELECT GV1.Luong
                      FROM GIAOVIEN GV1
                      WHERE GV1.MaGV <> GV.MaGV AND GV1.HoTen = N'Nguyễn Hoài An')

-- Q47: Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài
SELECT *
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MaGV = BM.TruongBM
WHERE GV.MaGV IN (SELECT DISTINCT MaGV
                  FROM THAMGIADT)

-- Q48: Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT *
FROM GIAOVIEN GV
WHERE GV.HoTen IN (SELECT GV.HoTen
                   FROM GIAOVIEN GV1
                   WHERE GV.MaGV <> GV1.MaGV
                   AND GV.MaBM = GV1.MaBM
                   AND GV.Phai = GV1.Phai)

-- Q49: Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công
-- nghệ phần mềm”
SELECT *
FROM GIAOVIEN GV
WHERE GV.Luong > ANY (SELECT GV1.Luong
                      FROM GIAOVIEN GV1
                      JOIN BOMON BM ON GV1.MaBM = BM.MaBM
                      WHERE BM.TenBM = N'Công nghệ phần mềm')

-- Q50: Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ
-- thống thông tin”
SELECT *
FROM GIAOVIEN GV
WHERE GV.Luong > ALL (SELECT GV1.Luong
                      FROM GIAOVIEN GV1
                      JOIN BOMON BM ON GV1.MaBM = BM.MaBM
                      WHERE BM.TenBM = N'Hệ thống thông tin”')

-- Q51: Cho biết tên khoa có đông giáo viên nhất
SELECT TenKhoa
FROM KHOA
WHERE MaKhoa IN (SELECT KH.MaKhoa
                    FROM (SELECT BM.MaKhoa, COUNT(GV.MaGV) SLGV
                          FROM GIAOVIEN GV
                          JOIN BOMON BM ON GV.MaBM = BM.MaBM
                          GROUP BY BM.MaKhoa) KH
                    WHERE KH.SLGV = (SELECT MAX(SLGV)
                                     FROM (SELECT COUNT(GV.MaGV) AS SLGV
                                           FROM GIAOVIEN GV
                                           JOIN BOMON BM ON GV.MaBM = BM.MaBM
                                           GROUP BY BM.MaKhoa) MaxQuery))

-- Q52: Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT HoTen
FROM GIAOVIEN
WHERE MaGV IN (SELECT D.GVCNDT
               FROM (SELECT DT.GVCNDT, COUNT(*) SLDTCN
                     FROM DETAI DT
                     GROUP BY DT.GVCNDT) D
               WHERE D.SLDTCN = (SELECT MAX(SLDTCN)
                                 FROM (SELECT COUNT(*) SLDTCN
                                       FROM DETAI DT
                                       GROUP BY DT.GVCNDT) MaxQuery))

-- Q53: Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT SL.MaBM
FROM (SELECT GV.MaBM, COUNT(*) SLGV
      FROM GIAOVIEN GV
      GROUP BY GV.MaBM) SL
WHERE SL.SLGV = (SELECT MAX(SLGV)
                  FROM (SELECT GV.MaBM, COUNT(*) SLGV
                        FROM GIAOVIEN GV
                        GROUP BY GV.MaBM) MaxQuery)

-- Q54: Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất.
SELECT SL.HoTen, SL.TenBM
FROM (SELECT GV.MaGV, GV.HoTen, BM.TenBM, COUNT(*) SLDT
      FROM GIAOVIEN GV
      JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
      JOIN BOMON BM ON GV.MaBM = BM.MaBM
      GROUP BY GV.MaGV, GV.HoTen, BM.TenBM) SL
WHERE SL.SLDT = (SELECT MAX(SLDT)
                 FROM (SELECT COUNT(*) SLDT
                       FROM THAMGIADT
                       GROUP BY MaGV) MaxQuery)

-- Q55: Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT.
SELECT SL.HoTen
FROM (SELECT GV.HoTen, COUNT(*) SLDT
      FROM GIAOVIEN GV
      JOIN THAMGIADT TG ON GV.MaGV = TG.MaGV
      WHERE GV.MaBM = N'HTTT'
      GROUP BY GV.HoTen) SL
WHERE SL.SLDT = (SELECT MAX(SLDT)
                 FROM (SELECT COUNT(*) SLDT
                       FROM THAMGIADT
                       GROUP BY MaGV) MaxQuery)

-- Q56: Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất.
SELECT SL.HoTen, SL.TenBM
FROM (SELECT GV.HoTen, BM.TenBM, COUNT(*) SLNT
      FROM GIAOVIEN GV
      JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
      JOIN BOMON BM ON GV.MaBM = BM.MaBM
      GROUP BY GV.HoTen, BM.TenBM) SL
WHERE SL.SLNT = (SELECT MAX(SLNT)
                 FROM (SELECT GV.HoTen, COUNT(*) SLNT
                       FROM GIAOVIEN GV
                       JOIN NGUOITHAN NT ON GV.MaGV = NT.MaGV
                       GROUP BY GV.HoTen) MaxQuery)

-- Q57: Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất.
SELECT SL.HoTen
FROM (SELECT GV.HoTen, COUNT(*) SLDT
      FROM GIAOVIEN GV
      JOIN BOMON BM ON GV.MaGV = BM.TruongBM
      JOIN DETAI DT ON BM.TruongBM = DT.GVCNDT
      GROUP BY GV.HoTen) SL
WHERE SL.SLDT = (SELECT MAX(SLDT)
                 FROM (SELECT COUNT(*) SLDT
                       FROM BOMON BM
                       JOIN DETAI DT ON BM.TruongBM = DT.GVCNDT
                       GROUP BY BM.TruongBM) MaxQuery)