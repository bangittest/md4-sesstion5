create database bang_View;
use bang_View;

drop table Class;
create table Class(
    id int not null primary key auto_increment,
    class_name nvarchar(255) not null ,
    start_date date not null ,
    status bit
);

insert into Class( class_name, start_date,status)values ('A1','2008-12-20',1);
insert into Class( class_name, start_date,status)values ('A2','2008-12-22',1);
insert into Class( class_name, start_date,status)values ('A3',current_date,0);
insert into Class( class_name, start_date,status)values ('A4','2008-12-29',1);
insert into Class( class_name, start_date,status)values ('A5','2008-12-10',1);

drop table Student;
create table Student(
    id int not null primary key auto_increment,
    student_name nvarchar(30) not null ,
    address nvarchar(50),
    phone varchar(20),
    status bit,
    class_id int not null
#     foreign key (class_id)references Class(id)
);

insert into Student( student_name, address, phone, status, class_id)
values ('Hung','Ha noi','0912113113',1,1);
insert into Student( student_name, address, status, class_id)
values ('Hoa','Hai phong',1,1);
insert into Student( student_name, address, phone, status, class_id)
values ('Manh','HCM','0123123123',0,2);

drop table Subject;
create table Subject(
    id int not null primary key auto_increment,
    sub_name nvarchar(30) not null ,
    credit tinyint not null default(1) check ( credit>=1 ),
    status bit default (1)
);

insert into Subject(sub_name, credit)values('CF','5');
insert into Subject(sub_name, credit)values('C','6');
insert into Subject(sub_name, credit)values('HDJ','5');
insert into Subject(sub_name, credit)values('RDBMS','10');

drop table Mark;
create table Mark(
    id int not null primary key auto_increment,
    sub_id int not null  ,
#     foreign key (sub_id)references Subject(id),
    student_id int not null  ,
#     foreign key (student_id)references Student(id),
    mark float default (0) check (mark between 0 and 100),
    exam_times tinyint default (1)
);

alter table Student add foreign key (class_id) references Class(id);
alter table Class modify start_date date default (curdate());

alter table Student modify status bit default (1);

alter table Mark add foreign key (sub_id) references Subject(id);
alter table Mark add foreign key (student_id)references Student(id);





insert into Mark( sub_id, student_id, mark, exam_times)
values (1,1,8,1);
insert into Mark( sub_id, student_id, mark, exam_times)
values (1,2,10,2);
insert into Mark( sub_id, student_id, mark, exam_times)
values (2,1,12,1);

# Cập nhật dữ liệu.
# a.Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
select * from Student;
update Student
set class_id=2 where student_name='Hung';
#
# b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
update Student
set phone='No phone' where phone is null or phone='';

select * from Student;

#
# c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
#
update Class
set class_name =concat('New ',class_name) where status=0;
select *from Class;
# (Chú ý: phải sử dụng phương thức write).
#
# d. Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
#
UPDATE Class
SET class_name = REPLACE(class_name, 'New', 'Old')
WHERE Status = 1 AND Class.class_name LIKE 'New%';

# (Chú ý: phải sử dụng phương thức write)
# e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
#
select * from Class;
UPDATE Class
SET status = 0
WHERE id NOT IN (SELECT class_id FROM Student);

# UPDATE Class
# SET status = 0
# WHERE id =(select c.id
#         from Class c
#         left join Student s
#         on c.id=s.class_id
#         where s.class_id is null);



# f. Cập nhật trạng thái của lớp học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.

select * from subject;
UPDATE subject
SET status = 0
WHERE id NOT IN (SELECT  id FROM Student);


# Hiện thị thông tin.
# .Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select * from student where student_name like 'h%';
#
# a. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select * from class where month(start_date) like '12%';
#
# b. Hiển thị giá trị lớn nhất của credit trong bảng subject.
#
select * from subject
order by credit desc limit 1;

# c. Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
#
select * from subject sb
         join mark m
         on sb.id=m.sub_id
         join student s
         on s.id=m.student_id
         join class c
         on c.id=s.class_id
order by credit desc limit 1;


# d. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
#
select * from subject sb
                  join mark m
                       on sb.id=m.sub_id
                  join student s
                       on s.id=m.student_id
                  join class c
                       on c.id=s.class_id
         where sb.credit between 3 and 5;

SELECT *
FROM subject
WHERE credit BETWEEN 3 AND 5;

# e. Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
#
select c.id,c.class_name,s.student_name,s.address
from class c
join student s
on c.id=s.class_id;

# f. Hiển thị các thông tin môn học chưa có sinh viên dự thi.
#
select * from subject sb
left join mark m
on sb.id=m.sub_id
where sub_id is null ;
# g. Hiển thị các thông tin môn học có điểm thi lớn nhất.
#
select *
from subject sb
join mark m
on sb.id=m.sub_id
where m.mark=(select max(mark) from mark where sub_id=sb.id);

# h. Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
#
select s.id,s.student_name,s.address,s.phone,s.status, avg(m.mark) as 'average_mark'
from mark m
join student s
on s.id=m.student_id
group by s.id,s.student_name,s.address,s.phone,s.status;

# i. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
#

select s.id,s.student_name,s.address,s.phone,s.status, avg(m.mark) as 'average_mark',RANK() OVER (ORDER BY AVG(m.mark) DESC) AS 'rank'
from mark m
         join student s
              on s.id=m.student_id
group by s.id,s.student_name,s.address,s.phone,s.status
order by average_mark desc ;

# j. Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
#
select s.id,s.student_name,s.address,s.phone,s.status, avg(m.mark) as 'average_mark'
from mark m
join student s
on s.id=m.student_id
group by s.id,s.student_name,s.address,s.phone,s.status
having average_mark>10
order by average_mark desc ;
# k. Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
#
select s.student_name,sb.sub_name,m.mark
from mark m
join student s
on s.id =m.student_id
join subject sb
on m.sub_id=sb.id
order by m.mark desc ,s.student_name asc;


# Xóa dữ liệu.
# .Xóa tất cả các lớp có trạng thái là 0.
#
SET SQL_SAFE_UPDATES = 0;
select * from class;
DELETE FROM Class
WHERE status = 0;


# a. Xóa tất cả các môn học chưa có sinh viên dự thi.
#
DELETE FROM subject
WHERE id NOT IN (SELECT DISTINCT sub_id FROM mark);

# Thay đổi.
# .Xóa bỏ cột ExamTimes trên bảng Mark.
#
SET SQL_SAFE_UPDATES = 0;
alter table mark drop column exam_times;

select * from SubjectTest;

# a. Sửa đổi cột status trên bảng class thành tên ClassStatus.
#
alter table class change status ClassStatus bit;
# b. Đổi tên bảng Mark thành SubjectTest.
alter table mark rename to SubjectTest;