use db_in;

select sleep(2 * rand());

insert into tbl_in (`value`) values (floor(rand() * 1000));

select sleep(2 * rand());

insert into tbl_in (`value`) values (floor(rand() * 1000));
