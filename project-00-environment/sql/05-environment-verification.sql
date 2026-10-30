/*
Project 0
Step 07：PostgreSQL 環境驗收

用途：
確認目前 VS Code PostgreSQL Connection
連到預期的 PostgreSQL Server、Database、Role 與 Schema。

建議使用：
Database : chinook
User     : sql_student
*/


/* =========================================================
   1. 確認目前 Database / User / Schema
   ========================================================= */

SELECT
    current_database() AS database_name,
    current_user       AS user_name,
    current_schema()   AS schema_name;


/* 預期：
database_name = chinook
user_name     = sql_student
schema_name   = public
*/


/* =========================================================
   2. 確認 PostgreSQL Server 版本
   ========================================================= */

SELECT
    version();


/*
你的環境目前應該會看到類似：

PostgreSQL 16.x
Debian Linux
x86_64
*/


/* =========================================================
   3. 查看 Server / Client 網路資訊
   ========================================================= */

SELECT
    inet_server_addr() AS server_address,
    inet_server_port() AS server_port,
    inet_client_addr() AS client_address;


/*
server_address：
PostgreSQL Server 看到自己的位址。

server_port：
目前 PostgreSQL 使用的 Port，預期為 5432。

client_address：
Server 看到的 Client 位址。
*/


/* =========================================================
   4. 確認目前 Session
   ========================================================= */

SELECT
    pg_backend_pid() AS backend_pid;


/*
PostgreSQL 對目前 Session 所使用的 Backend Process ID。

不同 Connection / Session
通常會有不同 PID。
*/


/* =========================================================
   5. 查看 search_path
   ========================================================= */

SHOW search_path;


/*
通常會看到類似：

"$user", public

這會影響 PostgreSQL 找尋沒有指定 Schema 的物件時，
會依什麼順序搜尋。
*/


/* =========================================================
   6. 確認目前 Database 裡有哪些 Schema
   ========================================================= */

SELECT
    schema_name
FROM information_schema.schemata
ORDER BY schema_name;


/*
常見：

information_schema
pg_catalog
pg_toast
public
*/


/* =========================================================
   7. 查看目前 Database 的一般 Table
   ========================================================= */

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema NOT IN (
    'pg_catalog',
    'information_schema'
)
ORDER BY
    table_schema,
    table_name;


/*
目前 chinook 如果還沒有匯入 Sample Database，
可能沒有一般 Table。

這是正常的。
*/


/* =========================================================
   8. 查看目前 Database 的 View
   ========================================================= */

SELECT
    table_schema,
    table_name
FROM information_schema.views
WHERE table_schema NOT IN (
    'pg_catalog',
    'information_schema'
)
ORDER BY
    table_schema,
    table_name;


/* =========================================================
   9. 查看目前 Database 的 Sequence
   ========================================================= */

SELECT
    sequence_schema,
    sequence_name
FROM information_schema.sequences
ORDER BY
    sequence_schema,
    sequence_name;


/* =========================================================
   10. 確認 sql_student Role
   ========================================================= */

SELECT
    rolname,
    rolcanlogin,
    rolsuper,
    rolcreatedb,
    rolcreaterole
FROM pg_roles
WHERE rolname = 'sql_student';


/*
預期：

rolname       = sql_student
rolcanlogin   = true
rolsuper      = false
rolcreatedb   = false
rolcreaterole = false
*/


/* =========================================================
   11. 查看學習用 Database 與 Owner
   ========================================================= */

SELECT
    d.datname AS database_name,
    r.rolname AS owner_name
FROM pg_database AS d
JOIN pg_roles AS r
    ON r.oid = d.datdba
WHERE d.datname IN (
    'chinook',
    'pagila',
    'sql_design_lab'
)
ORDER BY d.datname;


/*
預期：

chinook         | sql_student
pagila          | sql_student
sql_design_lab  | sql_student
*/


/* =========================================================
   12. 最後的快速環境資訊
   ========================================================= */

SELECT
    current_database() AS database_name,
    current_user       AS user_name,
    current_schema()   AS schema_name,
    inet_server_addr() AS server_address,
    inet_server_port() AS server_port,
    pg_backend_pid()   AS backend_pid;