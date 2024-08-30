USE QLDT
GO

-- Truy vấn lồng
-- select (sub-query (sub-query)) -> Lấy thuộc tính   => Tương quan
-- from (sub-query) -> Lấy thuộc tính -> Tạo bảng mới -> Tính giá trị / gom cá thuộc tính ở các bảng khác => Phân cấp
-- where (sub-query) 
-- group by
-- having (sub-query)
-- order by

-- Truy vấn lòng phân cấp: sub-query không truy xuất thuộc tính cha
-- Truy vấn lòng tương quan: sub-query có truy xuất thuộc tính cha

-- vd: cho biết giáo viên không có người thân
-- C1: Lòng phân cấp 
SELECT *
FROM GIAOVIEN GV
WHERE GV.MaGV NOT IN (SELECT MaGV FROM NGUOITHAN)

-- C2: Lòng tương quan
SELECT *
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT * FROM NGUOITHAN NT WHERE NT.MaGV = GV.MaGV)

-- vd: Cho biết giáo viên và số lượng đề tài chủ nhiệm

-- C1:
SELECT *
FROM GIAOVIEN GV JOIN (SELECT GVCNDT, COUNT(*) SL
                       FROM DETAI DT
                       GROUP BY DT.GVCNDT) DT
ON GV.MaGV = DT.GVCNDT

-- C2:
SELECT GV.*, (SELECT COUNT(*) SL
              FROM DETAI DT)
FROM GIAOVIEN GV


-- vd: cho biết giáo viên có lương lớn nhất
-- ANY, ALL, SOME: Dùng nếu sub-query trả ra nhiều giá trị
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.Luong = (SELECT MAX (LUONG)
                  FROM GIAOVIEN)

-- vd: cho biết giáo viên chủ nhiệm nhiều đề tài nhất
SELECT DT.*
FROM DETAI DT
GROUP BY DT.GVCNDT
HAVING COUNT(MaDT) >= ALL (SELECT COUNT(MaDT)
                           FROM DETAI
                           GROUP BY GVCNDT)

SELECT DT.*
FROM DETAI DT
GROUP BY DT.GVCNDT
HAVING COUNT(MaDT) = (SELECT MAX(DT)
                       FROM (SELECT COUNT(MaDT) SL
                       FROM DETAI
                       GROUP BY GVCNDT) DT)

-- vd: cho biết giáo viên cùng tên & cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT GV.*
FROM GIAOVIEN GV JOIN (SELECT MaGV, HoTen, Phai, MaBM
                       FROM GIAOVIEN) GV1
                ON GV1.HoTen = GV.HoTen AND GV1.MaBM = GV.MaGV AND GV1.Phai = GV.Phai AND GV1.MAGV <> GV.MaGV
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.HoTen IN (SELECT GV1.HoTen
                   FROM GIAOVIEN GV1
                   WHERE GV1.MaGV <> GV.MaGV
                   AND GV1.Phai = GV.Phai
                   AND GV1.MaBM = GV.MaBM)

-- vd: cho biết giáo viên tham gia nhiều đề tài nhất trong từng bộ môn
SELECT TG.MaGV, GV.MaBM, COUNT(DISTINCT MaDT) SL
FROM THAMGIADT TG JOIN GIAOVIEN GV ON GV.MaGV = TG.MaGV
GROUP BY TG.MaGV, GV.MaBM
HAVING COUNT(DISTINCT MaDT) >= ALL (SELECT COUNT(DISTINCT MaDT)
                                    FROM THAMGIADT TG1 JOIN GIAOVIEN GV1 ON TG1.MaGV = GV1.MaGV
                                    WHERE GV1.MaBM = GV.MaBM
                                    GROUP BY TG1.MaGV)