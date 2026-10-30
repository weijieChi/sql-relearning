/*
===============================================================================
Project 01：單表查詢實驗室
Step：DISTINCT 與重複資料
File：04-distinct.sql
===============================================================================

本階段目標：

1. 理解資料表中「重複的值」是什麼。
2. 理解 DISTINCT 的用途。
3. 使用 DISTINCT 移除查詢結果中的重複資料。
4. 理解 DISTINCT 不會修改原始 Table。
5. 理解 DISTINCT 套用多個欄位時，是對「欄位組合」去重。
6. 搭配 ORDER BY 排列 DISTINCT 結果。
7. 初步使用 COUNT(DISTINCT column) 計算不同值的數量。
8. 理解 DISTINCT 與 NULL 的基本關係。

主要使用資料表：

    customer
    invoice
    track

目前仍然不使用：

    JOIN
    GROUP BY
    HAVING
    Subquery
    CTE

===============================================================================
*/


/*
===============================================================================
01. 為什麼需要 DISTINCT？
===============================================================================

先看 customer Table 的 country。

Chinook 中有多位 Customer 可能來自同一個國家。

因此：

    SELECT country
    FROM customer;

可能會看到：

    Brazil
    Brazil
    Canada
    Canada
    USA
    USA
    USA
    ...

這些不是「資料錯誤」。

因為每一列代表不同的 Customer，
只是不同 Customer 的 country 剛好相同。

先直接查詢：
===============================================================================
*/

SELECT
    country
FROM customer;


/*
===============================================================================
02. DISTINCT：去除重複結果
===============================================================================

如果我們現在的問題是：

    「Chinook Customer 總共來自哪些國家？」

我們其實不需要每個 Customer 都顯示一次。

這時可以使用：

    DISTINCT

語法：

    SELECT DISTINCT column
    FROM table;

DISTINCT 會把查詢結果中相同的值合併成一筆。
===============================================================================
*/

SELECT DISTINCT
    country
FROM customer;


/*
===============================================================================
03. DISTINCT 不會刪除資料
===============================================================================

這點非常重要。

下面：

    SELECT DISTINCT country
    FROM customer;

只是：

    改變 Query Result

並沒有：

    DELETE Customer
    UPDATE Customer
    ALTER TABLE

原本 customer Table 的資料完全不會改變。

可以理解成：

customer Table
    ↓
SELECT country
    ↓
產生 Query Result
    ↓
DISTINCT
    ↓
從 Query Result 中移除重複值

原始 Table 不受影響。
===============================================================================
*/


/*
===============================================================================
04. DISTINCT + ORDER BY
===============================================================================

DISTINCT 只負責：

    去除重複

它不負責：

    排序

如果希望國家名稱按照字母順序排列：

    ORDER BY country ASC
===============================================================================
*/

SELECT DISTINCT
    country
FROM customer
ORDER BY country ASC;


/*
也可以反向排序：
*/

SELECT DISTINCT
    country
FROM customer
ORDER BY country DESC;


/*
===============================================================================
05. DISTINCT 作用在 SELECT 的整個欄位組合
===============================================================================

這是 DISTINCT 最重要的觀念之一。

假設寫：

    SELECT DISTINCT
        country,
        city
    FROM customer;

DISTINCT 並不是：

    country 各自去重
    +
    city 各自去重

而是：

    對 (country, city) 這個組合去重。

例如原始結果假設是：

    USA     New York
    USA     Boston
    USA     New York
    Canada  Toronto
    Canada  Toronto

DISTINCT 後：

    USA     New York
    USA     Boston
    Canada  Toronto

因為：

    USA + New York

這個「欄位組合」重複了。
===============================================================================
*/

SELECT DISTINCT
    country,
    city
FROM customer
ORDER BY
    country ASC,
    city ASC;


/*
===============================================================================
06. 為什麼多欄位 DISTINCT 很容易誤會？
===============================================================================

例如：

    SELECT DISTINCT
        country,
        first_name
    FROM customer;

只要下面兩個欄位的組合不同：

    country
    first_name

就會被視為不同 Row。

假設：

    Brazil | Luís
    Brazil | Eduardo

雖然：

    country

一樣，

但：

    first_name

不同。

所以這仍然是兩個不同的 DISTINCT 結果。
===============================================================================
*/

SELECT DISTINCT
    country,
    first_name
FROM customer
ORDER BY
    country ASC,
    first_name ASC;


/*
===============================================================================
07. 加入唯一欄位後，DISTINCT 通常失去意義
===============================================================================

customer_id 是 Primary Key。

也就是：

    每個 Customer 的 customer_id 都不同。

如果寫：

    SELECT DISTINCT
        customer_id,
        country
    FROM customer;

因為 customer_id 每一列本來就唯一，

所以整個：

    (customer_id, country)

組合自然也幾乎一定唯一。

這時 DISTINCT 基本上沒有去除重複資料的效果。
===============================================================================
*/

SELECT DISTINCT
    customer_id,
    country
FROM customer;


/*
這也是一個很重要的思考方式：

使用 DISTINCT 前應該先問：

    「我到底想對哪些欄位組合去重？」

而不是看到重複資料就習慣性加：

    DISTINCT
*/


/*
===============================================================================
08. 使用 invoice.billing_country 練習
===============================================================================

invoice Table 中：

    billing_country

表示 Invoice 的帳單國家。

同一個國家可能出現很多張 Invoice，
所以 billing_country 會大量重複。

先看原始資料：
===============================================================================
*/

SELECT
    billing_country
FROM invoice;


/*
查看有哪些不同的 Billing Country：
*/

SELECT DISTINCT
    billing_country
FROM invoice
ORDER BY billing_country ASC;


/*
===============================================================================
09. 使用 track.composer 練習
===============================================================================

track Table 的 composer：

    表示歌曲的作曲者資訊。

不同歌曲可能擁有相同 Composer，
因此 composer 也可能重複。
===============================================================================
*/

SELECT
    composer
FROM track;


/*
只查看不同 Composer：
*/

SELECT DISTINCT
    composer
FROM track
ORDER BY composer ASC;


/*
===============================================================================
10. DISTINCT 與 NULL
===============================================================================

composer 可能是 NULL。

當 DISTINCT 處理結果時：

    多個 NULL

在 DISTINCT 的結果中通常只會保留一個 NULL。

也就是：

原始結果：

    AC/DC
    AC/DC
    NULL
    NULL
    NULL
    Queen

DISTINCT：

    AC/DC
    NULL
    Queen

注意：

這不代表：

    NULL = NULL

突然變成 TRUE。

前面 NULL Step 已經學過：

    NULL = NULL
        → UNKNOWN

DISTINCT 的「判斷重複」有自己的 SQL 語意，
不要把它理解成普通的：

    =

比較。
===============================================================================
*/

SELECT DISTINCT
    composer
FROM track
ORDER BY composer ASC NULLS LAST;


/*
===============================================================================
11. WHERE + DISTINCT
===============================================================================

DISTINCT 可以和前面學過的 WHERE 一起使用。

需求：

    找出來自 USA 或 Canada 的 Customer，
    然後只顯示有哪些不同的 country。

執行概念：

FROM customer
    ↓
WHERE
只留下 USA / Canada
    ↓
SELECT country
    ↓
DISTINCT
移除重複 country
===============================================================================
*/

SELECT DISTINCT
    country
FROM customer
WHERE country IN (
    'USA',
    'Canada'
)
ORDER BY country ASC;


/*
===============================================================================
12. DISTINCT + 多欄位 + WHERE
===============================================================================

需求：

找出 USA Customer 中：

    country
    city

有哪些不同組合。

因為 country 已經固定是 USA，

所以實際上主要是在觀察：

    USA 有哪些不同 city。
===============================================================================
*/

SELECT DISTINCT
    country,
    city
FROM customer
WHERE country = 'USA'
ORDER BY
    country ASC,
    city ASC;


/*
===============================================================================
13. COUNT()
===============================================================================

COUNT() 是 Aggregate Function。

完整的 Aggregate Function 會在後面的 Project 正式學習。

這裡先只使用最簡單的：

    COUNT(*)

用途：

    計算 Query 中有多少 Rows。

例如：
===============================================================================
*/

SELECT
    COUNT(*)
FROM customer;


/*
意思：

    customer Table 一共有多少筆資料。

目前不需要深入：

    GROUP BY
    HAVING

只需要知道 COUNT 可以計算 Row 數量。
*/


/*
===============================================================================
14. COUNT(column)
===============================================================================

COUNT(column) 和 COUNT(*) 有一個很重要的差異：

    COUNT(*)
        → 計算所有 Rows。

    COUNT(column)
        → 只計算 column 不為 NULL 的 Rows。

例如：

    company

有些 Customer 沒有 company。
===============================================================================
*/

SELECT
    COUNT(*) AS total_customers,
    COUNT(company) AS customers_with_company
FROM customer;


/*
因此：

    total_customers

通常會 >=：

    customers_with_company

因為：

    COUNT(company)

不會把 company IS NULL 的 Row 算進去。
*/


/*
===============================================================================
15. COUNT(DISTINCT column)
===============================================================================

COUNT(DISTINCT column)：

    計算「不同值」有多少個。

例如：

    Customer 一共有多少個不同國家？

可以寫：

    COUNT(DISTINCT country)
===============================================================================
*/

SELECT
    COUNT(DISTINCT country) AS country_count
FROM customer;


/*
概念上：

SELECT DISTINCT country
FROM customer;

先得到：

    不同 country

再問：

    有幾個？

COUNT(DISTINCT country)

可以直接完成這件事。
*/


/*
===============================================================================
16. 比較 COUNT(*) 與 COUNT(DISTINCT ...)
===============================================================================

下面同時查看：

    Customer 總數

以及：

    不同 Country 數量
===============================================================================
*/

SELECT
    COUNT(*) AS customer_count,
    COUNT(DISTINCT country) AS country_count
FROM customer;


/*
例如：

customer_count
可能有很多筆。

country_count
通常比較少。

因為：

很多 Customer 來自相同國家。
*/


/*
===============================================================================
17. COUNT(DISTINCT column) 與 NULL
===============================================================================

COUNT() 有一個重要規則：

    COUNT(column)

通常不計算 NULL。

因此：

    COUNT(DISTINCT composer)

除了：

    去除重複 Composer

以外，

也不會把 NULL 當作一個 Composer 數值計算。
===============================================================================
*/

SELECT
    COUNT(DISTINCT composer) AS composer_count
FROM track;


/*
這和：

    SELECT DISTINCT composer

有一點差異。

SELECT DISTINCT composer
可能會在結果中看到一個 NULL。

但：

COUNT(DISTINCT composer)

不會把 NULL 算進數量。

這點要特別注意。
*/


/*
===============================================================================
18. DISTINCT 不是用來「修理錯誤 JOIN」的
===============================================================================

目前還沒有學 JOIN，

但先建立一個很重要的習慣：

    不要只要看到重複 Row，
    就直接加 DISTINCT。

未來 JOIN 後出現重複資料，
可能原因是：

    關聯條件錯誤
    一對多關係
    Join Key 不正確

如果直接加：

    DISTINCT

可能只是：

    把問題藏起來。

所以正確流程應該是：

1. 先理解為什麼重複。
2. 確定需求真的需要去重。
3. 才使用 DISTINCT。

===============================================================================
*/


/*
===============================================================================
19. DISTINCT 與 ORDER BY 的邏輯概念
===============================================================================

目前 Project 1 已經學到的邏輯處理順序：

    FROM
    WHERE
    SELECT
    DISTINCT
    ORDER BY
    LIMIT

例如：
===============================================================================
*/

SELECT DISTINCT
    country
FROM customer
WHERE country IS NOT NULL
ORDER BY country ASC
LIMIT 10;


/*
概念：

FROM customer
    ↓
WHERE country IS NOT NULL
    ↓
SELECT country
    ↓
DISTINCT
    ↓
ORDER BY country ASC
    ↓
LIMIT 10
*/


/*
===============================================================================
Exercises
===============================================================================
*/


/*
-------------------------------------------------------------------------------
Exercise 01

題目：

列出 Customer 所有不同的 country。

顯示：

- country

要求：

1. 使用 DISTINCT。
2. country ASC 排序。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 02

題目：

列出 Customer 所有不同的：

- country
- city

組合。

要求：

1. 使用 DISTINCT。
2. 先按照 country ASC。
3. 再按照 city ASC。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 03

題目：

列出 Invoice 中所有不同的 billing_country。

要求：

1. 使用 DISTINCT。
2. billing_country ASC 排序。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 04

題目：

列出 Track 中所有不同的 composer。

顯示：

- composer

要求：

1. 使用 DISTINCT。
2. composer ASC。
3. NULL 放最後。

提示：

PostgreSQL 可以使用：

    NULLS LAST
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 05

題目：

只找：

    USA
    Canada
    Brazil

這三個國家的 Customer。

最後只顯示：

    不同 country

要求：

1. WHERE 使用 IN。
2. 使用 DISTINCT。
3. country ASC。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 06

題目：

找出 USA 的 Customer。

列出不同的：

- country
- city

組合。

要求：

1. WHERE country = 'USA'
2. DISTINCT
3. country ASC
4. city ASC
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 07

題目：

計算 Customer Table：

總共有多少位 Customer？

結果 Alias：

    customer_count

提示：

使用：

    COUNT(*)

這一題不用 DISTINCT。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 08

題目：

計算 Customer 總共有多少個不同的 country。

結果 Alias：

    country_count

要求：

使用：

    COUNT(DISTINCT ...)
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 09

題目：

同一個 Query 顯示：

1. Customer 總數
2. 不同 Country 數量

Alias：

    customer_count
    country_count
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 10

題目：

計算 Track 中有多少個不同的 Composer。

結果 Alias：

    composer_count

要求：

使用：

    COUNT(DISTINCT composer)

思考：

composer 為 NULL 的資料會不會被計算？
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 11

實驗題：

分別執行：

A.

    SELECT composer
    FROM track;

B.

    SELECT DISTINCT composer
    FROM track;

觀察：

1. A 為什麼會出現大量重複 Composer？
2. B 做了什麼？
3. B 是否修改了 track Table？
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 12

實驗題：

比較：

A.

    SELECT DISTINCT country
    FROM customer;

B.

    SELECT DISTINCT
        customer_id,
        country
    FROM customer;

思考：

為什麼 B 幾乎無法利用 DISTINCT 去除 Rows？

提示：

思考 customer_id 的特性。
-------------------------------------------------------------------------------
*/