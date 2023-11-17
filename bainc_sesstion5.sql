create database qlsvnc;
use qlsvnc;
create table students(
studentID int primary key not null auto_increment,
studentName varchar(55),
studentName tinyint check (Age>0),
Email varchar(55)
);

insert into students(studentName,Age,Email)
values('Nguyen Quan An','18','an@yahoo.com');
insert into students(studentName,Age,Email)
values('Nguyen Cong Vinh','20','vinh@gmail.com');
insert into students(studentName,Age,Email)
values('Nguyen Quan Quyen','19','quyen');
insert into students(studentName,Age,Email)
values('Pham Thanh Binh','25','binh@com');
insert into students(studentName,Age,Email)
values('Nguyen Van Tai Em','30','taiem@sport.vn');

create table classes(
classID int primary key auto_increment not null,
className varchar(55)
);

insert into classes(className)values('C0706L'),('C0708G');

create table classStudent(
student_id int not null,
foreign key(student_id)references students(studentID),
class_id int not null,
foreign key (class_id)references classes(classID)
);

insert into classStudent(student_id,class_id)values(1,1),(2,1),(3,2),(4,2),(5,2);

create table subjects(
 subjectId int auto_increment primary key,
 subjectName varchar(55) not null
);

insert into subjects(subjectName)values('SQL'),
('Java'),('C'),('Visua Basic');

create table marks(
 mark float,
 subject_id int not null,
 foreign key(subject_id)references Subjects(subjectId),
 student_id int not null,
 foreign key(student_id)references students(studentID)
);

insert into marks(mark,subject_id,student_id)
values(8,1,1),(4,2,1),(9,1,1),
(7,1,3),(3,1,4),(5,2,5),(8,3,3),(1,3,5),(3,2,4);


-- Hien thi danh sach tat ca cac hoc vien
select * from students;
-- Hien thi danh sach tat ca cac mon hoc
select * from subjects;
SET SQL_SAFE_UPDATES = 0;
-- Tinh diem trung binh
select s.studentID, s.studentName,avg(mark) as 'trung binh'
from students s
join marks m
on s.studentId=m.student_id
group by s.studentId,s.studentName
having avg(mark)>=all(select avg(mark) from marks group by marks.student_id);
-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select sub.subjectName,m.mark
from subjects sub
join marks m
on m.subject_id=sub.subjectId
group by sub.subjectName,m.mark
having mark>=all(select mark from marks );

-- Danh so thu tu cua diem theo chieu giam
select mark from marks
order by  mark desc ;
-- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table subjects modify column subjectName nvarchar(255);
-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
update subjects
set subjectName=concat('Day la mon ho',subjectName);
-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
alter table students add constraint check (Age>15 and Age <50);
-- Loai bo tat ca quan he giua cac bang
ALTER TABLE classstudent DROP FOREIGN key classstudent_ibfk_1 ,
drop FOREIGN key classstudent_ibfk_2;

ALTER TABLE marks DROP FOREIGN key marks_ibfk_1 ,
drop FOREIGN key marks_ibfk_2;

-- Xoa hoc vien co StudentID la 1
DELETE FROM Students WHERE studentID = 1;
-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
ALTER TABLE Students
ADD COLUMN Status BIT DEFAULT 1;
-- Cap nhap gia tri Status trong bang Student thanh 0
UPDATE Students
SET Status = 0;