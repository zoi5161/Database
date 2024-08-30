USE QLDT
GO

-- VD: CHO DANH SÁCH GV (MaGV, HoTen) THAM GIA TẤT CẢ ĐỀ TÀI DO TRƯỞNG BỘ MÔN HỌ LÀM CHỦ NHIỆM
-- S(DETAI) : SỐ CHIA
-- R(BOMON) : SỐ BỊ CHIA
-- T(GIAOVIEN) : THƯƠNG

SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT, BOMON BM
WHERE GV.MaGV = TG.MaGV AND TG.MaDT = DT.MaDT AND
      GV.MaBM = BM.MaBM AND BM.TruongBM = DT.GVCNDT
GROUP BY GV.MaGV, GV.HoTen, BM.TruongBM
HAVING COUNT(DISTINCT TG.MaDT) = (SELECT COUNT(*)
                                  FROM DETAI DT
                                  WHERE DT.GVCNDT = BM.TruongBM)


SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MaBM = BM.MaBM
WHERE NOT EXISTS (SELECT DT.MaDT
                  FROM DETAI DT 
                  WHERE BM.TruongBM = DT.GVCNDT
                  EXCEPT
                  SELECT TG.MaDT
                  FROM THAMGIADT TG
                  WHERE GV.MaGV = TG.MaGV)
      AND EXISTS (SELECT DT.MaDT
                  FROM DETAI DT 
                  WHERE BM.TruongBM = DT.GVCNDT)