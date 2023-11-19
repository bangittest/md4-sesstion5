use qlbh;
# -- - Thực hiện đánh chỉ mục trên trường name, bảng customer
#
# CREATE unique INDEX cName ON cusomer (cName);
#
# -- - Tạo view hiển thị danh sách đơn hàng (case when )
# --     id , userName , status
#
# create view vw_id_useName_status
# as
# select o.oID,c.cName,o.status,
#        case
#            when o.status = 0 then ('đang chờ xử lý')
#            when o.status = 1 then ('dang giao hàng')
#            else 'đã hoàn tất'
#            End
#            as 'trang thai'
# from cusomer c
#          join orders o
#               on o.cusomer_id=c.cID;
#
# --     status = 0 thì hiển thị đang chờ xử lý
# --     status = 1 thì hiện thị dang giao hàng
# --     status = 2 thì hiển thị đã hoàn tất
# -- - Tạo thủ tục thêm mới sản phẩm
# insert into product(pName,pPrice) values('san pham 1', 1000000);
# drop procedure proc_insert_product;
# delimiter //
# create procedure proc_insert_product(IN pName varchar(55), pPrice varchar(55))
# begin
#     INSERT INTO product(pName,pPrice) VALUES (pName,pPrice);
# end;
# //
#
# call proc_insert_product('san pham 10',2000939);
# call proc_insert_product('san phamehjhrj',200044939);
# -- - Tạo thủ tục lấy ra 5 sản phẩm có giá cao nhất
# delimiter //
# create procedure proc_hienthi_product()
# begin
#     select* from product
#     order by pPrice desc
#     limit 5;
# end;
# //
# call proc_hienthi_product;
# -- - Tạo thủ tục cập nhật
#
#
# delimiter //
# create procedure proc_update_product(IN id int, pName varchar(55), pPrice varchar(55))
# begin
#     update product
#     set pName = pName,
#         pPrice=pPrice where pId=id;
# end;
# //
#
#
# call proc_update_product(6,'hdhdhdh',848484848);
# -- - Tạo thủ tục xóa sản phẩm :
# drop procedure proc_delete_product;
# delimiter //
# create procedure proc_delete_product(in Id int)
# begin
#     delete from product where pId = Id;
# end;
# //
# call proc_delete_product(7);


create database TicketFilm;
use TicketFilm;

create table tblPhim(
    PhimID int not null auto_increment primary key ,
    Ten_phim nvarchar(30),
    Loai_phim nvarchar(25),
    Thoi_gian int
);
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values('Em be Ha Noi','Tam ly',90);
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values('Nhiem vu bat kha thi','Hanh dong',100);
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values('Di nhan','Vien Tuong',90);
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values('Cuon theo chieu gio','Tinh cam',120);
select * from tblPhim;

create table tblPhong (
    Phong_Id int auto_increment not null primary key ,
    Ten_phong nvarchar(20),
    Trang_thai tinyint
);
insert into tblPhong (Ten_phong, Trang_thai) values ('Phong chieu 1',1);
insert into tblPhong (Ten_phong, Trang_thai) values ('Phong chieu 2',1);
insert into tblPhong (Ten_phong, Trang_thai) values ('Phong chieu 3',0);

create  table tblGhe(
    GheId int primary key auto_increment,
    tblPhong_id int not null ,
    foreign key (tblPhong_id)references tblPhong(Phong_Id),
    soGhe varchar(10)
);

insert into tblGhe(tblPhong_id,soGhe)values (1,'A3');
insert into tblGhe(tblPhong_id,soGhe)values (1,'B5');
insert into tblGhe(tblPhong_id,soGhe)values (2,'A7');
insert into tblGhe(tblPhong_id,soGhe)values (2,'D1');
insert into tblGhe(tblPhong_id,soGhe)values (3,'T2');


create table tblVe(
    tblPhim_id int not null ,
    foreign key (tblPhim_id)references tblPhim(PhimID),
    tblGhe_id int not null ,
    foreign key (tblGhe_id) references tblGhe(GheId),
    Ngay_chieu date,
    Trang_thai nvarchar(20)
);

insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(1,1,'2008-10-20',1);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(1,3,'2008-11-20',1);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(1,4,'2008-12-23',1);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(2,1,'2009-02-14',1);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(3,1,'2008-02-24',1);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(2,5,'2009-08-03',0);
insert into tblVe (tblPhim_id, tblGhe_id, Ngay_chieu, Trang_thai)
values(2,3,'2008-08-03',0);

# Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
#
 select * from tblVe order by Ngay_chieu;
# Hiển thị Ten_phim có thời gian chiếu dài nhất
#
select Ten_phim,Loai_phim,Thoi_gian from tblPhim order by Thoi_gian desc limit 1;
# Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
#
select Ten_phim,Loai_phim,Thoi_gian from tblPhim order by Thoi_gian limit 1;
# Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
#
select * from tblGhe where soGhe like 'A%';
# Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)
#
alter table tblPhong modify column Trang_thai nvarchar(25);
# Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
#
# Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
# Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
# Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
# Sau đó hiển thị bảng tblPhong
#
select Phong_Id,Ten_phong,
       case when Trang_thai=0 then 'Đang sửa'
            when Trang_thai=1 then 'Đang sử dụng'
            when Trang_thai=null then 'Unknown'
end  as 'Trang_thai'
from tblPhong;
# Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự
#
select * from tblPhim where length(Ten_phim)>15 and length(Ten_phim)<25;
# Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
#
SELECT CONCAT(Ten_Phong, ' - ', Trang_Thai) AS 'Trạng thái phòng chiếu'
FROM tblPhong;
# Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
#
create table tblRanh(
    stt int,
    Ten_Phim NVARCHAR(255),
    Thoi_gian datetime
);
# Trong bảng tblPhim :
# a. Thêm trường Mo_ta kiểu nvarchar(max)
alter table tblPhim add column Mo_ta nvarchar(255);

# b. Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường LoaiPhim
update tblPhim
set Mo_ta =concat('Đây là bộ phim thể loại ',Loai_phim);
# c. Hiển thị bảng tblPhim sau khi cập nhật
select * from tblPhim;
# d. Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film”
update tblPhim
set Mo_ta =replace(Mo_ta,'bộ phim','film');
# e. Hiển thị bảng tblPhim sau khi cập nhật
select * from tblPhim;
#
# Xóa tất cả các khóa ngoại trong các bảng trên.
#
ALTER TABLE tblGhe DROP FOREIGN key tblghe_ibfk_1;
alter table tblVe drop foreign key tblve_ibfk_1,
    drop foreign key tblve_ibfk_2;
# Xóa dữ liệu ở bảng tblGhe
#
TRUNCATE TABLE tblGhe;
# Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút

SELECT CURRENT_TIMESTAMP AS 'Ngày giờ hiện tại',
       DATEADD(MINUTE, 5000, CURRENT_TIMESTAMP) AS 'Ngày giờ hiện tại cộng 5000 phút';