IF DB_IF('QLDT') IS NOT NULL
BEGIN
    DROP DATABASE QLDT
END

CREATE DATABASE QLDT
GO
USE QLDT
GO

/*
6 Select: Thuộc tính, biểu thức (TOP, DISTINCT)
1 From: Bảng
2 Where: Điều kiện lọc dữ liệu
3 Group by: Thuộc tính gom nhóm (OR, AND)
4 Aggregate functions: (SUM, COUNT, AVG, MIN, MAX)
5 Having: điều kiện trên nhóm 
7 Order by: thuộc tính sắp xếp (ASC default, DSC)
*/

/*
Trên 1 bảng:
1/ Tìm giáo viên và lương sau khi tăng 10%
*/
SELECT GV.*, GV.luong * 1.1 AS LuongTang
FROM GiaoVien GV

-- 2/ Tìm MaGV, HoTen của giáo viên họ Nguyễn hoặc tên có 4 kí tự và chưa có giáo viên quản lí chuyên môn xếp giảm theo họ tên
SELECT GV.MaGV, GV.HoTen
FROM GIAOVIEN GV
WHERE (GV.HoTen LIKE N'Nguyễn%' OR GV.HoTen LIKE N'% ____') AND GV.GVQLCM IS NULL
ORDER BY GV.HoTen DESC;

-- Trên nhiều bảng:
-- 3.1/ Cho biết tuổi và giáo viên bộ môn 'Hệ Thống Thông Tin'

-- Nối 2 bảng
Select *
From GiaoVien
Select gv.*
From GiaoVien gv JOIN BOMON bm on gv.MaBM = bm.MaBM

-- 2 bảng
SELECT GV.MaGV, GV.HoTen, BM.MaBM, BM.TenBM, DATEDIFF(year, GV.NgaySinh, GETDATE()) Tuoi
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MaBM = BM.MaBM AND BM.TenBM = N'Hệ thống thông tin'

SELECT GV.MaGV, GV.HoTen, BM.MaBM, BM.TenBM, (YEAR(GETDATE()) - YEAR(GV.NgaySinh)) Tuoi
From GIAOVIEN GV JOIN BOMON BM ON GV.MaBM = BM.MaBM
WHERE BM.TenBM = N'Hệ thống thông tin'

-- 3 bảng
-- Tích đề các:
Select gv.MaGV, gv.HoTen, bm.TenBM, k.MaKhoa, k.TenKhoa, (year(GETDATE()) - year(gv.NgaySinh)) Tuoi
From GiaoVien gv, BoMon bm, Khoa k
Where gv.MaBM = bm.MaBM and k.MaKhoa = bm.MaKhoa
AND bm.TenBM = N'Hệ Thống Thông Tin'

-- Join:
Select gv.MaGV, gv.HoTen, bm.TenBM, DATEDIFF(year, gv.NgaySinh, GETDATE()) Tuoi
From GIAOVIEN gv JOIN BOMON bm
On gv.MaBM = bm.MaBM JOIN KHOA k on k.MaKhoa = bm.MaKhoa
Where bm.TenBM = N'Hệ Thống Thông Tin' 

-- Select Distinct : Loại dòng trùng
-- Select Top 2 : Lấy 2 dòng đầu

-- 3.2/ Cho biết lương trung bình của giáo viên
Select AVG(GV.Luong)
From GiaoVien GV

--> Không có thuộc tính nên không cần GROUP BY

-- 3.3/ Cho biết lương trung bình của giáo viên từng bộ môn
Select GV.MaBM, BM.TenBM, AVG(GV.Luong),
COUNT(*) 'DEMDONG', COUNT(GVQLCM) 'DEMKHACNULL',COUNT(DISTINCT GVQLCM) 'DEMKOTRUNG'
From GiaoVien GV JOIN BOMON BM ON BM.MaBM = GV.MaBM
GROUP BY GV.MaBM, TenBM


-- Điều Kiện Trên Nhóm
-- Xuất bộ môn có trên 2 giáo viên

Select GV.MaBM, COUNT(*) 'DEMDONG'
From GiAOVIEN GV
Group by GV.MaBM
Having COUNT(*) > 1 AND AVG(Luong) > 1000

-- 4/ Cho biết tên giáo viên và tên trường bộ môn nhận chức từ 1/2023 đến 5/2024

-- Trên tập hợp: -> Điều kiện: Khả hợp (Cùng có thuộc tính và cùng kiểu dữ liệu của các thuộc tính -- Cùng số lượng câu truy vấn)

-- * Hội = UNION
-- 5/ Cho biết giáo viên hoặc chủ nhiệm đề tài hoặc là trưởng BM
Select Distinct TRUONGBM
From BOMON
UNION
Select Distinct GVCNDT
From DETAI
--> Tự loại trùng

Select TRUONGBM
From BOMON
UNION
Select GVCNDT
From DETAI
--> Giữ lại dòng trùng

-- * Giao = Intersect
-- 6/ Cho biết giáo viên vừa chủ nhiệm đề tài vừa là trưởng BM
Select Distinct TRUONGBM
From BOMON
INTERSECT
Select Distinct GVCNDT
From DETAI

-- * Trừ = Except
-- 7.0/ Cho biết giáo viên chưa tham gia đề tài
Select MaGV
From GiaoVien
EXCEPT
Select MaGV
From THAMGIADT

-- 7.1/ Tìm đề tài có kinh phí > 100 và thuộc chủ đề 'Giáo dục' -> DETAI, CHUDE => JOIN
Select DT.*
From DETAI dt join CHUDE cd on dt.MaCD = cd.MaCD
Where dt.KinhPhi > 10.0
AND cd.TenCD like N'%giáo dục'

-- 7.2/ Tìm giáo viên vừa chủ nhiệm đề tài vừa tham gia đề tài -> GIAOVIEN, DETAI, THAMGIADT => JOIN
-- My answer:
Select MaGV
From THAMGIADT 
INTERSECT
Select DT.*
From DETAI DT

-- Correct answer:
Select gv.*
From THAMGIADT tg join GIAOVIEN gv on gv.MaGV = tg.MaGV
INTERSECT
Select gv.*
From DETAI dt JOIN GIAOVIEN gv on gv.MaGV = dt.MaGV

-- 7.3/ Tìm trưởng khoa họ 'Trần' và lớn hơn 50 tuổi -> GIAOVIEN, KHOA => JOIN
Select gv.*
From KHOA k JOIN GIAOVIEN gv on k.TRUONGKHOA = gv.MaGV
Where gv.HoTen like N'Trần%' and (Year(GETDATE()) - Year(gv.NgaySinh) > 50)

-- 7.4/ Tìm giáo viên không quản lý giáo viên nào -> GIAOVIEN => EXCEPT
Select *
From GIAOVIEN gv
EXCEPT
SELECT ql.*
FROM GIAOVIEN gv JOIN GIAOVIEN ql on ql.MaGV = gv.GVQLCM

-- 7.5/ Tìm đề tài có trên 3 công việc -> DETAI, CONGVIEC => JOIN, GROUP BY => COUNT
SELECT DT.*
FROM CONGVIEC cv JOIN DETAI dt ON dt.MaDT = cv.MaDT
GROUP BY dt.MaDT, dt.TenDT, dt.CapQL, dt.KinhPhi, dt.MaCD, dt.NgayBD, dt.NgayKt
HAVING COUNT (CV.MaDT) > 3

-- 7.6/ Tìm đề tài có giáo viên họ Nguyễn tham gia và có trên 3 công việc chưa hoàn thành (KetQua = NULL) --> DETAI, GIAOVIEN, ThamGiaDT => JOIN, GROUP BY, COUNT(NULL)
SELECT DT.*, COUNT(*), COUNT(KetQua)
FROM GIAOVIEN gv JOIN THAMGIADT tg ON gv.MaGV = tg.MaGV
JOIN DETAI dt ON dt.MaDT = tg.MaDT
Where gv.HoTen LIKE N'Nguyễn %' AND tg.KetQua IS NULL
GROUP BY dt.MaDT, dt.TenDT, dt.CapQL, dt.KinhPhi, dt.MaCD, dt.NgayBD, dt.NgayKt
HAVING COUNT(*) > 3

-- Truy Vấn Lồng
-- Lồng tương quan
-- Cho biết HoTen GV, Tên quản lí, Tên Trưởng Khoa, Tên Trưởng BM, 
-- Số lượng công việc mà giáo viên này tham gia

SELECT gv.HoTen, (SELECT ql.HoTen
                  From GIAOVIEN ql
                  WHERE ql.MaGV = gv.GVQLCM) ql,
                  (SELECT tk.HoTen
                  From GIAOVIEN tk JOIN KHOA k on tk.TruongKhoa = tk.MaGV
                  WHERE k.MaKhoa = bm.MaKhoa) TruongKhoa,
                  (SELECT tbm.HoTen
                  FROM GIAOVIEN tbm join BOMON bm on bm.TruongBM = tbm.MaGV -- ???
                  WHERE gv.MaBM = bm1.MaBM) TruongBM, -- ???
                  (SELECT COUNT(*)
                  FROM ThamGiaDT TG
                  WHERE TG.MaGV = GV.MaGV) SoCV

FROM GIAOVIEN gv JOIN BOMON bm ON bm.MaBM = gv.MaBM

-- FROM: Tạo bảng mới (Tạm)
SELECT gv.HoTen, ql.HoTen, TruongKhoa.HoTen, SoCV.SoCV
FROM BOMON, GIAOVIEN gv, (SELECT ql.HoTen, ql.MaGV
                  From GIAOVIEN ql
                  WHERE ql.MaGV = gv.GVQLCM) ql,
                  (SELECT tk.HoTen, k.MaKhoa
                  From GIAOVIEN tk JOIN KHOA k ON tk.TruongKhoa = tk.MaGV
                  WHERE k.MaKhoa = bm.MaKhoa) TruongKhoa,
                  (SELECT tbm.HoTen, bm1.MaBM
                  FROM GIAOVIEN tbm join BOMON bm on bm.TruongBM = tbm.MaGV
                  WHERE gv.MaBM = bm1.MaBM) TruongBM,
                  (SELECT COUNT(*) SoCV, TG.MaGV
                  FROM ThamGiaDT TG
                  GROUP BY TG.MaGV) SoCV

WHERE gv.GVQLCM = ql.MaGV AND bm.MaKhoa = TruongKhoa.MaKhoa AND
bm.MaBM = TruongBM.MaBM AND gv.MaGV = SoCV.MaGV AND bm.MaBM = gv.MaBM

-- truy vấn lồng ở select - from
-- truy vấn lồng ở Where -> cần lọc dữ liệu từ bảng
--> truy vấn con có thể tham gia điều kiện
-- vd: cho biết gv tham gia đề tài do "Nguyễn Hoài An" chủ nhiệm
-- Điều kiện nếu trả ra n giá trị thì dùng IN/ANY/SOME (Không chắc)
-- Điều kiện nếu trả ra đúng 1 giá trị thì dùng = (Chắc chắn)

SELECT GV.*
FROM GIAOVIEN GV JOIN THAMGIADT TG ON TG.MaGV = GV.MaGV
WHERE TG.MaDT IN (SELECT DT.MaDT
                  FROM DETAI DT
                  WHERE DT.GVCNDT IN (SELECT MaGV
                                      FROM GIAOVIEN GV
                                      WHERE GV.HoTen = N'Nguyễn Hoài An'))

-- hoặc

SELECT GV.*
FROM GIAOVIEN GV JOIN THAMGIADT TG ON TG.MaGV = GV.MaGV
WHERE EXISTS ((SELECT DT.MaDT
                  FROM DETAI DT
                  WHERE DT.GVCNDT IN (SELECT MaGV
                                      FROM GIAOVIEN GV
                                      WHERE GV.HoTen = N'Nguyễn Hoài An')))


-- Truy vấn lồng ở having: so sánh giá trị được tính từ các hàm kết hợp (SUM, COUNT, MIN, MAX, AVG)
-- VD: Tìm bộ môn có nhiêu giáo viên nhất

SELECT GV.MaBM
FROM GIAOVIEN GV
GROUP BY GV.MaBM
HAVING COUNT(MaGV) >= ALL(SELECT
                          FROM GIAOVIEN GV
                          GROUP BY GV.MaBM) 

-- Truy vấn phép chia
-- Nhận dạng phép chia: dữ liệu xuất ra phải thoả tất cả
-- xác định các thành phần
-- KQ: chính dữ liệu xuất
-- C: tất cả cái gì
-- BC: Quan hệ giữa KQ và CHIA

-- VD: Cho biết GV
-- C: DETAI(MaDT)
-- BC: THAMGIADT(MaGV, MaDT)

-- Cách cài đặt câu phép chia
-- Cách 1: EXCEPT

SELECT KQ.*
FROM GIAOVIEN KQ
WHERE NOT EXISTS (SELECT C.MaDT
                  FROM DETAI C
                  EXCEPT
                  SELECT BC.MaDT
                  FROM THAMGIADT BC
                  WHERE BC.MaGV = KQ.MaGV)
-- Cách 2: NOT EXISTS ... NOT EXISTS

SELECT KQ.*
FROM GIAOVIEN KQ
WHERE NOT EXISTS (SELECT *
                  FROM DETAI C
                  WHERE NOT EXISTS(SELECT BC.MaDT
                                   FROM THAMGIADT BC
                                   WHERE BC.MaGV = KQ.MaGV
                                   AND BC.MaDT = C.MaDT))

-- Cách 3: Đếm số lượng đề tài
-- Ứng với từng giáo viên đếm số lượng đề tài GV Tham gia so số lượng đề tài = số đề tài tham gia
SELECT COUNT(DISTINCT MaDT)
FROM THAMGIADT BC
WHERE BC.MaDT IN (SELECT MaDT FROM DETAI WHERE KINHPHI > 100)
GROUP BY BC.MaGV
HAVING COUNT (DISTINCT MaDT) = (SELECT COUNT(MaDT)
                                FROM DETAI C
                                WHERE KINHPHI > 100)



/*
Gom nhóm:
8/ Cho biết tên bộ môn & số giáo viên của bộ môn đó

9/ Cho biết MaGV và số lượng đề tài giáo viên vừa tham gia

10/ Cho biết giáo viên chủ nhiệm trên 2 đề tài
*/

/*
* Phân cấp:
11/ Cho viết giáo viên cùng tuổi với Trần Trà Hương (From)
*/

SELECT * FROM GIAOVIEN
SELECT * FROM GV_DT
SELECT * FROM BOMON
SELECT * FROM KHOA
SELECT * FROM DETAI
SELECT * FROM CHUDE
SELECT * FROM CONGVIEC
SELECT * FROM THAMGIADT
SELECT * FROM NGUOITHAN