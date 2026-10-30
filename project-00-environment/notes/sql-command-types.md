# SQL Command Types

## 目的

SQL 指令可以依照主要用途分成不同類型。

本專案先使用五個常見分類：

```text
DQL
DML
DDL
TCL
DCL
```

重點不是死背英文縮寫。

真正需要理解的是：

```text
這條 SQL 到底是在：

查資料？
改資料？
改結構？
控制 Transaction？
控制 Permission？
```

---

# SQL 指令分類總表

| 分類 | 全名 | 用途 | 常見指令 |
|---|---|---|---|
| DQL | Data Query Language | 查詢資料 | `SELECT` |
| DML | Data Manipulation Language | 修改資料 | `INSERT`, `UPDATE`, `DELETE` |
| DDL | Data Definition Language | 定義或修改結構 | `CREATE`, `ALTER`, `DROP` |
| TCL | Transaction Control Language | 控制 Transaction | `BEGIN`, `COMMIT`, `ROLLBACK` |
| DCL | Data Control Language | 控制 Permission | `GRANT`, `REVOKE` |

---

# 1. DQL

DQL：

```text
Data Query Language
```

用途：

> 查詢資料。

最重要的指令：

```sql
SELECT
```

例如：

```sql
SELECT
    product_id,
    name,
    price
FROM products;
```

概念：

```text
Database 已經有資料
↓
SELECT
↓
取得 Query Result
```

原始 Table 內容不會因為單純 `SELECT` 而被修改。

---

## DQL 範例

```sql
SELECT *
FROM products;
```

```sql
SELECT
    name,
    price
FROM products
WHERE price >= 1000;
```

兩者都屬於查詢。

---

# 2. DML

DML：

```text
Data Manipulation Language
```

用途：

> 修改 Table 中的資料。

主要指令：

```text
INSERT
UPDATE
DELETE
```

---

## INSERT

新增 Row：

```sql
INSERT INTO products (
    product_id,
    name,
    price
)
VALUES (
    1,
    'Keyboard',
    1500
);
```

概念：

```text
Table 結構
不變

Row
增加
```

---

## UPDATE

修改已有 Row：

```sql
UPDATE products
SET price = 1800
WHERE product_id = 1;
```

概念：

```text
Table 結構
不變

Row 中的資料
改變
```

---

## DELETE

刪除 Row：

```sql
DELETE FROM products
WHERE product_id = 1;
```

概念：

```text
Table 還存在

符合條件的 Row
被刪除
```

---

# 3. DDL

DDL：

```text
Data Definition Language
```

用途：

> 建立、修改或刪除 Database Object 的結構。

主要指令：

```text
CREATE
ALTER
DROP
```

---

## CREATE

例如建立 Table：

```sql
CREATE TABLE products (
    product_id integer,
    name text,
    price numeric
);
```

這不是加入商品資料。

而是在建立：

```text
Table Structure
```

---

## ALTER

修改 Table 結構：

```sql
ALTER TABLE products
ADD COLUMN description text;
```

修改前：

```text
products
├─ product_id
├─ name
└─ price
```

修改後：

```text
products
├─ product_id
├─ name
├─ price
└─ description
```

---

## DROP

刪除 Database Object：

```sql
DROP TABLE products;
```

這會刪除整張 Table。

不是只刪除其中的 Row。

---

# DDL 與 DML 的重要差異

DDL：

```sql
CREATE TABLE products (...);
```

代表：

```text
建立 Table 結構
```

DML：

```sql
INSERT INTO products (...);
```

代表：

```text
在 Table 裡新增資料
```

因此可以簡化成：

```text
DDL
→ 改 Structure

DML
→ 改 Data
```

---

# 4. TCL

TCL：

```text
Transaction Control Language
```

用途：

> 控制一組 SQL 操作的 Transaction。

主要指令：

```text
BEGIN
COMMIT
ROLLBACK
```

---

## BEGIN

開始 Transaction：

```sql
BEGIN;
```

---

## COMMIT

確認 Transaction：

```sql
COMMIT;
```

代表：

> 將 Transaction 中的變更正式提交。

---

## ROLLBACK

取消目前 Transaction：

```sql
ROLLBACK;
```

代表：

> 放棄目前 Transaction 中尚未提交的變更。

---

## Transaction 範例

```sql
BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;
```

分類：

```text
BEGIN
→ TCL

UPDATE
→ DML

UPDATE
→ DML

COMMIT
→ TCL
```

一段 SQL Script 可以包含不同種類的 SQL Statement。

---

# 5. DCL

DCL：

```text
Data Control Language
```

用途：

> 控制 Database Permission。

主要指令：

```text
GRANT
REVOKE
```

---

## GRANT

給予權限：

```sql
GRANT SELECT
ON products
TO report_user;
```

概念：

```text
report_user
↓
取得 SELECT 權限
↓
products
```

---

## REVOKE

移除權限：

```sql
REVOKE SELECT
ON products
FROM report_user;
```

概念：

```text
report_user
↓
失去 SELECT 權限
↓
products
```

---

# 一個完整情境

## 建立 Table

```sql
CREATE TABLE products (
    product_id integer,
    name text,
    price numeric
);
```

分類：

```text
DDL
```

---

## 新增資料

```sql
INSERT INTO products (
    product_id,
    name,
    price
)
VALUES (
    1,
    'Keyboard',
    1500
);
```

分類：

```text
DML
```

---

## 查詢資料

```sql
SELECT *
FROM products;
```

分類：

```text
DQL
```

---

## 修改資料並使用 Transaction

```sql
BEGIN;

UPDATE products
SET price = 1800
WHERE product_id = 1;

COMMIT;
```

分類：

```text
BEGIN
→ TCL

UPDATE
→ DML

COMMIT
→ TCL
```

---

## 給予查詢權限

```sql
GRANT SELECT
ON products
TO report_user;
```

分類：

```text
DCL
```

---

# 快速判斷

```text
SELECT
↓
DQL
↓
查資料
```

```text
INSERT
UPDATE
DELETE
↓
DML
↓
改資料
```

```text
CREATE
ALTER
DROP
↓
DDL
↓
改 Structure
```

```text
BEGIN
COMMIT
ROLLBACK
↓
TCL
↓
控制 Transaction
```

```text
GRANT
REVOKE
↓
DCL
↓
控制 Permission
```

---

# 不需要把所有 PostgreSQL 指令硬分類

PostgreSQL 還有：

```sql
SHOW search_path;
```

以及：

```sql
SET search_path TO public;
```

這類指令。

學習時不需要為了分類而硬把所有 PostgreSQL Statement 塞入：

```text
DQL
DML
DDL
TCL
DCL
```

這五類主要用途是建立基本 SQL 心智模型。

實務上更重要的是理解：

> 這條 SQL 實際會做什麼？

---

# 最重要的差異

## 查資料 vs 改資料

```text
SELECT
→ 查資料

INSERT
UPDATE
DELETE
→ 改資料
```

---

## 改資料 vs 改結構

```text
UPDATE products ...
→ 修改 Row Data

ALTER TABLE products ...
→ 修改 Table Structure
```

---

## Transaction Control

```text
BEGIN
COMMIT
ROLLBACK
```

本身不代表業務資料操作。

它們用來控制：

```text
一組 SQL 操作
是否提交或回復
```

---

## Permission Control

```text
GRANT
REVOKE
```

主要處理：

```text
Role
↓
可以對 Database Object
做什麼操作
```

---

# 最終記憶版

```text
SELECT
→ DQL
→ 查資料

INSERT / UPDATE / DELETE
→ DML
→ 改資料

CREATE / ALTER / DROP
→ DDL
→ 改結構

BEGIN / COMMIT / ROLLBACK
→ TCL
→ 控制 Transaction

GRANT / REVOKE
→ DCL
→ 控制 Permission
```

不需要優先死背：

```text
Data Query Language
Data Manipulation Language
Data Definition Language
Transaction Control Language
Data Control Language
```

先做到看到 SQL Statement 時，可以立即判斷它的用途即可。