-- PHAN 1: THIET KE CSDL
DROP DATABASE IF EXISTS module2;

CREATE DATABASE module2;

USE module2;

-- 1. Bang courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    creation_date DATE
);

-- 2. Bang students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    major VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    gpa DECIMAL(3, 1) DEFAULT 4.0,
    CHECK (gpa >= 0 AND gpa <= 4.0)
);

-- 3. Bang enrollments (dang ky hoc)
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    student_id INT,
    enroll_time DATETIME,
    credits INT,
    status ENUM('Pending', 'Completed', 'Dropped'),
    CHECK (credits > 0),
    FOREIGN KEY (course_id) REFERENCES courses (course_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
) AUTO_INCREMENT = 7001;

-- 4. Bang enrollment_details (chi tiet dang ky)
CREATE TABLE enrollment_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT,
    attendance_check VARCHAR(150) NOT NULL,
    detail_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments (enrollment_id)
) AUTO_INCREMENT = 8001;

-- 5. Bang academic_logs (nhat ky hoc vu)
CREATE TABLE academic_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT,
    student_id INT,
    log_time DATETIME NOT NULL,
    note TEXT,
    foreign key (enrollment_id) references enrollments (enrollment_id),
    foreign key (student_id) 	references students (student_id)
);

-- PHAN 2: DML (INSERT, UPDATE, DELETE)
-- Cau 1: INSERT

-- Bang courses
INSERT INTO courses (course_name, course_code, department, creation_date)
VALUES
    ('Lập trình Java', 'JAVA01', 'CNTT', '2023-12-03'),
    ('Cấu trúc dữ liệu', 'DSA02', 'Khoa học máy tính', '1996-11-25'),
    ('Cơ sở dữ liệu', 'SQL03', 'CNTT', '2001-07-08'),
    ('Mạng máy tính', 'NET04', 'Truyền thông', '1998-01-19'),
    ('Trí tuệ nhân tạo', 'AI05', 'Khoa học máy tính', '2000-09-30');

-- Bang students
INSERT INTO students (full_name, major, phone_number, gpa)
VALUES
    ('Nguyễn Văn Hải', 'Hệ thống TT', '0931112223', 3.8),
    ('Trần Thu Hà', 'Kỹ thuật PM', '0932223334', 4.0),
    ('Lê Quốc Tuấn','An toàn TT', '0933334445', 3.6),
    ('Phạm Minh CHâu', 'Dữ liệu lớn', '0934445556', 3.9),
    ('Hoàng Gia Bảo', 'Kỹ thuật PM', '0935556667', 3.7);

-- Bang enrollments
insert into enrollments (course_id, student_id, enroll_time, credits, status)
values
	(1, 1, '2024-05-20 08:00', 3, 'Pending'),
    (2, 2, '2024-05-20 09:30', 4, 'Completed'),
    (3, 3, '2024-05-20 10:15', 3, 'Pending'),
    (4, 5, '2024-05-21 07:00', 3, 'Completed'),
    (5, 4, '2024-05-21 08:45', 4, 'Dropped');

-- Bang enrollment_details
insert into enrollment_details (enrollment_id, attendance_check, detail_date)
values
	(7002, 'Đủ điều kiện thi', '2024-05-20 10:00'),
    (7004, 'Vắng 1 buổi', '2024-05-21 08:00'),
    (7001, 'Đang học', '2024-05-20 09:00'),
    (7003, 'Nghỉ phép', '2024-05-20 11:00'),
    (7005, 'Không đi học', '2024-05-21 09:00');

-- Bang academic_logs
insert into academic_logs (enrollment_id, student_id, log_time, note)
values
	(7001, 1, '2024-05-20 09:05', 'Bắt đầu lớp học'),
    (7002, 2, '2024-05-20 10:50', 'Hoàn tất môn học' ),
    (7003, 3, '2024-05-20 11:10', 'Đang sắp xếp lịch bù'),
    (7004, 5, '2024-05-21 08:10', 'Chờ phê duyệt'),
    (7005, 4, '2024-05-21 09:05', 'Hủy do vắng quá số buổi');

-- Cau 2 UPDATE DELETE
	-- Tang them 1 credits cho cac ban ghi da completed creation_date < 2000
set sql_safe_updates = 0;
update enrollments set credits = credits + 1 
where status = 'Completed' and course_id in (
	select course_id from courses where creation_date < '2000-01-01');
set sql_safe_updates = 1;

    -- Xoa ban ghi trong academic_log  co log_time < 20-05-2024
set sql_safe_updates = 0;
delete from academic_logs where log_time < '2024-05-20';
set sql_safe_updates = 1;

-- PHẦN 3 : TRUY VẤN CƠ BẢN
	-- CÂU 1 : Liệt kê các thông tin full_name, major và gpa của những sv có GPA > 3.8 and major = 'Kỹ thuật PM'
select full_name, major, gpa from students
where major = 'Kỹ thuật PM' and gpa > 3.8;

	-- CÂU 2 : course_name và course_code có ngày tạo từ 1998-01-01 đến 2001-12-31 mã học phần bắt đầu bằng "A"
select course_name, course_code from courses
where creation_date >= '1998-01-01' 
	and creation_date <= '2001-12-31' 
	and course_code like 'A%';

	-- CÂU 3 :
select enrollment_id, enroll_time, credits from enrollments
order by credits desc
limit 2 offset 2;

-- Phần 4 : Truy vấn nâng cao
	-- Câu 1 : liệt kê course_name, full_name , major, credits, creation_time
select c.course_name, s.full_name, s.major, e.credits, e.enroll_time
from enrollments e
join students s on s.student_id = e.student_id 
join courses c  on c.course_id  = e.course_id;

	-- Câu 2 : Liệt kê full_name, Sum(credits) chỉ những môn completed và credits > 120
select s.full_name, sum(credits) as total_credits
from enrollments e 
join students s on s.student_id = e.student_id
where e.status = 'Completed'
group by s.student_id, s.full_name
having total_credits > 120;

	-- Câu 3 : Liệt kê student_id, full_name và gpa của những sv có trung bình GPA cao nhât ??
select student_id, full_name, gpa from students
where gpa = (select max(gpa) from students);

-- PHẦN 5 : INDEX & VIEW
	-- CÂU 1 Tạo index cho status và credits của enrollments
create index idx_status_credits on enrollments (status,credits);

	-- CÂU 2 : tạo view hiển thị full_name, count(course_id), sum(credits) ngoại trừ status Dropped
create view v_infor_students
as
select s.full_name as 'Họ tên', count(e.course_id) as 'Tổng số môn', sum(e.credits) as 'Tổng số tín chỉ'
from enrollments e 
join students s on s.student_id = e.student_id
where e.status <> 'Dropped'
group by e.student_id, s.full_name;

-- PHẦN 6 TRIGGER
	-- CẤU 1 : Khi status của enrollments -> completed, thì insert academic_logs
delimiter //
create trigger after_update_status_enrollments 
after update
on enrollments for each row
begin
	if old.status <> new.status and new.status = 'Completed' then
    insert into academic_logs (enrollment_id, student_id, log_time, note)
    values (new.enrollment_id, new.student_id, current_timestamp, 'Course completed');
	end if;
end //
delimiter ;

	-- CÂU 2 : khi insert vào enrollments với status = 'Completed' then GPA của student tăng 0,1 (khong quá 4.0)
delimiter //
create trigger after_insert_enrollments
after insert
on enrollments for each row
begin
	declare v_gpa decimal(3,1);
    select gpa into v_gpa from students where student_id = new.student_id;
	if new.status = 'Completed' and v_gpa < 4.0 then
		update students set gpa = gpa + 0.1 where student_id = new.student_id ;
	end if;
end //
delimiter ;

-- PHẦN 7 : STORED PROCEDURE
	-- CÂU 1 : tạo procedure nhận student_id và trả về thông báo kết quả 
delimiter //
create procedure display_credits_progress 
	(p_student_id int, out p_message varchar(255))
begin
	declare v_total_credits int;
    select sum(credits) into v_total_credits from enrollments
    where student_id = p_student_id;
    
    if v_total_credits > 100 then
		set p_message = 'Excellent progress';
	elseif v_total_credits = 100 then
		set p_message = 'Target met';
	else 
		set p_message = 'Normal progress';
    end if;
end //
delimiter ;

call display_credits_progress (1, @message);
select @message;

	-- CÂU 2 : Thực hiện nhượng quyền tham gia lớp học cho một mã đăng ký
delimiter //
create procedure change_students (p_enrollment_id int, p_student_id int)
begin
	declare exit handler for sqlexception
	begin
		rollback;
        select 'Transaction falied, rolled back' as message;
	end;
    
    start transaction;
    update enrollments set student_id = p_student_id
    where enrollment_id = p_enrollment_id;
    
    insert into academic_logs (enrollment_id, student_id, log_time, note)
    values (p_enrollment_id, p_student_id, current_timestamp, 'Student reassigned');
    
    commit;
    select 'Change student of enrollment is succcessful' as message;
end //
delimiter ;




