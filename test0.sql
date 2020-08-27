drop database if exists test;

drop database if exists db_in;
create database db_in;

drop database if exists db_out;
create database db_out;

create table `db_in`.`tbl_in` (`id` int not null auto_increment, `value` int not null, primary key (`id`));

create table `db_out`.`tbl_log` (`id` int not null auto_increment, `tbl` varchar(64) not null, `action` varchar(64) not null, `timestamp` timestamp not null default current_timestamp, primary key (`id`));

use db_in;

delimiter $$

create trigger `log_insert` after insert on `tbl_in`
for each row begin
    insert into `db_out`.`tbl_log` (`tbl`, `action`) values ('tbl_in', 'INSERT');
end $$

delimiter ;


insert into tbl_in (`value`) values (floor(rand() * 1000));

select sleep(2 * rand());

insert into tbl_in (`value`) values (floor(rand() * 1000));

select sleep(2 * rand());

insert into tbl_in (`value`) values (floor(rand() * 1000));

drop trigger if exists `log_insert`;
