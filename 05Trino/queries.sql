-- Check if catalogs was created.
SHOW CATALOGS;
-- Should show "hive" and "system". If it only shows system, you fucked up!


-- New schema pointing to the bucket.
CREATE SCHEMA IF NOT EXISTS hive.bucket
WITH (location = 's3a://spark-data/');


-- Create a table with each row being lines in .txt files in s3://spark-data/alice/
-- In that folder, we only have alice.txt
CREATE TABLE hive.bucket.text (line VARCHAR)
WITH (
    format = 'TextFile',
    external_location = 's3a://spark-data/alice/'
)

-- View the lines of all files
SELECT * FROM hive.bucket.text limit 100;

-- Count all words
SELECT SUM(CARDINALITY(SPLIT(RTRIM(line), ' ')))
FROM hive.bucket.text;


-- Count top 10 words
SELECT DISTINCT word, COUNT(*) as count -- 4
FROM (
SELECT SPLIT(RTRIM(line), ' ') AS words -- 1
  FROM hive.bucket.text
)
CROSS JOIN UNNEST(words) AS T(word) -- 2
GROUP BY word -- 3
ORDER BY count DESC -- 5
LIMIT 10; -- 6


-- You can use the $path variable to select given files.
SELECT "$path" AS path, SUM(CARDINALITY(SPLIT(RTRIM(line), ' ')))
FROM hive.bucket.text
GROUP BY "$path"


-- BACKBLAZE DATASET

drop table hive.bucket.backblaze;


CREATE TABLE hive.bucket.backblaze (
  date VARCHAR,
  serial_number VARCHAR,
  model VARCHAR,
  capacity_bytes VARCHAR
)
WITH (
  skip_header_line_count = 1,
  format = 'CSV',
  external_location = 's3a://spark-data/backblaze/'
)


-- Query the backblaze dataset
SELECT
  model,
  FLOOR(CAST(capacity_bytes as BIGINT) / POWER(10, 9)) AS capacity_gigabytes,
  FLOOR(CAST(capacity_bytes as BIGINT) / POWER(10, 9)) * COUNT(*) AS total_capacity_terabytes,
  COUNT(*) AS count
FROM hive.bucket.backblaze
WHERE "$path" = 's3a://spark-data/backblaze/2023-06-30.csv' -- Remove this line to do it with all .csv files uploaded. Takes forever, but works!
GROUP BY model,capacity_bytes
ORDER BY count DESC;


