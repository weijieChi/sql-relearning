/*
===============================================================================
Project 01：單表查詢實驗室
Step 06：CASE / COALESCE / NULLIF / CAST
File：06-case-expressions.sql
===============================================================================

本階段目標：

1. 理解 SQL Expression（表達式）的概念。

2. 使用 CASE 根據條件產生不同結果。

3. 理解兩種 CASE：

       Searched CASE
       Simple CASE

4. 使用 COALESCE：

       找出第一個不是 NULL 的值。

5. 使用 NULLIF：

       當兩個值相等時回傳 NULL。

6. 使用 CAST：

       明確進行資料型別轉換。

7. 將 CASE、COALESCE、NULLIF、CAST
   與前面學過的：

       SELECT
       WHERE
       ORDER BY
       NULL

   組合使用。

8. 理解：

       Expression 只改變 Query Result，
       不會修改原始 Table。

主要使用資料表：

    track
    customer
    invoice

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
01. 什麼是 Expression？
===============================================================================

SQL 的 SELECT 不只能取得原始 Column。

例如：

    SELECT name
    FROM track;

也可以放入計算：

    milliseconds / 1000.0

或：

    unit_price * 2

甚至條件判斷：

    CASE ...

這些都可以稱為：

    Expression
    表達式

Expression 會在 Query 執行時產生一個結果。

例如：
===============================================================================
*/

SELECT
    name,
    milliseconds,

    -- 把毫秒轉換成秒。
    milliseconds / 1000.0 AS duration_seconds

FROM track;


/*
注意：

duration_seconds 並不是 track Table 真正存在的欄位。

它只是：

    Query Result

中的一個計算結果。

執行 SELECT 不會修改原始資料。
*/


/*
===============================================================================
02. CASE：條件式表達式
===============================================================================

CASE 很像程式語言裡的：

    if
    else if
    else

例如：

C#：

    if (milliseconds < 180000)
        return "Short";
    else if (milliseconds <= 300000)
        return "Medium";
    else
        return "Long";

SQL 可以使用：

    CASE
        WHEN condition THEN result
        WHEN condition THEN result
        ELSE result
    END

CASE 最後必須：

    END
===============================================================================
*/


/*
===============================================================================
03. Searched CASE
===============================================================================

第一種最常使用的 CASE：

    CASE
        WHEN 條件 THEN 結果
        WHEN 條件 THEN 結果
        ELSE 結果
    END

每一個 WHEN 後面都是完整 Condition。
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds,

    CASE
        WHEN milliseconds < 180000 THEN 'Short'
        WHEN milliseconds <= 300000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category

FROM track;


/*
上面的規則：

    milliseconds < 180000
        → Short

    180000 ～ 300000
        → Medium

    > 300000
        → Long


為什麼第二個 WHEN 不需要再寫：

    milliseconds >= 180000

？

因為 CASE 是：

    從上往下判斷

第一個條件：

    milliseconds < 180000

如果沒有成立，
代表目前已經知道：

    milliseconds >= 180000

所以第二個只需要判斷：

    milliseconds <= 300000
*/


/*
===============================================================================
04. CASE 是「第一個符合的條件就停止」
===============================================================================

CASE 會由上往下判斷。

例如：

    milliseconds = 150000

第一個條件：

    milliseconds < 180000

成立。

因此直接得到：

    Short

後面的：

    WHEN milliseconds <= 300000

就不需要再決定結果。

所以：

    CASE 條件順序很重要。
===============================================================================
*/


/*
下面是一個故意寫得不好的例子：

第一個條件太廣。

    milliseconds <= 300000

會先把：

    < 180000

也一起抓走。
*/

SELECT
    track_id,
    name,
    milliseconds,

    CASE
        WHEN milliseconds <= 300000 THEN 'Medium'
        WHEN milliseconds < 180000 THEN 'Short'
        ELSE 'Long'
    END AS wrong_category

FROM track;


/*
這樣：

    Short

幾乎永遠不可能出現。

因為：

    milliseconds < 180000

本來就一定同時符合：

    milliseconds <= 300000

所以第一個 WHEN 已經先匹配成功。

重要：

    CASE 的 WHEN 順序會影響結果。
*/


/*
===============================================================================
05. CASE + ELSE
===============================================================================

ELSE：

    所有 WHEN 都沒有成立時使用。

例如：
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price,

    CASE
        WHEN unit_price < 1.00 THEN 'Low Price'
        WHEN unit_price < 2.00 THEN 'Normal Price'
        ELSE 'High Price'
    END AS price_category

FROM track;


/*
===============================================================================
06. CASE 可以沒有 ELSE
===============================================================================

SQL 允許 CASE 沒有 ELSE。

例如：
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price,

    CASE
        WHEN unit_price = 0.99 THEN 'Standard'
    END AS price_type

FROM track;


/*
如果：

    unit_price = 0.99

結果：

    Standard

如果條件沒有成立：

    沒有 ELSE

SQL 會回傳：

    NULL

所以：

沒有 ELSE

概念上近似：

    ELSE NULL
*/


/*
===============================================================================
07. 建議學習階段盡量明確寫 ELSE
===============================================================================

例如：
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price,

    CASE
        WHEN unit_price = 0.99 THEN 'Standard'
        ELSE 'Other'
    END AS price_type

FROM track;


/*
這樣 Query 的意圖通常比較清楚。
*/


/*
===============================================================================
08. Simple CASE
===============================================================================

CASE 還有另一種形式：

    CASE expression
        WHEN value THEN result
        WHEN value THEN result
        ELSE result
    END

例如：

    CASE country
        WHEN 'USA' THEN ...
        WHEN 'Canada' THEN ...
        ELSE ...
    END

這種寫法適合：

    同一個 Expression
    與多個固定值比較。
===============================================================================
*/

SELECT
    customer_id,
    first_name,
    last_name,
    country,

    CASE country
        WHEN 'USA' THEN 'North America'
        WHEN 'Canada' THEN 'North America'
        WHEN 'Brazil' THEN 'South America'
        ELSE 'Other'
    END AS region

FROM customer;


/*
概念上相當於：

CASE
    WHEN country = 'USA' THEN ...
    WHEN country = 'Canada' THEN ...
    WHEN country = 'Brazil' THEN ...
    ELSE ...
END
*/


/*
===============================================================================
09. Simple CASE 和 Searched CASE 怎麼選？
===============================================================================

如果需求是：

    country = 'USA'
    country = 'Canada'
    country = 'Brazil'

Simple CASE 很適合：

    CASE country
        WHEN 'USA' ...
        WHEN 'Canada' ...
    END


如果需求是：

    milliseconds < 180000
    milliseconds <= 300000
    unit_price > 1.00

這些是不同 Condition。

就使用：

    CASE
        WHEN condition ...
    END

也就是 Searched CASE。
*/


/*
===============================================================================
10. CASE + ORDER BY
===============================================================================

CASE 的結果可以取 Alias。

例如：

    duration_category

然後：

    ORDER BY duration_category

但是要注意：

字串會按照文字排序規則排列，
不一定符合我們認為的：

    Short
    Medium
    Long

邏輯順序。
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds,

    CASE
        WHEN milliseconds < 180000 THEN 'Short'
        WHEN milliseconds <= 300000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category

FROM track
ORDER BY duration_category ASC;


/*
如果真的需要自訂順序，
可以在 ORDER BY 再使用 CASE。

例如：

    Short  = 1
    Medium = 2
    Long   = 3
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds,

    CASE
        WHEN milliseconds < 180000 THEN 'Short'
        WHEN milliseconds <= 300000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category

FROM track

ORDER BY
    CASE
        WHEN milliseconds < 180000 THEN 1
        WHEN milliseconds <= 300000 THEN 2
        ELSE 3
    END ASC,
    track_id ASC;


/*
===============================================================================
11. CASE + NULL
===============================================================================

CASE 很常搭配 NULL 判斷。

例如：

    composer IS NULL

就顯示：

    No Composer Information
===============================================================================
*/

SELECT
    track_id,
    name,
    composer,

    CASE
        WHEN composer IS NULL THEN 'No Composer Information'
        ELSE composer
    END AS composer_display

FROM track;


/*
這段可以正常工作。

但是這種：

    NULL → 使用預設值

其實有更簡潔的工具：

    COALESCE

接下來學。
*/


/*
===============================================================================
12. COALESCE
===============================================================================

COALESCE：

    由左往右檢查 Expression。

找到第一個：

    不是 NULL

的值就回傳。

語法：

    COALESCE(value1, value2, value3, ...)
===============================================================================
*/


/*
例如：
*/

SELECT
    track_id,
    name,
    composer,

    COALESCE(
        composer,
        'Unknown'
    ) AS composer_display

FROM track;


/*
如果：

    composer = 'AC/DC'

COALESCE：

    第一個值不是 NULL

所以結果：

    AC/DC


如果：

    composer = NULL

就繼續看下一個：

    'Unknown'

所以結果：

    Unknown
*/


/*
===============================================================================
13. COALESCE 可以有很多候選值
===============================================================================

例如 Customer：

    company
    first_name
    email

我們可以要求：

優先顯示：

    company

沒有 company 就：

    first_name

如果 first_name 也沒有，
才：

    email

最後甚至可以提供固定預設值。
===============================================================================
*/

SELECT
    customer_id,
    company,
    first_name,
    email,

    COALESCE(
        company,
        first_name,
        email,
        'Unknown Customer'
    ) AS display_name

FROM customer;


/*
COALESCE 的概念：

company
    ↓ NULL？

不是
→ 回傳 company

是
    ↓
first_name
    ↓ NULL？

不是
→ 回傳 first_name

是
    ↓
email
    ↓
...
*/


/*
===============================================================================
14. COALESCE 不等於修改資料
===============================================================================

例如：

    composer = NULL

執行：

    COALESCE(composer, 'Unknown')

Query Result：

    Unknown

但是 Database 裡：

    composer

依然是：

    NULL

COALESCE 只改變：

    顯示 / Expression Result

不會執行 UPDATE。
*/


/*
===============================================================================
15. COALESCE 和 CASE 的關係
===============================================================================

下面：
*/

SELECT
    name,

    CASE
        WHEN composer IS NULL THEN 'Unknown'
        ELSE composer
    END AS composer_case

FROM track;


/*
很多情況可以簡化成：
*/

SELECT
    name,

    COALESCE(
        composer,
        'Unknown'
    ) AS composer_coalesce

FROM track;


/*
兩者不是完全相同的功能。

CASE：

    可以處理各種 Condition。

COALESCE：

    專門處理：
    找第一個不是 NULL 的 Expression。

因此單純處理 NULL fallback 時：

    COALESCE

通常更簡潔。
*/


/*
===============================================================================
16. COALESCE + customer.company
===============================================================================

如果 Customer 沒有 company：

顯示：

    Individual Customer
===============================================================================
*/

SELECT
    customer_id,
    first_name,
    last_name,
    company,

    COALESCE(
        company,
        'Individual Customer'
    ) AS company_display

FROM customer;


/*
===============================================================================
17. NULLIF
===============================================================================

NULLIF 有兩個參數：

    NULLIF(value1, value2)

規則：

如果：

    value1 = value2

回傳：

    NULL

否則：

    回傳 value1
===============================================================================
*/


/*
最簡單實驗：
*/

SELECT
    NULLIF(10, 10) AS result;


/*
10 = 10

所以：

    result = NULL
*/


SELECT
    NULLIF(10, 20) AS result;


/*
10 <> 20

所以：

    result = 10
*/


/*
===============================================================================
18. NULLIF 常見用途：避免除以 0
===============================================================================

SQL 中：

    value / 0

通常會產生：

    division by zero

錯誤。

例如：

    100 / 0

不可以。

但可以：

    100 / NULLIF(value, 0)

如果 value = 0：

    NULLIF(0, 0)
        → NULL

最後變成：

    100 / NULL
        → NULL

而不是除以 0。
===============================================================================
*/


/*
先直接看 NULLIF：
*/

SELECT
    NULLIF(0, 0) AS denominator;


/*
===============================================================================
19. NULLIF 與 COALESCE 可以一起使用
===============================================================================

假設計算結果可能變成 NULL：

    100 / NULLIF(0, 0)

結果：

    NULL

如果希望最後顯示：

    0

可以：
===============================================================================
*/

SELECT
    COALESCE(
        100.0 / NULLIF(0, 0),
        0
    ) AS result;


/*
流程：

NULLIF(0, 0)
    ↓
NULL

100.0 / NULL
    ↓
NULL

COALESCE(NULL, 0)
    ↓
0
*/


/*
===============================================================================
20. NULLIF 不只是數字
===============================================================================

它也能比較字串。

例如：
===============================================================================
*/

SELECT
    NULLIF(
        'Taiwan',
        'Taiwan'
    ) AS result;


/*
相等：

    → NULL
*/


SELECT
    NULLIF(
        'Taiwan',
        'Japan'
    ) AS result;


/*
不同：

    → Taiwan
*/


/*
===============================================================================
21. CAST：資料型別轉換
===============================================================================

CAST 用來明確進行：

    Data Type Conversion

標準語法：

    CAST(expression AS data_type)

例如：

    CAST(123 AS text)

把數字：

    123

轉換成：

    text
===============================================================================
*/

SELECT
    CAST(
        123 AS text
    ) AS number_as_text;


/*
===============================================================================
22. CAST 文字成整數
===============================================================================
*/

SELECT
    CAST(
        '123' AS integer
    ) AS text_as_number;


/*
注意：

字串必須可以合理轉成指定型別。

例如：

    '123'

可以轉 integer。

但是：

    'Hello'

不能直接轉 integer。

下面如果執行會發生錯誤：

    SELECT CAST('Hello' AS integer);

所以先保留成註解。
*/


-- SELECT CAST('Hello' AS integer);


/*
===============================================================================
23. CAST 不會改變原始 Column Type
===============================================================================

假設：

    milliseconds

原本是 integer。

下面：
*/

SELECT
    name,

    CAST(
        milliseconds AS numeric
    ) AS milliseconds_numeric

FROM track;


/*
只是：

Query 執行期間

把值當成 numeric 使用。

track.milliseconds 的 Schema 型別：

    不會被修改。
*/


/*
===============================================================================
24. CAST + 計算
===============================================================================

例如把 milliseconds 轉成 numeric，
再計算分鐘數：
===============================================================================
*/

SELECT
    track_id,
    name,
    milliseconds,

    CAST(
        milliseconds AS numeric
    ) / 60000 AS duration_minutes

FROM track;


/*
===============================================================================
25. PostgreSQL 的 :: 型別轉換
===============================================================================

PostgreSQL 另外提供：

    expression::type

例如：

    milliseconds::numeric

這是 PostgreSQL 很常見的語法。

下面：
===============================================================================
*/

SELECT
    track_id,
    name,

    milliseconds::numeric / 60000
        AS duration_minutes

FROM track;


/*
但是：

    ::

是 PostgreSQL-specific syntax。

如果目標是學習比較通用的 SQL，
Project 1 優先使用：

    CAST(... AS ...)

例如：

    CAST(milliseconds AS numeric)

所以：

    CAST()

是主線。

    ::

只當 PostgreSQL 補充。
*/


/*
===============================================================================
26. CAST + 日期
===============================================================================

invoice_date 是日期時間資料。

可以轉成：

    date

只保留日期部分。
===============================================================================
*/

SELECT
    invoice_id,
    invoice_date,

    CAST(
        invoice_date AS date
    ) AS invoice_date_only

FROM invoice;


/*
例如原本可能：

    2025-01-01 10:30:00

轉成 date 後：

    2025-01-01
*/


/*
===============================================================================
27. CASE + CAST
===============================================================================

不同 Expression 可以組合。

例如：

先把歌曲分類，
同時把分鐘數計算出來。
===============================================================================
*/

SELECT
    track_id,
    name,

    CAST(
        milliseconds AS numeric
    ) / 60000 AS duration_minutes,

    CASE
        WHEN milliseconds < 180000 THEN 'Short'
        WHEN milliseconds <= 300000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category

FROM track;


/*
===============================================================================
28. CASE + COALESCE
===============================================================================

例如：

如果 composer 為 NULL：

    Unknown Composer

否則：

    原本 composer

其實單純 COALESCE 就可以：
===============================================================================
*/

SELECT
    track_id,
    name,

    COALESCE(
        composer,
        'Unknown Composer'
    ) AS composer_display,

    CASE
        WHEN composer IS NULL THEN 'Missing'
        ELSE 'Available'
    END AS composer_status

FROM track;


/*
這裡兩個 Expression 做的事情不同：

composer_display：

    要顯示什麼文字。

composer_status：

    資料是否存在的分類。
*/


/*
===============================================================================
29. CASE + WHERE
===============================================================================

CASE 可以出現在 SELECT。

WHERE 則仍然負責：

    篩選 Row。

例如只找：

    unit_price >= 0.99

再分類價格。
===============================================================================
*/

SELECT
    track_id,
    name,
    unit_price,

    CASE
        WHEN unit_price < 1.00 THEN 'Under 1'
        WHEN unit_price < 2.00 THEN 'Under 2'
        ELSE '2 Or More'
    END AS price_category

FROM track

WHERE unit_price >= 0.99;


/*
===============================================================================
30. CASE + ORDER BY + LIMIT
===============================================================================

現在可以把前面的 Step 全部組起來。

需求：

1. 顯示歌曲。
2. 將時間換算成分鐘。
3. 分成 Short / Medium / Long。
4. 最長的排前面。
5. 只取 20 筆。
===============================================================================
*/

SELECT
    track_id,
    name,

    CAST(
        milliseconds AS numeric
    ) / 60000 AS duration_minutes,

    CASE
        WHEN milliseconds < 180000 THEN 'Short'
        WHEN milliseconds <= 300000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category

FROM track

ORDER BY
    milliseconds DESC,
    track_id ASC

LIMIT 20;


/*
===============================================================================
31. CASE Result 的資料型別
===============================================================================

CASE 每一個：

    THEN
    ELSE

的結果最好是：

    相容的資料型別。

例如：

這是合理的：

    THEN 'Short'
    ELSE 'Long'

都是 text。

這也是合理的：

    THEN 1
    ELSE 2

都是 integer。


但不要隨意混：

    THEN 'Short'
    ELSE 100

因為 Database 必須找出：

    CASE Expression 最終的共同資料型別。

可能產生型別轉換問題甚至錯誤。

所以設計 CASE 時：

    THEN / ELSE

的 Result Type 要有一致性。
*/


/*
===============================================================================
32. COALESCE 的資料型別也要相容
===============================================================================

例如：

    composer

是文字。

下面合理：

    COALESCE(composer, 'Unknown')

因為兩邊都是文字。


但如果寫：

    COALESCE(composer, 0)

就會有：

    text
    integer

型別不相容的問題。

所以：

CASE
COALESCE

都要注意：

    Result Type。
*/


/*
===============================================================================
33. NULLIF 的資料型別
===============================================================================

NULLIF：

    NULLIF(value1, value2)

本質上需要：

    value1
    value2

能夠合理比較。

例如：

    NULLIF(10, 10)

合理。


    NULLIF('ABC', 'ABC')

合理。

但不要隨意比較完全不相容的型別。
*/


/*
===============================================================================
34. 實務上的思考方式
===============================================================================

CASE：

    「根據條件決定結果。」

COALESCE：

    「從左到右找第一個不是 NULL 的值。」

NULLIF：

    「兩個值相同，就把結果變成 NULL。」

CAST：

    「我要明確指定這個 Expression 的資料型別。」

可以簡記：

CASE
    → Condition

COALESCE
    → NULL fallback

NULLIF
    → value → NULL

CAST
    → Type conversion
*/


/*
===============================================================================
35. 本階段與 NULL 的關係
===============================================================================

Step 05 已經學過：

    NULL = NULL
        → UNKNOWN

    IS NULL
        → 正確 NULL 判斷


現在 Step 06：

COALESCE：

    處理 NULL fallback

NULLIF：

    主動產生 NULL

CASE：

    可以使用 IS NULL 做條件

例如：
===============================================================================
*/

SELECT
    track_id,
    name,
    composer,

    CASE
        WHEN composer IS NULL THEN 'Missing'
        ELSE 'Available'
    END AS composer_status,

    COALESCE(
        composer,
        'Unknown'
    ) AS composer_display

FROM track;


/*
===============================================================================
Exercises
===============================================================================
*/


/*
-------------------------------------------------------------------------------
Exercise 01

題目：

將 Track 按播放時間分成：

    Short
        < 180000 milliseconds

    Medium
        180000 ～ 300000 milliseconds

    Long
        > 300000 milliseconds

顯示：

- track_id
- name
- milliseconds
- duration_category

要求：

使用：

    CASE
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 02

題目：

根據 unit_price 分類：

    < 1.00
        → 'Low'

    < 2.00
        → 'Normal'

    其他
        → 'High'

顯示：

- track_id
- name
- unit_price
- price_category

要求：

使用 Searched CASE。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 03

題目：

根據 Customer 的 country：

    USA
        → 'North America'

    Canada
        → 'North America'

    Brazil
        → 'South America'

    其他
        → 'Other'

顯示：

- customer_id
- first_name
- last_name
- country
- region

要求：

使用 Simple CASE：

    CASE country
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 04

題目：

顯示：

- track_id
- name
- composer
- composer_display

如果：

    composer IS NULL

composer_display 顯示：

    'Unknown'

否則顯示：

    原本 composer

要求：

使用：

    COALESCE

不要使用 CASE。
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 05

題目：

Customer 顯示：

- customer_id
- first_name
- company
- display_name

display_name 規則：

第一優先：

    company

如果 company 是 NULL：

    first_name

如果仍然是 NULL：

    email

最後：

    'Unknown Customer'

要求：

使用：

    COALESCE
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 06

實驗題：

分別執行：

    NULLIF(10, 10)

    NULLIF(10, 20)

並觀察：

1. 哪一個結果是 NULL？
2. 哪一個結果是 10？
3. 為什麼？
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 07

題目：

執行：

    100.0 / NULLIF(0, 0)

觀察結果。

然後再使用：

    COALESCE

讓最後 NULL 結果改成：

    0

要求：

同時使用：

    NULLIF
    COALESCE
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 08

題目：

將文字：

    '123'

使用 CAST 轉成：

    integer

Alias：

    number_value
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 09

題目：

將：

    track.milliseconds

CAST 成：

    numeric

再換算成分鐘。

顯示：

- track_id
- name
- milliseconds
- duration_minutes

要求：

使用標準 SQL：

    CAST(... AS numeric)

不要使用 PostgreSQL：

    ::
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 10

題目：

從 invoice 顯示：

- invoice_id
- invoice_date
- invoice_date_only

其中：

    invoice_date_only

必須把：

    invoice_date

CAST 成：

    date
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 11

題目：

顯示 Track：

- track_id
- name
- composer_display
- composer_status

composer_display：

    如果 composer 是 NULL，
    顯示 'Unknown Composer'

composer_status：

    composer IS NULL
        → 'Missing'

    否則
        → 'Available'

要求：

同時使用：

    COALESCE
    CASE
-------------------------------------------------------------------------------
*/




/*
-------------------------------------------------------------------------------
Exercise 12

綜合題：

找出播放時間：

    >= 180000 milliseconds

的 Track。

顯示：

- track_id
- name
- duration_minutes
- duration_category
- composer_display
- unit_price

其中：

duration_minutes：

    CAST(milliseconds AS numeric) / 60000

duration_category：

    < 180000
        → Short

    <= 300000
        → Medium

    其他
        → Long

composer_display：

    composer 是 NULL
        → 'Unknown'

    否則
        → composer

排序：

1. milliseconds DESC
2. track_id ASC

限制：

    LIMIT 20

要求至少使用：

    WHERE
    CASE
    COALESCE
    CAST
    ORDER BY
    LIMIT
-------------------------------------------------------------------------------
*/




/*
===============================================================================
Step 06 Self Check
===============================================================================

完成這個 Step 後，
應該能不看前面範例回答：

1.

CASE 是做什麼的？

    → 根據條件產生不同結果。


2.

CASE WHEN 的順序重要嗎？

    → 重要。

      從上往下判斷，
      第一個符合的 WHEN 決定結果。


3.

COALESCE 做什麼？

    → 從左到右，
      回傳第一個不是 NULL 的 Expression。


4.

NULLIF(A, B) 做什麼？

    → A = B 時回傳 NULL，
      否則回傳 A。


5.

CAST 做什麼？

    → 明確轉換 Expression 的資料型別。


6.

下面會修改 Database 嗎？

    SELECT
        COALESCE(composer, 'Unknown')
    FROM track;

    → 不會。

      只是改變 Query Result。


7.

下面兩個有什麼差異？

    CAST(milliseconds AS numeric)

    milliseconds::numeric

    → 第一個是標準 CAST 語法。

      第二個是 PostgreSQL 常見的
      PostgreSQL-specific cast syntax。


8.

CASE / COALESCE 的結果為什麼要注意型別？

    → 因為 Database 必須推導出整個 Expression
      最終使用的共同資料型別。

===============================================================================
*/


/*
===============================================================================
目前 Project 1 已學習的 Query 組合
===============================================================================

SELECT
    ↓
Column / Expression
    ↓
CASE
COALESCE
NULLIF
CAST

FROM
    ↓
Table

WHERE
    ↓
Row Filtering

DISTINCT
    ↓
Remove Duplicate Result Rows

ORDER BY
    ↓
Result Ordering

LIMIT / OFFSET
    ↓
限制結果 / 基礎分頁


目前尚未正式進入：

    JOIN
    GROUP BY
    HAVING
    Subquery
    CTE

===============================================================================
*/