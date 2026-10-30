# PostgreSQL Structure

## 目的

本筆記整理 PostgreSQL 最基本的結構與執行環境概念。

主要理解：

```text
PostgreSQL Server
Database
Schema
Table
Column
Row
View
Sequence
Role
Connection
Session
Transaction
```

---

# 1. PostgreSQL Server

PostgreSQL Server 是實際執行 SQL、管理資料與處理連線的 Database Server。

目前環境：

```text
Windows 10
└─ Visual Studio Code
      │
      │ PostgreSQL Protocol
      ▼
Linux VM
└─ Docker
   └─ PostgreSQL Server
```

Visual Studio Code 是 Client。

PostgreSQL Server 位於 Linux Docker Container。

---

# 2. Database

一個 PostgreSQL Server 可以同時管理多個 Database。

例如：

```text
PostgreSQL Server
│
├─ postgres
├─ chinook
├─ pagila
└─ sql_design_lab
```

查看目前 Database：

```sql
SELECT current_database();
```

Database 是 PostgreSQL 中較大的資料隔離單位。

一般 Connection 會連入其中一個 Database。

---

# 3. Schema

一個 Database 可以包含多個 Schema。

```text
Database
│
├─ public
├─ accounting
└─ reporting
```

Schema 可以理解成：

> Database 內部用來分類與命名 Database Object 的 Namespace。

例如：

```text
public.products
```

代表：

```text
public
→ Schema

products
→ Table
```

查詢：

```sql
SELECT *
FROM public.products;
```

---

# 4. Database 與 Schema 的差異

基本結構：

```text
PostgreSQL Server
└─ Database
   └─ Schema
      └─ Table
```

Database 是較大的隔離單位。

Schema 是 Database 內部的 Namespace。

例如：

```text
chinook
└─ public
   └─ Track
```

以及：

```text
sql_design_lab
└─ public
   └─ products
```

兩個 Database 即使都有：

```text
public
```

它們仍然是完全不同的 Schema。

---

# 5. Table

Table 是主要保存關聯式資料的 Database Object。

例如：

```text
products
│
├─ product_id
├─ name
├─ price
└─ created_at
```

其中：

```text
product_id
name
price
created_at
```

是 Column。

資料：

```text
product_id | name     | price
-----------+----------+------
1          | Keyboard | 1500
2          | Mouse    | 800
```

每一筆資料是一個 Row。

因此：

```text
Table
├─ Column
└─ Row
```

---

# 6. View

View 是根據 SQL Query 定義的資料庫物件。

例如：

```sql
CREATE VIEW expensive_products AS
SELECT
    product_id,
    name,
    price
FROM products
WHERE price >= 1000;
```

查詢：

```sql
SELECT *
FROM expensive_products;
```

一般 View 主要保存 Query Definition，而不是額外複製完整資料。

基本概念：

```text
View
↓
Query Definition
↓
Table
```

View 會在後續 Project 正式學習。

---

# 7. Sequence

Sequence 是負責產生數字序列的 Database Object。

例如：

```sql
CREATE SEQUENCE order_number_seq;
```

取得下一個值：

```sql
SELECT nextval('order_number_seq');
```

可能依序得到：

```text
1
2
3
4
...
```

Sequence 不是 Table。

它通常會與流水號、Identity 等概念一起出現。

---

# 8. Database 下面不只有 Schema

PostgreSQL Database 展開後可能看到：

```text
Database
│
├─ Schemas
├─ Extensions
├─ Languages
├─ Casts
├─ Foreign Data Wrappers
├─ Foreign Servers
├─ Event Triggers
├─ Publications
└─ Subscriptions
```

目前 SQL 學習主要關注：

```text
Schemas
```

其他功能目前只需要知道存在。

---

# 9. Schema 下面的 Database Objects

Schema 下面可能包含：

```text
Schema
│
├─ Tables
├─ Views
├─ Materialized Views
├─ Sequences
├─ Functions
├─ Procedures
├─ Types
└─ ...
```

目前優先順序：

```text
Tables
→ 現在主要使用

Views
Sequences
→ 先知道用途

Functions
Procedures
Types
→ 後續再學
```

---

# 10. public Schema

一般新建立的 PostgreSQL Database 通常會看到：

```text
public
```

Schema。

例如：

```text
chinook
└─ public
```

查詢：

```sql
SELECT current_schema();
```

常見結果：

```text
public
```

---

# 11. search_path

PostgreSQL 可以使用：

```sql
SHOW search_path;
```

查看 Schema 搜尋順序。

常見：

```text
"$user", public
```

因此：

```sql
SELECT *
FROM products;
```

如果 `products` 位於 `public` 且可以透過 `search_path` 找到，PostgreSQL 可以解析成：

```text
public.products
```

概念上：

```text
products
↓
依照 search_path 搜尋
↓
public.products
```

---

# 12. pg_catalog

`pg_catalog` 是 PostgreSQL 重要的 System Catalog Schema。

PostgreSQL 自己會使用它保存許多 Metadata。

例如：

```text
Database
Table
Column
Index
Role
Constraint
...
```

相關資訊。

例如：

```sql
SELECT *
FROM pg_database;
```

就是讀取 PostgreSQL System Catalog。

---

# 13. information_schema

`information_schema` 提供標準化的 Database Metadata Views。

例如：

```sql
SELECT
    table_schema,
    table_name
FROM information_schema.tables;
```

可以查看 Table Metadata。

學習 SQL 時，`information_schema` 很適合用來觀察 Database Structure。

---

# 14. Role

PostgreSQL 使用 Role 管理：

```text
Login
Permission
Object Ownership
Group Permission
```

例如：

```text
postgres
sql_student
```

都是 Role。

Role 不屬於某一個 Schema。

比較完整的結構應理解為：

```text
PostgreSQL Server
│
├─ Roles
│  ├─ postgres
│  └─ sql_student
│
└─ Databases
   ├─ chinook
   ├─ pagila
   └─ sql_design_lab
```

而不是：

```text
Database
└─ Schema
   └─ Role
```

---

# 15. LOGIN Role

Role 不一定可以登入。

例如：

```sql
CREATE ROLE sql_student
WITH
    LOGIN;
```

表示：

```text
Role
+
LOGIN
=
可以作為登入帳號
```

因此 PostgreSQL 的 User 可以理解為：

> 具有 LOGIN 能力的 Role。

---

# 16. Superuser

`postgres` 通常是 PostgreSQL Superuser。

Superuser 具有非常高的權限。

日常 SQL 練習不建議長期使用 Superuser。

本專案使用：

```text
postgres
→ 管理帳號

sql_student
→ 日常學習帳號
```

---

# 17. Database Owner

Database 可以指定某個 Role 為 Owner。

例如：

```sql
CREATE DATABASE chinook
OWNER sql_student;
```

關係：

```text
sql_student
     │
     │ owns
     ▼
chinook
```

Owner 是擁有關係。

不是階層關係：

```text
sql_student
└─ chinook
```

這樣理解是不正確的。

---

# 18. Connection

Connection 是 Client 與 PostgreSQL Server 之間建立的連線。

例如：

```text
VS Code
   │
   │ Connection
   ▼
PostgreSQL Server
```

也可能同時存在：

```text
PostgreSQL Server
│
├─ VS Code Connection
├─ pgAdmin Connection
├─ psql Connection
└─ Application Connection
```

---

# 19. Session

Client 建立 Connection 後，PostgreSQL 會建立對應的 Session。

Session 期間會存在一些狀態，例如：

```text
Current Database
Current User
Session Settings
Temporary Objects
Transaction State
```

可以查看目前 PostgreSQL Backend Process：

```sql
SELECT pg_backend_pid();
```

不同 Session 通常會取得不同的 Backend PID。

---

# 20. Transaction

Transaction 是一組 SQL 操作的執行單位。

基本形狀：

```sql
BEGIN;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;

COMMIT;
```

概念：

```text
BEGIN
│
├─ SQL
├─ SQL
└─ COMMIT
```

如果取消：

```sql
ROLLBACK;
```

概念：

```text
BEGIN
│
├─ SQL
├─ SQL
└─ ROLLBACK
```

Transaction 是執行時概念，不是永久 Database Object。

---

# 21. PostgreSQL 基本結構總覽

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
   │  │
   │  └─ Schemas
   │     │
   │     └─ public
   │        │
   │        ├─ Tables
   │        ├─ Views
   │        ├─ Sequences
   │        ├─ Functions
   │        └─ Types
   │
   ├─ pagila
   │
   └─ sql_design_lab
```

---

# 22. 最重要的操作路徑

使用 Visual Studio Code Object Explorer 尋找 Table 時：

```text
Connection
↓
Databases
↓
Database
↓
Schemas
↓
public
↓
Tables
```

例如：

```text
Docker PostgreSQL
└─ Databases
   └─ chinook
      └─ Schemas
         └─ public
            └─ Tables
```

從 MySQL 轉 PostgreSQL 時，可以先簡化理解為：

```text
MySQL

Server
└─ Database
   └─ Table
```

PostgreSQL：

```text
PostgreSQL

Server
└─ Database
   └─ Schema
      └─ Table
```

最重要的差異之一，就是 PostgreSQL 在 Database 與 Table 之間具有 Schema 這一層。

---

# 快速環境確認

```sql
SELECT
    current_database(),
    current_user,
    current_schema(),
    version();
```

分別可以確認：

```text
current_database()
→ Database

current_user
→ Role

current_schema()
→ Schema

version()
→ PostgreSQL Server
```