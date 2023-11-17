create database qlod;
use qlod;

drop table customer;
create table customer(
	cID int primary key auto_increment not null,
    Name varchar(25),
    cAge tinyint
);

insert into customer(Name,cAge)values('Minh Quan' ,10);
insert into customer(Name,cAge)values('Ngoc Oanh' ,20);
insert into customer(Name,cAge)values('Hong Ha' ,50);
insert into customer(Name,cAge)values('nguyen van d' ,23);
insert into customer(Name,cAge)values('nguyen van e' ,24);
insert into customer(Name,cAge)values('nguyen van g' ,25);
insert into customer(Name,cAge)values('nguyen van h' ,23);
insert into customer(Name,cAge)values('nguyen van j' ,24);
insert into customer(Name,cAge)values('nguyen van k' ,25);


drop table orders;
create table orders(
oID int primary key not null auto_increment,
customer_id int not null,
foreign key(customer_id)references customer(cID),
oDate date not null,
oTotalPrice int
);

insert into orders(customer_id,oDate)values(1,'2006-03-21');
insert into orders(customer_id,oDate)values(2,'2006-03-23');
insert into orders(customer_id,oDate)values(1,'2006-03-16');
insert into orders(customer_id,oDate)values(4,'2006-03-18');
insert into orders(customer_id,oDate)values(5,'2006-03-11');
insert into orders(customer_id,oDate)values(6,'2006-04-15');

drop table product;
create table product(
	pID int primary key auto_increment not null,
    pName varchar(25) not null unique,
    pPrice int check(pPrice>0) not null
);

insert into product(pName,pPrice)values('May Giat',20000);
insert into product(pName,pPrice)values('Tu Lanh',30000);
insert into product(pName,pPrice)values('Dieu Hoa',40000);
insert into product(pName,pPrice)values('Quat',50000);
insert into product(pName,pPrice)values('Bep Dien',60000);

drop table orderDetail;
create table orderDetail(
	orders_id int not null,
    foreign key(orders_id)references orders(oID),
    product_id int not null,
    foreign key(product_id)references product(pID),
    odQTY int check(odQTY>0)
);

insert into orderDetail(orders_id,product_id,odQTY)values(1,1,3);
insert into orderDetail(orders_id,product_id,odQTY)values(1,3,7);
insert into orderDetail(orders_id,product_id,odQTY)values(1,4,2);
insert into orderDetail(orders_id,product_id,odQTY)values(2,1,1);
insert into orderDetail(orders_id,product_id,odQTY)values(3,1,8);
insert into orderDetail(orders_id,product_id,odQTY)values(2,5,4);
insert into orderDetail(orders_id,product_id,odQTY)values(2,3,3);


select oID,oDate,oTotalPrice from orders;

select c.cID, c.Name ,p.pName ,count(*) as 'so luong'
from customer c
join orders o
on o.customer_id=c.cID
join orderDetail od
on o.oID=od.orders_id
join product p
on od.product_id=p.pID 
group by c.cID, c.Name ,p.pName
;

select c.cID,c.Name,o.*
from customer c
left join orders o
on o.customer_id=c.cID where o.customer_id is null;

select o.oID, o.oDate, SUM(od.odQTY*p.pPrice) as total_Price 
from orders o
join orderDetail od
on od.orders_id=o.oID
join product p
on od.product_id=p.pID
group by o.oID, o.oDate
having total_Price>200000
;

-- lay 3 ban ghi dau
select * from product limit 0,3;
select * from product limit 3,3;
select * from product limit 0,2;
select * from product limit 2,2;
select * from product limit 4,2;

select * from product limit 3 offset 1;
select * from product limit 2 offset 0;
select * from product limit 2 offset 2;
select * from product limit 2 offset 4;
select * from product limit 2 offset 6;



