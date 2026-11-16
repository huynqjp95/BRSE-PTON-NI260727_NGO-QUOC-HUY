-- PHẦN1.DDL‒THIẾT KẾ CƠ SỞ DỮ LIỆU (15ĐIỂM)
drop database if exists module2final;
create database module2final;
use module2final;

-- create table
	-- 1 football_teams table
create table football_teams (
	team_id int auto_increment primary key,
    team_name varchar(100) not null,
    team_code varchar(20) not null unique,
    home_area varchar(100) not null,
    founded_date date not null
);
	
    -- 2 players table
create table players (
	player_id int auto_increment primary key,
    full_name varchar(100) not null,
    preferred_position varchar(30) 
    check ( preferred_position in('Thủ môn','Hậu vệ', 'Tiền vệ','Tiền đạo')),
    phone_number varchar(15) not null unique,
    skill_rating decimal(3,1) default 5.0
    check (skill_rating >= 0 and skill_rating <= 10.0)
);

	-- 3 matches table
create table matches (
	match_id int auto_increment primary key,
    team_id int,
    foreign key (team_id) references football_teams(team_id),
    opponent_name varchar(100) not null,
    venue varchar(150) not null,
    match_time datetime not null,
    pitch_fee decimal(10,2) check( pitch_fee >= 0 ),
    status varchar(30) 
    check ( status in ( 'Scheduled', 'Completed', 'Cancelled'))
) auto_increment = 7001;

	-- 4 match_registrations
create table match_registrations (
	registration_id int auto_increment primary key,
    match_id int,
    foreign key (match_id) references matches(match_id),
    player_id int,
    foreign key (player_id) references players(player_id),
    attendance_status varchar(30)
    check (attendance_status in ('Registered','Played', 'Absent')),
    goals int default 0 check ( goals >= 0),
    registered_at datetime default current_timestamp
)auto_increment = 8001;

	-- 5 team_logs table
create table team_logs (
	log_id int auto_increment primary key,
    registration_id int,
    foreign key (registration_id) references match_registrations(registration_id),
    player_id int ,
    foreign key (player_id) references players(player_id),
    log_time datetime not null,
    note text not null
);

-- PHẦN2. DML‒ INSERT , UPDATE , DELETE
-- Câu1 ‒ INSERT
insert into football_teams (team_name, team_code, home_area, founded_date)
values 
	('Sài Gòn Strikers','SGS', 'Quận 1', '2018-3-10'),
	('Thunder FC','TFC', 'TP Thủ Đức', '2021-6-15'),
    ('Brothes United','BRU', 'Bình Thạnh', '2016-9-20'),
    ('Weekend Warriors','WKW', 'Quận 7', '2022-1-8'),
    ('Office Eleven','O11', 'Gò Vấp', '2019-11-30');

insert into players (full_name, preferred_position, phone_number, skill_rating)
values
	('Nguyễn Minh Khang', 'Tiền đạo', '901112233', 8.2),
    ('Trần Hoàng Nam', 'Tiền vệ', '902223344', 7.5),
    ('Lê Quốc Huy', 'Hậu vệ', '903334455', 7.8),
    ('Phạm Gia Bảo', 'Thủ môn', '904445566', 8.2),
    ('Võ Thành Công', 'Tiền vệ', '905556677', 7);

insert into matches (team_id, opponent_name, venue, match_time, pitch_fee, status)
values
	(1, 'Black Cats', 'Sân Tao Đàn', '2026-5-20 18:00', 1200000, 'Scheduled'),
    (3, 'Blue Sharks', 'Sân Gia Định', '2026-5-21 19:30', 1500000, 'Completed'),
    (2, 'Bình Minh FC', 'Sân Linh Trung', '2026-5-22 18:30', 1000000, 'Completed'),
    (5, 'Red Bulls', 'Sân Kỳ Hòa', '2026-5-23 20:00', 1300000, 'Cancelled'),
    (4, 'Young Boys', 'Sân Hoàng Văn Thụ', '2026-5-24 17:30', 1100000, 'Scheduled');

insert into match_registrations(match_id, player_id, attendance_status, goals, registered_at)
values
	(7002, 1, 'Played', 2, '2026-5-19 09:00'),
    (7002, 3, 'Played', 0, '2026-5-19 09:15'),
    (7001, 2, 'Registered', 0, '2026-5-18 20:00'),
    (7003, 5, 'Played', 1, '2026-5-20 08:30'),
    (7004, 4, 'Absent', 0, '2026-5-21 10:00');

insert into team_logs (registration_id, player_id, log_time, note)
values
	(8003, 2, '2026-5-18 20:05', 'Xác nhận tham gia'),
    (8001, 1, '2026-5-19 09:05', 'Đăng ký đá chính'),
    (8002, 3, '2026-5-19 09:20', 'Xác nhận tham gia'),
    (8004, 5, '2026-5-20 08:35', 'Đã có mặt tại sân'),
    (8005, 4, '2026-5-23 20:05', 'Vắng mặt không báo trước');

-- Câu 2 Update
	-- 1 Tăng pitch_fee  thêm 100.000 đồngcho các trận đồng thời thỏa mãn:Trạng thái là Completed
set sql_safe_updates = 0;
update matches set pitch_fee = pitch_fee + 100000
where status = 'Completed';


	-- 2 Xóa các bản ghi trong team_logs có log_time trước ngày 20/05/2026
delete from team_logs where log_time < '2026-05-20';
    
set sql_safe_updates = 1;

-- Phần 3 Truy Vấn cơ bản
	-- câu 1 liệt kê full_name, preferred_position, skill_rating của cầu thủ có 
    -- skill_rating > 7.8 hoặc có preferred_position  là 'Tiền vệ'
select full_name, preferred_position, skill_rating 
from players
where skill_rating > 7.8 or preferred_position = 'Tiền vệ';
	
    /*
	Câu 2  Liệt kê opponent_name, venue và match_time của các trận:
- Diễn ra từ ngày 2026-05-20 đến hết ngày 2026-05-22.
- Tên đội đối thủ bắt đầu bằng chữ B.
    */
select  opponent_name ,venue ,match_time
from matches
where match_time >= '2026-05-20'
and match_time <= '2026-05-22'
and opponent_name like 'B%';

	/*
    Câu 3 – 5 điểm: Liệt kê registration_id, goals và registered_at:
- Sắp xếp goals giảm dần.
- Nếu số bàn thắng bằng nhau, sắp xếp registration_id tăng dần.
- Mỗi trang có 2 bản ghi.
- Chỉ hiển thị trang thứ hai.
    */
select registration_id, goals, registered_at
from match_registrations
order by goals desc , registration_id asc
limit 2 offset 2;

-- PHẦN 4. TRUY VẤN NÂNG CAO
/*
Câu 1 – 5 điểm: Kết hợp các bảng liên quan để liệt kê:
- Tên đội bóng.
- Tên đội đối thủ. ?? khong biet
- Họ tên cầu thủ.
- Vị trí sở trường.
- Số bàn thắng.
- Thời gian thi đấu.
*/
select m.opponent_name, 
	p.full_name, 
	p.preferred_position,
    mr.goals,
    mr.registered_at
from match_registrations mr
join matches m on m.match_id = mr.match_id
join players p on p.player_id = mr.player_id;

/*
Câu 2 – 5 điểm: Liệt kê họ tên cầu thủ và tổng số bàn thắng trong các đăng ký 
có attendance_status = 'Played'. Chỉ hiển thị những cầu thủ có tổng số bàn thắng lớn hơn 1.
*/
select p.full_name , sum(mr.goals) as total_goals 
from match_registrations mr
join players p on p.player_id = mr.player_id
group by mr.player_id, p.full_name
having total_goals > 1;

/*
Câu 3 – 5 điểm: Liệt kê player_id, full_name và skill_rating của cầu thủ có điểm kỹ 
năng cao nhất. Nếu nhiều cầu thủ đồng hạng cao nhất, phải hiển thị tất cả.
*/
select player_id, full_name, skill_rating
from players
where skill_rating in (
	select max(skill_rating) from players);

-- PHẦN 5. INDEX & VIEW (10 ĐIỂM)
/*
Câu 1 – 5 điểm: Tạo chỉ mục kết hợp trên bảng match_registrations, gồm:
- attendance_status
- goals
*/
create index idx_attendancestatus_goals 
on match_registrations(attendance_status,goals);

/*
Câu 2 – 5 điểm: Tạo một view hiển thị:
- player_id
- full_name
- Tổng số trận đã đăng ký
- Tổng số bàn thắng
Yêu cầu:
- Không tính các đăng ký có attendance_status = 'Absent'.
- Cầu thủ chưa có đăng ký hợp lệ vẫn phải xuất hiện.       ---> ?? khong hieu
- Các giá trị tổng của cầu thủ chưa có đăng ký bằng 0.   ---->    ?? khong hieu
*/
create view infor_players as
select 
	p.player_id,
	p.full_name, 
	count(mr.player_id) as total_matchs,
    sum(mr.goals) as total_goals
from match_registrations mr
join players p on p.player_id = mr.player_id
where attendance_status <> 'Absent'
group by p.player_id, p.full_name;

-- kiểm thử view infor_players
select * from infor_players;

-- PHẦN 6. TRIGGER
/*
Câu 1 – 5 điểm
Viết trigger chạy sau khi cập nhật bảng match_registrations.
Khi attendance_status thực sự chuyển từ một giá trị khác sang Played,
 hệ thống tự động thêm một bản ghi vào team_logs với:
- registration_id: mã đăng ký vừa cập nhật.
- player_id: cầu thủ của đăng ký.
- note: Player confirmed as played.
- log_time: thời gian hiện tại của hệ thống.
Không ghi nhật ký nếu bản ghi đã có trạng thái Played và chỉ cập nhật một cột khác.
*/
delimiter //
create trigger after_update_match_registrations
after update
on match_registrations for each row
begin
	if new.attendance_status <> old.attendance_status 
    and new.attendance_status = 'Played' then
    
    insert into team_logs (registration_id, player_id, log_time, note)
    values (new.registration_id, new.player_id, current_timestamp, 'Player confirmed as played');
    
    end if;
end //
delimiter ;

-- kiem thu trigger
update match_registrations set attendance_status = 'Played'
where registration_id = 8003;
select * from team_logs; -- ok

/*
Câu 2 – 5 điểm
Viết trigger chạy sau khi thêm mới vào match_registrations.
Nếu bản ghi mới có attendance_status = 'Played':
- Tăng skill_rating của cầu thủ tương ứng thêm 0.1.
- Đảm bảo skill_rating không vượt quá 10.0.
*/
delimiter //
create trigger after_insert_match_registrations
after insert
on match_registrations for each row
begin
	if new.attendance_status = 'Played' then
    
    update players set skill_rating = least(skill_rating + 0.1, 10.0)
    where player_id = new.player_id;
    
    end if;
end //
delimiter ;

-- kiem thu trigger
insert into match_registrations(match_id, player_id, attendance_status, goals)
values (7002, 1, 'Played', 2); 
select * from players; -- --> ok da tang len 0.1

-- PHẦN 7. STORED PROCEDURE
/*
Câu 1 – 5 điểm
Viết stored procedure nhận vào mã cầu thủ và trả về thông báo
 dựa trên tổng số bàn thắng trong các đăng ký có attendance_status = 'Played':
- Tổng bàn thắng lớn hơn 3: Top scorer.
- Tổng bàn thắng bằng 3: Target met.
- Tổng bàn thắng nhỏ hơn 3: Keep training.
- Nếu cầu thủ chưa thi đấu hoặc chưa ghi bàn, tổng số bàn thắng được xem là 0.
*/
delimiter //
create procedure check_top_goals (p_player_id int, out p_result varchar(255))
begin
    declare v_goals int;
    
    select sum(goals) into v_goals 
    from match_registrations 
    where attendance_status = 'Played' 
    and player_id = p_player_id;
    
    if v_goals > 3 then
		set p_result = 'Top scorer';
	elseif v_goals = 3 then
		set p_result = 'Target met';
	else
		set p_result = 'Keep training';
    end if;
end //
delimiter ;

-- kiem thu procedure
call check_top_goals (1, @message);
select @message;

/*
Câu 2 – 5 điểm
Viết stored procedure chuyển một lượt đăng ký thi đấu sang cầu thủ khác. Procedure nhận vào:
- Mã đăng ký thi đấu.
- Mã cầu thủ mới.
Quy trình:
1. Bắt đầu transaction.
2. Cập nhật player_id mới trong match_registrations.
3. Thêm một bản ghi vào team_logs với:
  - registration_id đang xử lý.
  - player_id mới.
  - note = 'Player reassigned'.
  - log_time là thời gian hiện tại.
4. Nếu thành công thì COMMIT.
5. Nếu có lỗi ở bất kỳ bước nào thì ROLLBACK bằng EXIT HANDLER.
*/
delimiter //
create procedure change_register (p_registration_id int, p_player_id int)
begin
	declare exit handler for sqlexception
    begin
		rollback;
        select 'Transaction failed, rolled back' as message;
	end;
    
    start transaction;
    update match_registrations set player_id = p_player_id
    where registration_id = p_registration_id;
    
    insert into team_logs (registration_id, player_id, log_time, note)
    values (p_registration_id, p_player_id, current_timestamp, 'Player reassigned');
    
    commit;
    select 'Change successful' as message;
    
end //
delimiter ;

-- kiểm thử procedure

call change_register (8002,1); -- Ok đã đổi thành công và team_logs củng đã insert
select * from match_registrations;
select * from team_logs;
call change_register (8002,7); -- kiểm thử thất bại thành công trả về thông báo lỗi
