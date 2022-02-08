DROP DATABASE IF EXISTS yoga_pro;
CREATE DATABASE yoga_pro;
USE yoga_pro;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED UNIQUE
); #таблица пользователи

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender ENUM('W','M'),
    birthday DATE,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    experience BIGINT,
    
    FOREIGN KEY (user_id) REFERENCES users(id)
); # таблица профили

DROP TABLE IF EXISTS payment;
CREATE TABLE payment (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	umount DECIMAL(6,2), #сумма оплаты
	discount_id BIGINT UNSIGNED,
	start_subscription DATETIME DEFAULT NOW(),#начало действия абонемента
	finish_sudscription DATETIME,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
	#FOREIGN KEY (discount_id) REFERENCES discount(id)
	
); #таблица оплаты абонементов

DROP TABLE IF EXISTS discount;
CREATE TABLE discount (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	procent BIGINT UNSIGNED NOT NULL,
 	time_action DATE NOT NULL # время действия
); #таблица скидок

DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at DATETIME DEFAULT NOW(),
	firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100),
	teacher_information TEXT #информация о преподавателе
); #таблица преподаватели

DROP TABLE IF EXISTS class;
CREATE TABLE class (
	id SERIAL,
	class_name ENUM('hatha_yoga','meditation_yoga', 'yoga_nidru'),
	`level` ENUM('new','pro'),
	created_at DATETIME DEFAULT NOW()
); #таблица группы

DROP TABLE IF EXISTS class_users;
CREATE TABLE class_users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	teacher_id BIGINT UNSIGNED NOT NULL,
	class_id BIGINT UNSIGNED NOT NULL,
	date_wede_in DATETIME DEFAULT NOW(), #дата вступления
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	FOREIGN KEY (class_id) REFERENCES class(id)
); #таблица группы_ пользователи

DROP TABLE IF EXISTS video_lessons;
CREATE TABLE video_lessons (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	videos text, #ссылка на видео
	teacher_id BIGINT UNSIGNED NOT NULL,
	class_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	FOREIGN KEY (class_id) REFERENCES class(id)
); #таблица видео уроки

DROP TABLE IF EXISTS mention;
CREATE TABLE mention (
	id SERIAL,
	created_at DATETIME DEFAULT NOW(),
	reting ENUM('1', '2', '3', '4', '5'),
	body TEXT,
	user_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
);# таблица отзывов

DROP TABLE IF EXISTS messages_teacher;
CREATE TABLE messages_teacher (
	id SERIAL,
	created_at DATETIME DEFAULT NOW(),
	teacher_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('in','out'), # статус сообщения приеподавателю либо влодящее либо исход
	body TEXT,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id)
); # таблица общение с преподавателем


