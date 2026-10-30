# Project 0：PostgreSQL 環境與 SQL 工作區

## 專案目的

本專案是 SQL 重新學習系列的第 0 個專案。

主要目標不是練習大量 SQL 查詢，而是先建立一套穩定、可重建、容易理解的 PostgreSQL 學習環境。

完成本專案後，應能理解：

- PostgreSQL Server、Database、Schema、Table 的階層關係
- Role 與 Login 的基本概念
- Database Owner 的意義
- Connection、Session、Transaction 的基本差異
- SQL 指令的基本分類
- 如何使用 Visual Studio Code 操作遠端 PostgreSQL
- 如何使用一般學習帳號，而不是長期使用 PostgreSQL Superuser
- 如何確認目前連線所使用的 Database、User、Schema 與 Server

---

# 環境

## Client

```text
Windows 10
└─ Visual Studio Code
   └─ PostgreSQL Extension (Microsoft)
```

Visual Studio Code 作為主要 SQL 編輯與查詢工具。

一般 SQL 可以直接透過 PostgreSQL Query Editor 執行，不需要在 Windows 安裝 PostgreSQL Server。

---

## PostgreSQL Server

```text
Windows 10
    │
    │ PostgreSQL Protocol / TCP 5432
    ▼
Linux VM
    │
    └─ Docker
       └─ PostgreSQL 16
```

PostgreSQL Server 執行於 Linux Docker Container 中。

目前 PostgreSQL Server：

```text
PostgreSQL 16.14
Debian Linux
x86_64
```

---

## SSL

目前為私人學習環境，因此 VS Code PostgreSQL Connection 使用：

```text
SSL Mode = Disable
```

TLS / SSL 不屬於目前 SQL 學習主線。

未來如有需要，可另外建立 PostgreSQL TLS Lab。

---

# 專案目錄

```text
project-00-environment/
│
├─ README.md
│
├─ sql/
│  ├─ 01-connection-check.sql
│  ├─ 02-server-info.sql
│  ├─ 03-create-student-role.sql
│  ├─ 04-create-databases.sql
│  └─ 05-environment-verification.sql
│
└─ notes/
   ├─ postgresql-structure.md
   └─ sql-command-types.md
```

---

# Step 01：VS Code 連線 PostgreSQL

使用 Visual Studio Code 的 PostgreSQL Extension 連線 Linux Docker 中的 PostgreSQL Server。

基本驗證：

```sql
SELECT
    current_database(),
    current_user,
    current_schema(),
    version();
```

實際確認結果：

```text
current_database = postgres
current_user     = postgres
current_schema   = public
PostgreSQL       = 16.14
```

這代表：

```text
VS Code
   │
   │ PostgreSQL Protocol
   ▼
Linux PostgreSQL Server
```

連線成功。

---

# Step 02：理解 PostgreSQL 結構

主要資料庫物件階層：

```text
PostgreSQL Server
└─ Database
   └─ Schema
      └─ Table
         ├─ Column
         └─ Row
```

實際上 Database 下面還會有其他物件：

```text
Database
│
├─ Schemas
├─ Extensions
├─ Languages
├─ Casts
├─ Foreign Data Wrappers
├─ Event Triggers
├─ Publications
└─ Subscriptions
```

目前 SQL 學習主線主要關注：

```text
Database
└─ Schema
   ├─ Table
   ├─ View
   ├─ Sequence
   ├─ Function
   └─ Type
```

其他 Database-level 功能在後續 PostgreSQL 進階或 DBA 主題再學習。

---

# Step 03：建立日常學習帳號

PostgreSQL 中登入帳號本質上也是 Role。

建立：

```sql
CREATE ROLE sql_student
WITH
    LOGIN
    PASSWORD '請自行設定密碼';
```

`sql_student` 預期權限：

```text
LOGIN       = true
SUPERUSER   = false
CREATEDB    = false
CREATEROLE  = false
```

確認：

```sql
SELECT
    rolname,
    rolcanlogin,
    rolsuper,
    rolcreatedb,
    rolcreaterole
FROM pg_roles
WHERE rolname = 'sql_student';
```

用途分工：

```text
postgres
├─ 建立 Role
├─ 建立 Database
├─ 權限管理
└─ Server / Database 管理

sql_student
├─ SELECT
├─ INSERT
├─ UPDATE
├─ DELETE
├─ CREATE TABLE
└─ 日常 SQL 學習
```

不要把真實密碼提交到 Git。

---

# Step 04：建立後續學習資料庫

使用 `postgres` 管理帳號建立：

```sql
CREATE DATABASE chinook
OWNER sql_student;

CREATE DATABASE pagila
OWNER sql_student;

CREATE DATABASE sql_design_lab
OWNER sql_student;
```

用途：

| Database | 用途 |
|---|---|
| `chinook` | Project 1～3 的主要 SQL 查詢練習 |
| `pagila` | 複雜查詢、資料庫程式、效能與 PostgreSQL 進階 |
| `sql_design_lab` | 自建 Schema、Transaction 與資料庫設計 |

確認 Database Owner：

```sql
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
```

預期：

```text
chinook         | sql_student
pagila          | sql_student
sql_design_lab  | sql_student
```

---

# Step 05：建立第二個 VS Code Connection

保留兩組 Connection。

```text
Docker PostgreSQL - Admin
└─ User: postgres

Docker PostgreSQL - Student
└─ User: sql_student
```

用途：

```text
Admin Connection
├─ CREATE ROLE
├─ CREATE DATABASE
├─ GRANT / REVOKE
└─ 環境管理

Student Connection
├─ SELECT
├─ INSERT
├─ UPDATE
├─ DELETE
├─ CREATE TABLE
└─ 一般 SQL 練習
```

Student Connection：

```text
Database : chinook
User     : sql_student
SSL Mode : Disable
```

驗證：

```sql
SELECT
    current_database(),
    current_user,
    current_schema();
```

預期：

```text
chinook
sql_student
public
```

---

# Step 06：認識 SQL 指令分類

SQL 學習先區分五個主要類型：

| 分類 | 用途 | 常見指令 |
|---|---|---|
| DQL | 查詢資料 | `SELECT` |
| DML | 修改資料 | `INSERT`, `UPDATE`, `DELETE` |
| DDL | 修改資料庫結構 | `CREATE`, `ALTER`, `DROP` |
| TCL | 控制 Transaction | `BEGIN`, `COMMIT`, `ROLLBACK` |
| DCL | 控制權限 | `GRANT`, `REVOKE` |

快速判斷：

```text
SELECT
→ 查資料

INSERT / UPDATE / DELETE
→ 改資料

CREATE / ALTER / DROP
→ 改結構

BEGIN / COMMIT / ROLLBACK
→ 控制 Transaction

GRANT / REVOKE
→ 控制 Permission
```

詳細筆記：

```text
notes/sql-command-types.md
```

---

# Step 07：環境驗收

主要驗收檔案：

```text
sql/05-environment-verification.sql
```

快速驗證：

```sql
SELECT
    current_database() AS database_name,
    current_user       AS user_name,
    current_schema()   AS schema_name,
    inet_server_addr() AS server_address,
    inet_server_port() AS server_port,
    pg_backend_pid()   AS backend_pid;
```

這條 SQL 可以快速確認：

```text
Database
User
Schema
Server
Port
Session
```

---

# PostgreSQL 主要結構

目前需要建立的核心心智模型：

```text
PostgreSQL Server
│
├─ Roles
│  ├─ postgres
│  └─ sql_student
│
└─ Databases
   │
   ├─ chinook
   │  └─ Schemas
   │     └─ public
   │        └─ Tables
   │
   ├─ pagila
   │
   └─ sql_design_lab
```

需要注意：

```text
sql_student ── owns ──> chinook
```

`Owner` 是擁有關係，不是階層包含關係。

---

# Database 與 Schema

Database：

```text
PostgreSQL Server
└─ Database
```

Schema：

```text
Database
└─ Schema
```

Table：

```text
Database
└─ Schema
   └─ Table
```

例如：

```sql
SELECT *
FROM public.products;
```

其中：

```text
public
→ Schema

products
→ Table
```

一般 PostgreSQL Object Name 常見形式：

```text
schema.table
```

而不是：

```text
database.schema.table
```

---

# Connection 與 Session

Connection：

```text
VS Code
   │
   │ Connection
   ▼
PostgreSQL Server
```

建立連線後，PostgreSQL 會建立對應 Session。

可以使用：

```sql
SELECT pg_backend_pid();
```

查看目前 Session 對應的 Backend Process ID。

---

# Project 0 驗收條件

完成 Project 0 後，應能自行說明：

1. PostgreSQL Server 與 Database 的差異。
2. Database 與 Schema 的差異。
3. Schema 與 Table 的差異。
4. Role 與 Login 的關係。
5. `postgres` 與 `sql_student` 為什麼要分開。
6. Database Owner 的用途。
7. Connection 與 Session 的基本差異。
8. Transaction 是什麼。
9. `SELECT`、`INSERT`、`CREATE`、`COMMIT`、`GRANT` 分別屬於哪一類 SQL。
10. 如何確認目前連線的 Database、User 與 Schema。

最基本驗收 SQL：

```sql
SELECT
    current_database(),
    current_user,
    current_schema(),
    version();
```

---

# Project 0 完成狀態

```text
[x] Step 01：VS Code 連線 PostgreSQL
[x] Step 02：理解 PostgreSQL 結構
[x] Step 03：建立日常學習帳號
[x] Step 04：建立後續學習資料庫
[x] Step 05：建立第二個 VS Code Connection
[x] Step 06：認識 SQL 指令分類
[x] Step 07：建立環境驗收 SQL
```

Project 0 完成。

下一階段：

```text
Project 1：單表查詢實驗室
```

主要使用：

```text
chinook
```

作為 SQL 查詢練習資料庫。