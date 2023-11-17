create database StudenTest;
use StudenTest;

create table Test(
testId int primary key not null auto_increment,
Name varchar(55) not null
);

insert into Test(Name)values('EPC'),('DWMX'),('SQL1'),('SQL2');

create table student(
	RN int primary key auto_increment not null,
    Name varchar(55),
    Age tinyint check(Age>0),
    status bit default(1)
);

insert into student(Name,Age)values('Nguyen Hong Ha',20),('Truong Ngoc Anh',30),
('Tuan Minh',25),('Dan Truong',22);


create table studentTest(
	student_RN int not null,
    foreign key(student_RN)references student(RN),
    test_ID int not null,
    foreign key(test_ID) references test(testID),
    Date date,
    Mark float
);

insert into studentTest(student_RN,test_ID,Date,Mark)values(1,1,'2006-7-17',8);
insert into studentTest(student_RN,test_ID,Date,Mark)values(1,2,'2006-7-18',5);
insert into studentTest(student_RN,test_ID,Date,Mark)values(1,3,'2006-7-19',7);
insert into studentTest(student_RN,test_ID,Date,Mark)values(2,1,'2006-7-17',7);
insert into studentTest(student_RN,test_ID,Date,Mark)values(2,2,'2006-7-18',4);
insert into studentTest(student_RN,test_ID,Date,Mark)values(2,3,'2006-7-19',2);
insert into studentTest(student_RN,test_ID,Date,Mark)values(3,1,'2006-7-17',10);
insert into studentTest(student_RN,test_ID,Date,Mark)values(3,3,'2006-7-18',1);

-- Sử dụng alter để sửa đổi
-- a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55

alter table student add constraint check (Age>15 and Age <50);
-- b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
ALTER TABLE studentTest ALTER COLUMN mark SET DEFAULT 0;
-- c. Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table studenttest add primary key(student_RN,test_ID);
-- d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table Test add unique(name);
-- e. Xóa ràng buộc duy nhất (unique) trên bảng Test
ALTER TABLE Test DROP CONSTRAINT name;

-- Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó,
--  điểm thi và ngày thi giống như hình sau:
select s.Name as 'student name',t.Name as 'Test Name' ,st.mark,st.date 
from student s
join studentTest st
on st.student_RN=s.RN
join test t
on st.test_ID=t.testId;

-- Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
select s.RN,s.Name,s.Age 
from student s
left join studentTest st
on st.student_RN=s.RN where student_RN is null;
-- Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại 
-- và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) như sau:

select s.Name,t.Name,st.mark,st.date
from student s
join studentTest st
on st.student_RN=s.RN
join test t
on st.test_ID=t.testID where st.mark<=4;

-- Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi.
--  Danh sách phải sắp 
-- xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm) như sau:
select s.Name ,avg(st.mark) as 'average'
from student s
join studentTest st
on st.student_RN=s.RN
group by s.Name
order by average desc;
-- Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
-- cach 1
select s.Name ,avg(st.mark) as 'average'
from student s
join studentTest st
on st.student_RN=s.RN
group by s.Name
having avg(st.mark)=(select avg(mark) from studentTest group by student_RN
order by avg(mark) desc limit 1);

-- cach2
select s.Name ,avg(st.mark) as 'average'
from student s
join studentTest st
on st.student_RN=s.RN
group by s.Name
order by average desc
limit 1;

-- Hiển thị điểm thi cao nhất của từng môn học.
--  Danh sách phải được sắp xếp theo tên môn học như sau:
select t.name as 'test name',MAX(st.mark) as 'max mark'
from test t
join studentTest st
on st.test_ID=t.testID
group by t.name 
order by t.name;

-- Hiển thị danh sách tất cả các học viên và môn học mà các học 
-- viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau:
select s.name as 'student name',t.name as 'test name'
from student s
left join studentTest st
on st.student_RN=s.RN
left join test t
on st.test_ID=t.testID;

-- Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student set Age=Age+1 where RN;
select * from student;
-- 11.Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student modify column status varchar(10);

-- Cập nhật(Update) trường Status sao cho những học viên 
-- nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, 
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị 
-- toàn bộ nội dung bảng Student lên như sau:
update student
set status =if(age<30 ,'young','old')where RN;
select * from student ;
-- Hiển thị danh sách học viên và điểm thi, 
-- dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
select s.name as 'student name',t.name as'test name', st.mark as 'mark',st.date
from student s
join studentTest st
on st.student_RN=s.RN
join test t
on st.test_ID=t.testID 
order by date; 

-- Hiển thị các thông tin sinh viên có tên bắt đầu bằng
--  ký tự ‘T’ và điểm thi trung bình >4.5. 
--  Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select s.Name as ten_sinh_vien,s.Age as tuoi_sinh_vien,avg(st.mark)as average
from student s
join studentTest st
on st.student_RN=s.RN
group by s.name ,s.age
having s.name like 'T%' and avg(st.mark)>4.5;
-- Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng).
--  Trong đó, xếp hạng dựa vào điểm trung bình của học viên, 
--  điểm trung bình cao nhất thì xếp hạng 1.
SELECT s.RN AS 'Mã sinh viên',s.Name AS 'Tên sinh viên',s.Age AS 'Tuổi',
AVG(st.mark) AS 'Điểm trung bình',
RANK() OVER (ORDER BY AVG(st.mark) DESC) AS 'Xếp hạng'
FROM student s
JOIN studentTest st ON st.student_RN = s.RN
GROUP BY s.RN, s.Name, s.Age
ORDER BY 'Xếp hạng';

-- Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table student modify column name nvarchar(255);
-- Cập nhật (sử dụng phương thức write) cột name 
-- trong bảng student với yêu cầu sau:
-- a. Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)
update student 
set name=concat( if(Age>20,'old','young'),name) where RN;
select * from student;

-- UPDATE student
-- SET name = CONCAT(
--   CASE
--     WHEN age > 20 THEN 'Old '
--     WHEN age <= 20 THEN 'Young '
--   END,
--   name
-- )
-- WHERE RN;


-- Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi


-- Xóa thông tin điểm thi của sinh viên có điểm <5.
delete from studentTest where mark<5;