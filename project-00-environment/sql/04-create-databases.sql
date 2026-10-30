/*
Project 0
Step 04：建立後續學習資料庫

執行帳號：
postgres

目的：
建立後續 SQL 學習專案需要的 Database，
並把 sql_student 設定成 Database Owner。
*/


/*
Chinook

主要使用於：
Project 1：單表查詢
Project 2：關聯資料與報表
Project 3：進階查詢前半
*/
CREATE DATABASE chinook
OWNER sql_student;


/*
Pagila

主要使用於：
Project 3：進階查詢後半
Project 6：View / Function / Trigger / 權限
Project 7：效能與索引
Project 8：PostgreSQL 進階功能
*/
CREATE DATABASE pagila
OWNER sql_student;


/*
SQL Design Lab

自己建立 Schema 與資料表用。

主要使用於：
Project 4：資料異動與 Transaction
Project 5：關聯式資料庫設計
*/
CREATE DATABASE sql_design_lab
OWNER sql_student;