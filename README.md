# socket

# Table
      create table member_so (
        idx number constraint member_so_pk primary key,
        userid varchar2(300) unique not null,
        userpw varchar2(300) not null,
        name varchar2(300) not null,
        join_date date not null
        );

      create sequence member_so_seq nocache;

      insert into member_so values (member_so_seq.nextval, 'admin', '1234', '관리자', sysdate);
      insert into member_so values (member_so_seq.nextval, 'user1', '1234', '유저1', sysdate);
      insert into member_so values (member_so_seq.nextval, 'user2', '1234', '유저2', sysdate);
      insert into member_so values (member_so_seq.nextval, 'user3', '1234', '유저3', sysdate);
