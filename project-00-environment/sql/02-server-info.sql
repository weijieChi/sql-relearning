/*
Project 0
Step 02：理解 PostgreSQL 結構

這份 SQL 不修改資料。
主要用來觀察目前 PostgreSQL 的：
Database、Schema、Table、Role、Session。
*/ /* ---------------------------------------------------------
   1. 目前所在位置
--------------------------------------------------------- */
SELECT current_database() AS database_name,
       current_schema() AS schema_name,
       current_user AS user_name;

/* ---------------------------------------------------------
   2. 查看這個 PostgreSQL Server 裡有哪些 Database

   datistemplate = false：
   排除 PostgreSQL 內部使用的 template database。
--------------------------------------------------------- */
SELECT datname
FROM pg_database
WHERE datistemplate = false
ORDER BY datname;

/* ---------------------------------------------------------
   3. 查看目前 Database 裡有哪些 Schema
--------------------------------------------------------- */
SELECT schema_name
FROM information_schema.schemata
ORDER BY schema_name;

/* ---------------------------------------------------------
   4. 查看目前 Database 的一般 Table

   排除 PostgreSQL 系統 Schema，
   讓結果比較容易閱讀。
--------------------------------------------------------- */
SELECT table_schema,
       table_name
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog',
                           'information_schema')
ORDER BY table_schema,
         table_name;

/* ---------------------------------------------------------
   5. 查看 View
--------------------------------------------------------- */
SELECT table_schema,
       table_name
FROM information_schema.views
WHERE table_schema NOT IN ('pg_catalog',
                           'information_schema')
ORDER BY table_schema,
         table_name;

/* ---------------------------------------------------------
   6. 查看 Sequence
--------------------------------------------------------- */
SELECT sequence_schema,
       sequence_name
FROM information_schema.sequences
ORDER BY sequence_schema,
         sequence_name;

/* ---------------------------------------------------------
   7. 查看 PostgreSQL Role
--------------------------------------------------------- */
SELECT rolname,
       rolcanlogin,
       rolsuper
FROM pg_roles
ORDER BY rolname;

/* ---------------------------------------------------------
   8. 查看目前 Session 的 Backend Process ID
--------------------------------------------------------- */
SELECT pg_backend_pid() AS backend_pid;

/* ---------------------------------------------------------
   9. 查看目前 PostgreSQL search_path
--------------------------------------------------------- */ SHOW search_path;