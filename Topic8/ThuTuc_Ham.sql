USE QLDT
GO

-- Viết thủ tục - hàm
-- Khai báo biến
DECLARE @I INT = 1, @N INT = 5
DECLARE @A VARCHAR(10)

-- Gán biến (Gán 1 dòng dùng SET - Gán nhiều dòng dùng SELECT)
SET @A = 'ABC'
SET @A = (SELECT Phai FROM GIAOVIEN WHERE MaGV = '001')
SELECT @A = 'ABC', @I = 1
SELECT @A = Phai, @I = Luong
FROM GIAOVIEN

-- In thông báo
PRINT N'THÔNG BÁO';
THROW 51000, 'lỗi', 1; -- 50000 <= error_num <= 2,147,483,647

-- VÒNG LẶP
WHILE (@I < @N)
BEGIN
    PRINT @I
    SET @I = @I + 1
END

-- - - - - - - - - - - - --
-- Thủ tục = Chương trình con không trả về giá trị
-- - - - - - Được biên dịch và lưu trong CSDL
GO
CREATE OR ALTER PROCEDURE SP_TEST
-- Tham số
    @MaGV VARCHAR(10),
    @HoTen NVARCHAR(30),
    @Luong INT,
    @KQ INT OUT
AS -- Kết thúc khai báo tham số
-- Thân thủ tục chứa các xử lí
    SET @KQ = 0
    IF @MaGV IN (SELECT MaGV FROM GIAOVIEN)
    BEGIN
        ;THROW 50001, N'Lỗi trùng MaGV', 1
        SET @KQ = 1
        RETURN 1
    END
    IF @HoTen IS NULL
    BEGIN 
        ;THROW 50002, N'Lỗi tên rỗng', 1
        SET @KQ = 1
        RETURN 1
    END
    IF @Luong <= 0
    BEGIN
        ;THROW 50001, N'Lỗi lương sai giá trị', 1
        SET @KQ = 1
        RETURN 1 -- Chỉ trả ra số nguyên
    END
    INSERT GIAOVIEN(MaGV, HoTen, Luong)
    VALUES (@MaGV, @HoTen, @Luong)
    RETURN 0
GO -- Kết thúc khai báo thủ tục

-- Gọi thực thi
DECLARE @K INT, @R INT
EXEC @R = SP_TEST '001', 'NGUYEN VAN A', 200, @K OUT
PRINT @K
PRINT @R

-- Hàm = Chương trình con cho phép trả về giá trị scalar / bảng
-- Trả về scalar value
GO
CREATE OR ALTER FUNCTION F_TINHTUOI(
    @MaGV CHAR(3))
RETURNS INT -- Returns có s. Nếu return về 1 kiểu thì phía dưới phải có BEGIN END
AS
BEGIN
    -- Không đc INSERT / UPDATE / DELETE
    RETURN (SELECT DATEDIFF(YEAR, NgaySinh, GETDATE())
            FROM GIAOVIEN
            WHERE MaGV = @MaGV)
END
GO
SELECT * , DBO.F_TINHTUOI(MaGV) Tuoi
FROM GIAOVIEN

-- Trả về bảng
GO
CREATE FUNCTION F_DSGIAOVIENTHAMGIA
	(@MADT VARCHAR(10))
RETURNS TABLE
AS
	RETURN (SELECT * 
			FROM THAMGIADT 
			WHERE MADT = @MADT)
GO

SELECT * 
FROM GIAOVIEN G JOIN DBO.F_DSGIAOVIENTHAMGIA('001') DT
ON DT.MAGV = G.MAGV


----function
--1. viết hàm truyền vào mã gv tính số đề tài tham gia
--2. viết hàm truyền vào madt tính số công việc chưa hoàn thành
--3. viết hàm truyền vào madt tính số công việc đã hoàn thành
--4. viết hàm truyền vào madt xuất danh sách công việc trong đề tài 
-- (stt, tencv,số giáo viên tham gia, tổng phục cấp
--5. Viết hàm truyền vào MaGV tính số đề tài tham gia
--6. Viết hàm truyền vào magv xuất danh sách đề tài tham gia
--------------------------------------------------------------
--1. VIẾT THỦ TỤC THÊM ĐỀ TÀI
--INPUT: CÁC THUỘC TÍNH CỦA ĐỀ TÀI
--OUTPUT: 1 -> NẾU THÊM KO ĐC, 0 -> THÊM ĐƯỢC
--ĐIỀU KIỆN:
---> MÃ ĐỀ TÀI KHÔNG ĐƯỢC TRÙNG
---> TÊN ĐỀ TÀI KHÔNG RỖNG
---> GIÁO VIÊN CHỦ NHIỆM PHẢI LÀ GIÁO VIÊN TRÊN 35 TUỔI
---> KINH PHÍ CỦA ĐỀ TÀI CẤP TRƯỜNG < 100; ĐHQG < 1000
---> NGÀY BẮT ĐẦU < NGÀY KẾT THÚC

--2. VIẾT THỦ TỤC XÓA ĐỀ TÀI CHƯA CÓ GIÁO VIÊN THAM GIA
--INPUT: MÃ ĐT
--OUTPUT: XÓA THÀNH CÔNG HAY KHÔNG
--ĐIỀU KIỆN:
---> ĐỀ TÀI ĐÃ KẾT THÚC VÀ KHÔNG CÓ NGƯỜI THAM GIA
---> ĐỀ TÀI KHÔNG CÓ CHỦ NHIỆM

--3. VIẾT THỦ TỤC GIA HẠN ĐỀ TÀI
--INPUT: MADT, NGAYKT
--OUTPUT: GIA HẠN THÀNH CÔNG KHÔNG
--ĐIỀU KIỆN
---> ĐỀ TÀI TỒN TẠI
---> ĐỀ TÀI ĐÃ BẮT ĐẦU VÀ CHƯA KẾT THÚC
---> ĐỀ TÀI ĐÃ CÓ ÍT NHẤT 1 GIÁO VIÊN THAM GIA

--4. VIẾT THỦ TỤC IN THÔNG TIN THỐNG KÊ SAU
--INPUT: MAGV
--MẪU THỐNG KÊ
---> MÃ GV:
---> HỌ TÊN:
---> TÊN BM:
---> SỐ ĐỀ TÀI THAM GIA:
---> DANH SÁCH ĐỀ TÀI THAM GIA
---	 MADT	TENDT	PHUCAP	KETQUA
------------------------------------

--5. VIẾT THỦ TỤC IN THÔNG TIN THỐNG KÊ SAU
--INPUT: MADT
--MẪU THỐNG KÊ
--> MADT:
--> TÊN DT:
--> TÊN GVCN:
--> SỐ CÔNG VIỆC HOÀN THÀNH:
--> SỐ CÔNG VIỆC CHƯA HOÀN THÀNH:
--> DANH SÁCH CÔNG VIỆC TRONG ĐỀ TÀI
----STT	TÊN CV	SỐGVTG	TỔNGPHUCAP	
---------------------------------------
-- Đoạn script cho phép in dữ liệu từ danh sách
declare @i int = 1, @n int = (select count(*) from GIAOVIEN)
declare @magv varchar(10),@hoten nvarchar(50),@luong int

while @i<= @n
begin
	select @magv= magv,@hoten = isnull(hoten, '-'), @luong = isnull(luong,0)
	from 	(select ROW_NUMBER() OVER (ORDER BY magv) stt, magv,hoten, luong
			from GIAOVIEN) gv
	where  gv.stt = @i
	
	print cast(@i as char(5))  + @magv + space(5) + @hoten + space(20 - len(@hoten)) + cast(@luong as varchar(10))
	set @i = @i + 1
end