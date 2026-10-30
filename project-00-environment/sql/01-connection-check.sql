/*
Project 0
Step 01

目的：
確認 VS Code PostgreSQL Extension
確實連線到預期的 PostgreSQL Server。
*/

SELECT
    current_database(),
    current_user,
    current_schema(),
    version();