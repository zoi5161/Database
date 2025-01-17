USE QLCB
GO

-- Q1:
SELECT DISTINCT NV.MANV, NV.TEN, NV.DCHI, NV.DTHOAI
FROM NHANVIEN NV JOIN PHANCONG PC ON (NV.MANV = PC.MANV AND NV.LOAINV = 1)
JOIN LICHBAY LB ON (PC.MACB = LB.MACB AND LB.MALOAI = 'B747') JOIN KHANANG KN ON (KN.MANV = NV.MANV AND KN.MALOAI = 'B747')

-- Q2:
SELECT DISTINCT CB.MACB, CB.GIODI
FROM CHUYENBAY CB 
WHERE CB.SBDI = 'DCA' AND DATEPART(HOUR, CB.GIODI) >= 14 AND DATEPART(HOUR, CB.GIODI) <= 18

-- Q3:
SELECT DISTINCT NV.TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON NV.MANV = PC.MANV 
JOIN CHUYENBAY CB ON (PC.MACB = CB.MACB AND CB.MACB = '100' AND CB.SBDI = 'SLC')

-- Q4:
SELECT DISTINCT LB.MALOAI, LB.SOHIEU
FROM CHUYENBAY CB JOIN LICHBAY LB ON (CB.SBDI = 'MIA' AND CB.MACB = LB.MACB)

-- Q5:
SELECT DC.MACB, DC.NGAYDI, KH.TEN, KH.DCHI, KH.DTHOAI
FROM KHACHHANG KH LEFT JOIN DATCHO DC ON KH.MAKH = DC.MAKH
ORDER BY DC.MACB ASC, DC.NGAYDI DESC

-- Q6:
SELECT DISTINCT PC.MACB, PC.NGAYDI, NV.TEN, NV.DCHI, NV.DTHOAI
FROM PHANCONG PC JOIN NHANVIEN NV ON (NV.MANV = PC.MANV)
ORDER BY PC.MACB ASC, PC.NGAYDI DESC

-- Q7:
SELECT CB.MACB, CB.GIODI, NV.MANV, NV.TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON NV.MANV = PC.MANV
JOIN CHUYENBAY CB ON (PC.MACB = CB.MACB AND CB.SBDEN = 'ORD' AND NV.LOAINV = 1)

-- Q8:
SELECT PC.MACB, PC.NGAYDI, NV.TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON (NV.LOAINV = 1 AND NV.MANV = PC.MANV AND PC.MANV = '1001')

-- Q9:
SELECT CB.MACB, CB.SBDI, CB.GIODI, CB.GIODEN, LB.NGAYDI
FROM CHUYENBAY CB, LICHBAY LB
WHERE CB.SBDEN = 'DEN' AND CB.MACB = LB.MACB
ORDER BY LB.NGAYDI DESC, CB.SBDI ASC

-- Q10:
SELECT NV.TEN, LMB.MALOAI, LMB.HANGSX
FROM NHANVIEN NV JOIN KHANANG KN ON NV.MANV = KN.MANV
JOIN LOAIMB LMB ON KN.MALOAI = LMB.MALOAI

-- Q11:
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON (NV.MANV = PC.MANV 
AND CONVERT(date, PC.NGAYDI) = '2000-11-01' AND PC.MACB = '100')

-- Q12:
SELECT PC.MACB, NV.MANV, NV.TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON (NV.MANV = PC.MANV 
AND CONVERT(date, PC.NGAYDI) = '2000-10-31') 
JOIN CHUYENBAY CB ON (PC.MACB = CB.MACB AND CB.SBDI = 'MIA' AND DATEPART(HOUR, CB.GIODI) = 20 
AND DATEPART(MINUTE, CB.GIODI) = 30)

-- Q13:
SELECT DISTINCT LB.MACB, LB.SOHIEU, LB.MALOAI, LMB.HANGSX
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB, KHANANG KN, LOAIMB LMB
WHERE NV.TEN = 'Quang' AND NV.MANV = PC.MANV AND PC.MACB = LB.MACB
AND NV.MANV = KN.MANV AND KN.MALOAI = LB.MALOAI AND LB.MALOAI = LMB.MALOAI

-- Q14:
SELECT NHANVIEN.MANV
FROM NHANVIEN
EXCEPT
SELECT PHANCONG.MANV
FROM PHANCONG

-- Q15:
SELECT DISTINCT KH.TEN
FROM KHACHHANG KH JOIN DATCHO DC ON KH.MAKH = DC.MAKH
JOIN LICHBAY LB ON DC.MACB = LB.MACB 
JOIN LOAIMB LMB ON (LB.MALOAI = LMB.MALOAI AND LMB.HANGSX = 'Boeing')

-- Q16:
SELECT DISTINCT LB.MACB
FROM LICHBAY LB
WHERE LB.SOHIEU = 10 AND LB.MALOAI = 'B747'