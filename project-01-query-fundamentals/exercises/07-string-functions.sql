/*
===============================================================================
Project 01：單表查詢實驗室
Step 07：字串函式（String Functions）
File：exercises/07-string-functions.sql
Database：Chinook（PostgreSQL 16，snake_case Schema）
===============================================================================

學習目標：

1. 使用 UPPER()、LOWER() 轉換字母大小寫。
2. 使用 TRIM() 去除字串前後的指定字元。
3. 使用 LENGTH() 計算字元數，區分字元數與位元組數。
4. 使用 SUBSTRING() 擷取字串的一部分。
5. 使用 REPLACE() 取代指定文字。
6. 使用 CONCAT() 與 || 串接字串，觀察 NULL 差異。
7. 綜合使用 WHERE、ORDER BY、CASE、COALESCE、NULLIF 等已學語法。
8. 認識 PostgreSQL 常見補充函式：CONCAT_WS、POSITION、SPLIT_PART。

資料表：customer、track、artist（每一個查詢都只使用一張資料表）。

本階段不使用：JOIN、GROUP BY、HAVING、Subquery、CTE、UPDATE。

提醒：
- 以下 SELECT 都只是產生查詢結果，不會修改 Chinook 的資料。
- 字串常值使用單引號 '...'，例如 'Taiwan'。
- PostgreSQL 的小寫 snake_case 識別字不需要加雙引號。
- 逐段選取查詢並執行，觀察結果；不需要一次執行所有 SELECT。
===============================================================================
*/


/*
===============================================================================
01. UPPER()：轉成大寫
===============================================================================

語法：UPPER(text)
用途：將可轉換的字母改成大寫，原本的 Column 不會受到影響。
大小寫轉換的具體結果可能受到資料庫的語系（locale / collation）影響。
===============================================================================
*/
SELECT
    customer_id,
    first_name,
    UPPER(first_name) AS upper_first_name
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
02. LOWER()：轉成小寫
===============================================================================

語法：LOWER(text)
用途：將可轉換的字母改成小寫。

例如：
    'HeLLo' → 'hello'

也可以運用在 email 顯示，但「顯示成小寫」不等於有修改資料庫中的 email。
===============================================================================
*/
SELECT
    customer_id,
    email,
    LOWER(email) AS lower_email
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
03. LOWER() + WHERE：不區分常見英文字母大小寫的搜尋方式
===============================================================================

當使用者輸入的搜尋關鍵字大小寫不固定時，可以先把兩側轉成小寫。
這裡只搜尋「名稱包含 love」的歌曲：

    LOWER(name)       → 將被查詢字串轉成小寫
    LIKE '%love%'     → 尋找其中包含 love 的字串

注意：
- 這不是所有語言下都完美的 Unicode 不區分大小寫比較。
- 對 Column 套用函式，可能影響一般索引的使用；效能留待 Project 7。
- PostgreSQL 另外提供 ILIKE（方言補充），下方也會示範。
===============================================================================
*/
SELECT
    track_id,
    name
FROM track
WHERE LOWER(name) LIKE '%love%'
ORDER BY track_id ASC
LIMIT 20;


/*
===============================================================================
04. PostgreSQL 補充：ILIKE
===============================================================================

LIKE 依資料庫排序與比對規則進行模式比對；在常見設定下具有大小寫差異。
ILIKE 是 PostgreSQL 提供的不區分大小寫模式比對語法（非通用標準 SQL）。

若只需 PostgreSQL 的英文名稱模糊搜尋，ILIKE 通常更容易閱讀。
===============================================================================
*/
SELECT
    track_id,
    name
FROM track
WHERE name ILIKE '%love%'
ORDER BY track_id ASC
LIMIT 20;


/*
===============================================================================
05. TRIM()：移除字串開頭與結尾的指定字元
===============================================================================

語法：TRIM([LEADING | TRAILING | BOTH] [characters FROM] string)

最常見的是去除前後的空格：
    TRIM('  Hello  ') → 'Hello'

BOTH     ：兩端（預設）
LEADING  ：只處理左端
TRAILING ：只處理右端

注意：
- TRIM() 不會刪掉字串「中間」的空格。
- PostgreSQL 預設去除的一般是空白字元 ' '，不是保證清掉所有空白類型。
===============================================================================
*/
SELECT
    '[' || '  PostgreSQL  ' || ']' AS original_text,
    '[' || TRIM('  PostgreSQL  ') || ']' AS trimmed_text,
    '[' || TRIM(LEADING FROM '  PostgreSQL  ') || ']' AS left_trimmed,
    '[' || TRIM(TRAILING FROM '  PostgreSQL  ') || ']' AS right_trimmed;


/*
===============================================================================
06. TRIM()：指定要從兩端移除的字元
===============================================================================

語法：TRIM(BOTH 'x' FROM string)

這裡的 'x' 指「從兩端反覆去除 x」，而不是刪除字串中間所有 x。
例如 'xxxSQLxxx' 會得到 'SQL'。
===============================================================================
*/
SELECT
    TRIM(BOTH 'x' FROM 'xxxSQLxxx') AS remove_x,
    TRIM(BOTH ' ' FROM '  SQL Practice  ') AS remove_spaces,
    TRIM('  SQL Practice  ') AS default_trim;


/*
===============================================================================
07. LENGTH()：字串長度（字元數）
===============================================================================

語法：LENGTH(text)

例如：
    LENGTH('ABC') → 3

LENGTH() 在一般文字欄位中計算字元數，不是檔案大小或 UTF-8 位元組數。
空字串的長度是 0；NULL 的 LENGTH() 結果是 NULL。
===============================================================================
*/
SELECT
    customer_id,
    first_name,
    LENGTH(first_name) AS first_name_length
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
08. LENGTH() 與 OCTET_LENGTH()：字元數 vs 位元組數
===============================================================================

PostgreSQL 也提供 OCTET_LENGTH() 計算文字佔用的位元組數。

在 UTF-8 編碼下：
    LENGTH('中文')       → 2 個字元
    OCTET_LENGTH('中文') → 6 個位元組

資料庫若不是 UTF-8，位元組數可能不同。
不要把 LENGTH() 當成檔案、網路封包、或欄位儲存空間的精確成本。
===============================================================================
*/
SELECT
    LENGTH('中文') AS character_count,
    OCTET_LENGTH('中文') AS byte_count,
    LENGTH('') AS empty_string_length,
    LENGTH(NULL::text) AS null_string_length;


/*
===============================================================================
09. SUBSTRING()：擷取部分字串
===============================================================================

SQL 標準形式：SUBSTRING(string FROM start FOR length)

- start 從 1 開始，不是 JavaScript 常見的 0-based index。
- FOR length 表示擷取幾個字元。

例如：
    SUBSTRING('PostgreSQL' FROM 1 FOR 4) → 'Post'
    SUBSTRING('PostgreSQL' FROM 5 FOR 3) → 'gre'

不寫 FOR 時，會從指定位置一直擷取到字串結尾。
===============================================================================
*/
SELECT
    SUBSTRING('PostgreSQL' FROM 1 FOR 4) AS first_four,
    SUBSTRING('PostgreSQL' FROM 5 FOR 3) AS middle_three,
    SUBSTRING('PostgreSQL' FROM 5) AS from_fifth;


/*
===============================================================================
10. SUBSTRING()：擷取顧客名稱前幾個字元
===============================================================================

顯示 Customer 的原始 first_name 與前三個字元。
姓名不足三個字元時，不會因此報錯；只會回傳可擷取的部分。
===============================================================================
*/
SELECT
    customer_id,
    first_name,
    SUBSTRING(first_name FROM 1 FOR 3) AS first_three_chars
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
11. REPLACE()：取代指定文字
===============================================================================

語法：REPLACE(source, search, replacement)

- source      ：原始字串
- search      ：要尋找的文字
- replacement ：替換成的文字

REPLACE() 會替換符合的所有出現位置，並回傳新字串。
通常依大小寫區分，例如 'Love' 與 'love' 不一定相同。

注意：下例只是顯示字串轉換，不是 UPDATE，也不是安全的隱私資料遮罩。
===============================================================================
*/
SELECT
    'Love, Love, Love' AS original_text,
    REPLACE('Love, Love, Love', 'Love', 'LOVE') AS replaced_text;

SELECT
    customer_id,
    email,
    REPLACE(email, '@', ' [at] ') AS display_email
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
12. CONCAT()：串接多段文字
===============================================================================

語法：CONCAT(value1, value2, ...)

例如：
    CONCAT('SQL', ' ', 'Lab') → 'SQL Lab'

最實際的用途之一是：組合 first_name + 空格 + last_name。
這裡的空格 ' ' 本身是一個字串常值，不是 SQL 識別字。

PostgreSQL 的 CONCAT() 會忽略 NULL 參數（跨 DBMS 行為可能不同）。
===============================================================================
*/
SELECT
    customer_id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
13. 字串串接運算子 ||
===============================================================================

SQL 也提供 || 串接兩段文字：
    'SQL' || ' Lab' → 'SQL Lab'

與 PostgreSQL 的 CONCAT() 不同：
    CONCAT('Hello', NULL) → 'Hello'
    'Hello' || NULL      → NULL

NULL 不是空字串！如果需要替代值，可配合 COALESCE()。
===============================================================================
*/
SELECT
    CONCAT('Hello', NULL) AS concat_result,
    'Hello' || NULL::text AS operator_result,
    'Hello' || COALESCE(NULL::text, '') AS safe_operator_result;


/*
===============================================================================
14. PostgreSQL 補充：CONCAT_WS()（With Separator）
===============================================================================

語法：CONCAT_WS(separator, value1, value2, ...)

- 第一個參數是欄位之間要插入的分隔符號。
- 其餘 NULL 參數會被略過，不會替 NULL 多加分隔符號。
- 空字串 '' 並不等於 NULL，因此不會自動被忽略。

例如：
    CONCAT_WS(' / ', 'Rock', NULL, 'Live') → 'Rock / Live'

這對選填欄位非常方便，例如 company 可能為 NULL。
===============================================================================
*/
SELECT
    customer_id,
    first_name,
    last_name,
    company,
    CONCAT_WS(' / ', first_name, last_name, company) AS customer_label
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
15. POSITION()：找字串第一次出現的位置
===============================================================================

語法：POSITION(search IN source)

從 1 開始計算位置；找不到時會回傳 0。
例如：
    POSITION('@' IN 'user@example.com') → 5

注意：此範例只是找字元位置，不代表 email 的格式驗證。
===============================================================================
*/
SELECT
    customer_id,
    email,
    POSITION('@' IN email) AS at_position
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
16. PostgreSQL 補充：SPLIT_PART()：按分隔符取其中一段
===============================================================================

語法：SPLIT_PART(source, delimiter, field_number)

例如：
    SPLIT_PART('user@example.com', '@', 1) → 'user'
    SPLIT_PART('user@example.com', '@', 2) → 'example.com'

field_number 通常從 1 開始，不是 0。
這是 PostgreSQL 常見函式，跨資料庫不能假設名稱／行為都相同。

這個做法適合練習字串分割，不是完整的 email 正規化或驗證。
===============================================================================
*/
SELECT
    customer_id,
    email,
    SPLIT_PART(email, '@', 1) AS email_local_part,
    SPLIT_PART(email, '@', 2) AS email_domain
FROM customer
ORDER BY customer_id ASC
LIMIT 10;


/*
===============================================================================
17. 綜合：TRIM() + NULLIF() + COALESCE()
===============================================================================

延續 Step 05、Step 06 的 NULL 知識。

要求：
    company 有值 → 顯示 company
    company 是 NULL 或全是空格 → 顯示 'Individual Customer'

步驟：
    TRIM(company)                → 去除前後空格
    NULLIF(TRIM(company), '')   → 若結果是空字串，轉成 NULL
    COALESCE(..., 'Individual Customer') → NULL 時提供備援文字

與單純 COALESCE(company, ...) 不同，這裡還處理空字串／純空格。
不會修改 customer.company 的原始內容。
===============================================================================
*/
SELECT
    customer_id,
    company,
    COALESCE(
        NULLIF(TRIM(company), ''),
        'Individual Customer'
    ) AS company_display
FROM customer
ORDER BY customer_id ASC
LIMIT 20;


/*
===============================================================================
18. 綜合：字串函式 + CASE + WHERE + ORDER BY + LIMIT
===============================================================================

需求：
1. 只找歌曲名稱包含 'love' 的 Track（搜尋時忽略常見英文字母大小寫）。
2. 顯示 track_id、原始 name 與全部轉成大寫的名稱。
3. 計算歌曲名稱的字元數。
4. 根據 composer 是否為 NULL 顯示 Composer 狀態。
5. 先依名稱長度降冪排序，再用 track_id 作為穩定的次排序鍵。
6. 最多回傳 20 列。

重點：一個 SELECT 可以同時有多個不同的字串函式及表達式。
===============================================================================
*/
SELECT
    track_id,
    name,
    UPPER(name) AS upper_name,
    LENGTH(name) AS name_length,
    CASE
        WHEN composer IS NULL THEN 'Missing'
        ELSE 'Available'
    END AS composer_status
FROM track
WHERE LOWER(name) LIKE '%love%'
ORDER BY
    name_length DESC,
    track_id ASC
LIMIT 20;


/*
===============================================================================
19. 容易混淆的情況與注意事項
===============================================================================

A. SQL 中的單引號是字串；雙引號是識別字。
       'Taiwan' → 字串
       "Taiwan" → 名稱叫 Taiwan 的欄位或其他 identifier

B. SUBSTRING 的第一個字元位置是 1，不是 0。

C. TRIM() 只處理開頭／結尾，不會移除中間空格。

D. LENGTH() 計算字元數；OCTET_LENGTH() 計算位元組數。

E. CONCAT()、|| 對 NULL 的處理可能不同。

F. REPLACE() 產生新字串，不會 UPDATE 原始資料表。

G. 跨資料庫時，優先認識通用概念；ILIKE、SPLIT_PART 等要標註方言。

H. 如果要處理真正複雜的格式檢查／清理，不能假設幾個字串函式
   就能完整驗證 email、電話或使用者輸入。

I. 若 SQL 由 Node.js / .NET 程式送出，使用者輸入應使用參數化查詢，
   不應直接拼接到 SQL 指令字串中。
===============================================================================
*/


/*
===============================================================================
Exercises：獨立練習（這裡不放參考答案）
===============================================================================

請把自己的 SQL 寫在每題註解下方。
本階段維持單表查詢，不使用 JOIN／Subquery／CTE。
===============================================================================
*/

/*
Exercise 01：UPPER()

從 customer 取：customer_id、first_name。
新增 upper_first_name，內容為 first_name 全大寫。
按照 customer_id ASC，最多回傳 10 筆。
*/


/*
Exercise 02：LOWER()

從 customer 取：customer_id、email。
新增 lower_email，內容為 email 全小寫。
按照 customer_id ASC，最多回傳 10 筆。
*/


/*
Exercise 03：TRIM()

不需要 FROM。
對字串 '   Hello SQL   ' 去除前後空格。
Alias：clean_text。
*/


/*
Exercise 04：LENGTH()

從 track 顯示：track_id、name、name_length。
name_length 是 name 的字元數。
按照 name_length DESC、track_id ASC 排序，最多回傳 10 筆。
*/


/*
Exercise 05：SUBSTRING()

從 customer 顯示：customer_id、first_name、initial_two_chars。
initial_two_chars 取 first_name 最前面 2 個字元。
按照 customer_id ASC，最多回傳 10 筆。
*/


/*
Exercise 06：REPLACE()

從 customer 顯示：customer_id、email、display_email。
display_email 把 email 中的 '@' 換成 ' [at] '。
按照 customer_id ASC，最多回傳 10 筆。
注意：這只用來練文字替換，不等於安全的個資遮罩。
*/


/*
Exercise 07：CONCAT()

從 customer 顯示：customer_id、first_name、last_name、full_name。
full_name 由 first_name、空格、last_name 串接而成。
按照 customer_id ASC，最多回傳 10 筆。
*/


/*
Exercise 08：NULL + 字串串接

不需要 FROM。
同時顯示：
    CONCAT('SQL', NULL) AS concat_result
    'SQL' || NULL::text AS operator_result

解釋為什麼結果不同。
*/


/*
Exercise 09：SPLIT_PART()（PostgreSQL 補充）

從 customer 取得：customer_id、email、email_domain。
email_domain 擷取 email 中 '@' 後面的部分。
按照 customer_id ASC，最多回傳 10 筆。
*/


/*
Exercise 10：TRIM() + NULLIF() + COALESCE()

從 customer 取得：customer_id、company、company_display。

規則：
- company 非 NULL、也不全是空格：顯示去除前後空格後的值。
- company 是 NULL、空字串、或純空格：顯示 'Individual Customer'。

按照 customer_id ASC，最多回傳 20 筆。
*/


/*
Exercise 11：綜合搜尋

從 track 找出 name 包含 'love' 的歌曲（忽略常見英文字母大小寫）。
顯示：track_id、name、upper_name、name_length。
按照 name_length DESC、track_id ASC 排序，最多回傳 15 筆。
*/


/*
Exercise 12：觀念檢查（請自行用 SQL 註解回答）

1. LENGTH('中文') 和 OCTET_LENGTH('中文') 在 UTF-8 為什麼不同？
2. SUBSTRING() 的第一個字元位置是 0 還是 1？
3. TRIM(' a b ') 會不會刪除 a 與 b 中間的空格？
4. CONCAT('A', NULL) 與 'A' || NULL 有什麼差別？
5. 為什麼 SELECT REPLACE(...) 不會修改原始資料？
===============================================================================
*/
