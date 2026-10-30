/*
Project 0
Step 03：建立日常學習帳號

目的：
1. 保留 postgres 作為環境管理帳號。
2. 建立 sql_student 作為平常 SQL 練習帳號。
3. 避免所有操作都使用 Superuser。
*/


CREATE ROLE sql_student
WITH
    LOGIN
    PASSWORD 'change-this-user-password';