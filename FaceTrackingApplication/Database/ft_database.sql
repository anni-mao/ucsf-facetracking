CREATE TABLE IF NOT EXISTS patients_table (
Database_index integer primary key autoincrement,
Patient_ID varchar(500) NOT NULL,
Patient_data varchar(500) NOT NULL,
Exercise_type varchar(500) NOT NULL,
Physician_notes varchar(500) NOT NULL DEFAULT "",
Program_score int(100) NOT NULL DEFAULT "1",
createdate varchar(500) NOT NULL, 
users_id int(11) NOT NULL
) ;





CREATE TABLE IF NOT EXISTS users (
id integer primary key autoincrement,
`name` varchar(500) NOT NULL,
username varchar(500) NOT NULL,
`password` varchar(500) NOT NULL,
email varchar(500) NOT NULL,
vkey varchar(500) NOT NULL,
patient_setID int(100) NOT NULL,
verified int(1) NOT NULL DEFAULT "0",
usertype varchar(500) NOT NULL DEFAULT "patient",
createdate varchar(500) NOT NULL
) ;


INSERT INTO users (id, `name`, username, `password`, email, vkey, patient_setID, verified, usertype, createdate) VALUES
(1, 'AJ Smith', 'test email', '$2y$10$HZtMmC.3FQJf5GudV22HSugB/67Zbi/uTUt0QHd/0BWQF51mkKgQW', 'test@ucsf.edu', '$2y$10$5CBE6P5D216Bg8D2X/AbQuSFUk.pptAT6z1tGhENr7m9BWBX3mYvq', '111111111', 1, 'physician', '2021-10-10 07:28:24.526480'),
(2, 'Boba Smith', 'test user 2', '$2y$10$niI8MI.RCdsQeVwnLrAtde1cvsYXLwndp99o70qhY82fW4WzssO4O', 'mr.sickness718@gmail.com', '$2y$10$PvfD1hzSZNuHnkVeTyUht.26FUyqyMRs/6/df4ngwWLaOG7/6IwiO', '967831921', 0, 'patient', '2021-10-10 06:41:24.996411'),
(3, 'Ronin Coyote', 'test user 3', '$2y$10$mlVPyoOdHMqndjjcDZd6hOhAIgba2dRTXhDfV9h0zSoDcFL8d4b.O', 'smith@gmail.com', '$2y$10$qKjrFSvMGtIyCX1mOQyBFuhadVNXKlocTNnEYcFaNW.8U.zpYvmTm', '190055801', 0, 'patient', '2021-10-10 06:58:13.949121'),
(4, 'Blue Coyote', 'test user 4', '$2y$10$6yZ8e06IlbTeBgCodm5Mc.r.8vSqgAZBRZdbwfyq7FEIhuu0KEoUW', 'asajadesmith@gmail.com', '$2y$10$gcxWDw.h7NCz6SUGpwX87.iwrGIUR.KfDDgFcXCRySaaHm1w/0NTS', '880904600', 1, 'patient', '2021-10-10 07:21:35.387679');

