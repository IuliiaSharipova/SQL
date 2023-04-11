-- ----------------- Lesson #7 Table / View / Temp Table -----------------------
-- TABLE                      -- stored set of data, exist until droped
-- drop table mywork.payments_10000;
create table mywork.payments_10000 as
select customerNumber, checkNumber, paymentDate, amount
from classicmodels.payments
where amount <=10000
order by amount desc;

-- ---------------------------------------------------
-- VIEW						  -- like "saved query", virtual table, exist until droped
-- drop view mywork.v_payments_10000;
create view mywork.v_payments_10000 as
select customerNumber, checkNumber, paymentDate, amount
from classicmodels.payments
where amount <=10000
order by amount desc;

-- ---------------------------------------------------
-- TMP TABLE					-- stored set of data until session is closed; exists only in current session
-- drop table mywork.tmp_payments_10000;
create temporary table mywork.tmp_payments_10000 as
select customerNumber, checkNumber, paymentDate, amount
from classicmodels.payments
where amount <=10000
order by amount desc; 

select * from mywork.payments_10000;
desc mywork.payments_10000;
select * from mywork.v_payments_10000;
desc mywork.v_payments_10000;
select * from mywork.tmp_payments_10000;
desc mywork.tmp_payments_10000;

-- -------------------------- SQL vs. NoSQL Database ----------------------------------
-- https://www.ml4devs.com/articles/datastore-choices-sql-vs-nosql-database/

/*SQL databases advantage
- highly structured and efficient for complex queries
- support ACID (Atomicity, Consistency, Isolation, Durability) transactions, which ensure data integrity
- strong data consistency, data is always in a consistent state, even in the event of failures or updates 
- mature technology: widely used; SQL databases have been around for decades and are well-established technology
- easier to learn: SQL is a widely used standard language for relational databases, which makes it easier to learn and use
- used in applications that require transactional consistency and data integrity, 
such as banking, financial transactions or healthcare records


NoSQL databases advantage
- highly scalable and flexible for high performance and availability
- can handle large volumes of data and can be easily scaled horizontally to accommodate growth 
- provide faster query response times due to their non-relational structure
- allowing for different data formats to be stored together without the need for complex data transformations
- do not require the use of SQL and often rely on more familiar programming paradigms such as object-oriented programming
- used in applications that require high performance, scalability, and availability, 
such as social networks, gaming, and e-commerce websites.

Summary: The choice of database management system depends on the specific requirements of the application 
and the nature of the data being stored.*/

/*Databases have 5 components: interface, query processor, metadata, indexes, and storage:

1.Interface Language or API: Each database defines a language or API to interact with it. 
It covers definition, manipulation, query, and control of data and transactions.
2.Query Processor: The “CPU” of the database. Its job is to process incoming requests, perform needed actions, and return results.
The Query Processor performs the following steps for each incoming request:
Parses the request and validates it against the metadata.
Creates an efficient execution plan that exploits the indexes.
Reads or updates the storage.
Updates metadata and indexes.
Computes and returns results.
3.Storage: The disk or memory where the data is stored.
4.Indexes: Data structures to quickly locate the queried data in the storage.
5.Metadata: Meta-information of data, storage. and indexes (e.g., catalog, schema, size).
-- --------------------------------------------------------------------
SQL
Tabular datastores are suitable for storing structured data. 
Each record (row) has the same number of attributes (columns) of the same type.
There are two kinds of applications:
Online Transaction Processing (OLTP): Capture, store, and process data from transactions in real-time.
Online Analytical Processing (OLAP): analyze aggregated historical data from OLTP applications.
Relation Database Management Systems (RDBMS) are one of the earliest datastores. The data is organized in tables. 
Tables are normalized for reduced data redundancy and better data integrity.
Tables may have primary and foreign keys:
Query and transactions are coded using Structured Query Language (SQL).
Relational databases are optimized for transaction operations. Transactions often update multiple records in multiple tables. 
Indexes are optimized for frequent low-latency writes of 
-- ACID Transactions:
Atomicity: Any transaction that updates multiple rows is treated as a single unit. A successful transaction performs all updates. 
A failed transaction performs none of the updates, i.e., the database is left unchanged.
Consistency: Every transaction brings the database from one valid state to another. It guarantees to maintain all database invariants and constraints.
Isolation: Concurrent execution of multiple transactions leaves the database in the same state as if the transactions were executed sequentially.
Durability: Committed transactions are permanent, and survive even a system crash.

Cloud Agnostic: Oracle, Microsoft SQL Server, IBM DB2, PostgreSQL, and MySQL
AWS: Hosted PostgreSQL and MySQL in Relational Database Service (RDS)
Microsoft Azure: Hosted SQL Server as Azure SQL Database
Google Cloud: Hosted PostgreSQL and MySQL in Cloud SQL, and also horizontally scaling Cloud Spanner

Big Data Modern Data Warehouses are built on Columnar databases. Data is stored by columns instead of by rows. 
Available choices are:
AWS: RedShift
Azure: Synapse
Google Cloud: BigQuery
Apache: Druid, Kudu, Pinot
Others: ClickHouse, Snowflake

-- ----------------------------------------------------------------------------
NoSQL for Semi-structured Data
NoSQL datastores cater to semi-structured data 4 types: key-value, wide column, document (tree), and graph.

1.Key-Value Datastore
A key-value store is a dictionary or hash table database. 
It is designed for CRUD operations with a unique key for each record:
-- CRUD operations
Create(key, value): Add a key-value pair to the datastore
Read(key): Lookup the value associated with the key
Update(key, value): Change the existing value for the key
Delete(key): Delete the (key, value) record from the datastore
The values do not have a fixed schema and can be anything from primitive values to compound structures. 
Key-value stores are highly partitionable (thus scale horizontally). 
DB: Redis

2.Wide-column Datastore
A wide-column store has tables, rows, and columns. 
But the names of the columns and their types may be different for each row in the same table. 
Logically, It is a versioned sparse matrix with multi-dimensional mapping (row-value, column-value, timestamp). 
It is like a two-dimensional key-value store, with each cell value versioned with a timestamp.
Wide-column datastores are highly partitionable.
DB: Cassandra

3.Document Datastore
Document stores are for storing and retrieving a document consisting of nested objects. a tree structure such as XML, JSON, and YAML.
DB: MongoDB

4.Graph Datastore
Graph databases are like document stores but are designed for graphs instead of document trees. 
For example, a graph database will suit to store and query a social connection network.
DB: Neo4J, JanusGraph 

-- --------------------------------------------------------------------
SQL vs. NoSQL Database Comparison
Non-relational NoSQL datastores gained popularity for two reasons:
1.RDBMS did not scale horizontally for Big Data
2.Not all data fits into strict RDBMS schema

NoSQL datastores offer horizontal scale at various CAP Theorem tradeoffs. 
-- CAP Theorem
As per CAP Theorem, a distributed datastore can give at most 2 of the following 3 guarantees:
Consistency: Every read receives the most recent write or an error. (latest verion)
Availability: Every request gets a (non-error) response, regardless of the individual states of the nodes. (data returned even if one of the servers/nodes is down)
Partition tolerance: The cluster does not fail despite an arbitrary number of messages being dropped (or delayed) by the network between nodes. (cluster is still up even if some nodes are down)
   Note that the consistency definitions in CAP Theorem and ACID Transactions are different. 
   ACID consistency is about data integrity (data is consistent w.r.t. relations and constraints after every transaction). 
   CAP is about the state of all nodes being consistent with each other at any given time.

Only a few NoSQL datastores are ACID-complaint. Most NoSQL datastore support BASE model:
-- BASE model
Basically Available: Data is replicated on many storage systems and is available most of the time.
Soft-state: Replicas are not consistent all the time; so the state may only be partially correct as it may not yet have converged.
Eventually consistent: Data will become consistent at some point in the future, but no guarantee when.

-- --------------------------------------------------------------------
Difference between SQL and NoSQL
Differences between RDBMS and NoSQL databases stem from their choices for:
Data Model: RDBMS databases are used for normalized structured (tabular) data strictly adhering to a relational schema. 
NoSQL datastores are used for non-relational data, e.g. key-value, document tree, graph.
Transaction Guarantees: All RDBMS databases support ACID transactions, but most NoSQL datastores offer BASE transactions.
CAP Tradeoffs: RDBMS databases prioritize strong consistency over everything else. 
But NoSQL datastores typically prioritize availability and partition tolerance (horizontal scale) and offer only eventual consistency.

SQL vs. NoSQL Performance
NoSQL datastores are designed for efficiently handling a lot more data than RDBMS. 
There are no relational constraints on the data, and it does not need to be even tabular. 
NoSQL offers performance at a higher scale by typically giving up strong consistency. 
Data access is mostly through REST APIs. 
NoSQL query languages (such as GraphQL) are not yet as mature as SQL in design and optimizations. 
RDBMS scale vertically. You need to upgrade hardware (more powerful CPU, higher storage capacity) to handle the increasing load.
NoSQL datastores scale horizontally. NoSQL is better at handling partitioned data, so you can scale by adding more machines.
*/
-- ---------------------------------------------------
-- Homework #7 
-- Data Cleaning Project - English Dicionary
-- Import two files english_dictionary_master.csv and english_dictionary_most_common_words.csv
-- (Source: http://www.rupert.id.au/resources/1000-words.php)
-- 1.Edit - Preferences - SQL Editor - change RDBMS timout connection to 600
-- 2.Create database Dictionary;
-- 3.Right click on database dictinary - Table Data Import Wizard - dictionary.english_dictionary_master - Next
-- Right click on database dictinary - Table Data Import Wizard - dictionary.english_dictionary_most_common_words - Next
-- Get to know the data: n - noun, a - adjective, v - verb, adverb, preposition
-- 4.Show counts of both tables
-- 5.Create copies of both tables just in case you accidentally delete the originals
-- 6.Rename column type to word_type and definition to word_def
-- 7.Update column word_type and word_def to remove " and .
-- 8.Add column is_common to master table and update this column with 'yes' for common words 
-- 9.Using trim functon get rid off extra spaces in all columns in dictionary.english_dictionary_master
-- 10.
-- Query: how many distinct common/uncommon words are in the table?
-- Query: how many distinct word_types are in the table?
-- Query: find all english words for different colors (e.g. bronze, ruby, white, pink, red, azure, blue, etc.)
-- Query: randomly select 4 nouns and ajectives (order by rand())
-- Query: create separtate columns for each letter in the word -- use substr function







