# DBMS Lab Experiments

MySQL source code for the DBMS lab experiments, organized one folder per experiment.

| # | Experiment | Topic |
|---|------------|-------|
| 1 | [experiment-1-er-diagram](./experiment-1-er-diagram) | E-R diagram design for an e-commerce platform |
| 2 | [experiment-2-relational-schema](./experiment-2-relational-schema) | ER-to-relational mapping, constraints, referential integrity |
| 3 | [experiment-3-queries](./experiment-3-queries) | Selection, projection, aggregation, GROUP BY/HAVING, CASE, ORDER BY |
| 4 | [experiment-4-joins-subqueries](./experiment-4-joins-subqueries) | Joins, self-join, correlated subqueries, EXISTS, simulated INTERSECT/EXCEPT, EXPLAIN |
| 5 | [experiment-5-views-cte](./experiment-5-views-cte) | Views, view updatability, recursive CTE |
| 6 | [experiment-6-procedures-triggers](./experiment-6-procedures-triggers) | Stored procedure, triggers, audit logging |
| 7 | [experiment-7-normalization](./experiment-7-normalization) | Normalization: UNF → 1NF/2NF/3NF/BCNF |
| 8 | [experiment-8-transactions](./experiment-8-transactions) | Transactions, SAVEPOINT, isolation levels, concurrency |
| 9 | [experiment-9-indexing](./experiment-9-indexing) | Indexing and query plan benchmarking |
| 10 | [experiment-10-optimization](./experiment-10-optimization) | Slow queries, indexing and query rewriting |

Each folder contains a `.sql` file with the schema, sample data, and queries used in
that experiment (Experiment 1 is design-only, so it has a `README.md` instead).
