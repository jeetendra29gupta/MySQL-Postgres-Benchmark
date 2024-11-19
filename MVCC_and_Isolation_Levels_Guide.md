## **Multi-Version Concurrency Control (MVCC)** and **Isolation Levels** in Databases

### **1. Introduction to MVCC (Multi-Version Concurrency Control)**

**MVCC** is a concurrency control method used by many modern relational databases, including **PostgreSQL**, **Oracle**, and **MySQL** (with the InnoDB storage engine). It is designed to allow multiple transactions to read and write to the database concurrently without interfering with each other, while ensuring that database consistency is maintained.

The key idea behind **MVCC** is that instead of locking data to ensure consistency, the database **creates multiple versions** of the same data for different transactions, allowing each transaction to work with its snapshot of the data.

### **How MVCC Works**
In **MVCC**-enabled databases, every row of data has a **version number** or a **timestamp** associated with it, which helps track when a specific change (insert/update) was made. When a transaction accesses the data, it sees the data as it was at the **start of the transaction** or at a **consistent snapshot** in time.

1. **Transaction Start**: Each transaction gets a snapshot of the database. It only sees data that was committed before the transaction started.
2. **Data Modification**: When a transaction makes a modification (e.g., update), instead of changing the data directly, the database creates a **new version** of the data.
3. **Read Data**: A transaction will only see the versions of the data that were **committed** at the time the transaction started, ensuring that it doesn’t see data that has been modified by another transaction but not yet committed.
4. **Transaction End**: When a transaction is committed, its changes become visible to other transactions. If it is rolled back, the changes are discarded, and any uncommitted versions of the data are removed.

### **Benefits of MVCC**
- **Non-blocking Reads**: Since each transaction works with a snapshot of the data, transactions can read data without waiting for other transactions to release locks, resulting in higher concurrency.
- **Improved Performance**: MVCC minimizes lock contention and reduces deadlocks in systems where many transactions are reading data concurrently.
- **Consistency**: MVCC helps maintain consistency in a multi-user environment by ensuring that transactions only see the data as it was at the time they started, preventing issues like **dirty reads** and **non-repeatable reads**.

### **Challenges of MVCC**
- **Increased Storage Overhead**: MVCC creates multiple versions of data, which can result in higher storage requirements as old versions are kept until the transaction is completed.
- **Garbage Collection**: The database needs to periodically clean up outdated versions of data, which can add overhead in terms of performance.

---

### **2. Introduction to Isolation Levels**

**Isolation levels** are a critical concept in transaction management in relational databases. They define the extent to which the operations in one transaction are isolated from those in other concurrent transactions.

Isolation is one of the **ACID** (Atomicity, Consistency, Isolation, Durability) properties of a transaction. It ensures that transactions behave as if they are executed serially, even if they are executed concurrently, to avoid issues like **data anomalies** or **inconsistent views**.

There are four main isolation levels, each offering a different balance between **performance** (allowing more concurrency) and **consistency** (guaranteeing data correctness):

---

#### **2.1. Isolation Levels in Detail**

##### **1. Read Uncommitted**
- **Description**: At the lowest isolation level, transactions can read data that has been modified but not yet committed by other transactions (i.e., **dirty reads**).
- **Example**: 
    - Transaction T1 updates a row but hasn't committed yet.
    - Transaction T2 reads the same row and sees the uncommitted changes made by T1.
    - If T1 rolls back, T2 will have read invalid data.
- **Advantages**: **High performance** because there are fewer locks and less overhead.
- **Disadvantages**: The most **inconsistent** view of data, as transactions may read uncommitted (and potentially rolled back) data.
- **Use Case**: Suitable for **read-only** operations where consistency isn't critical.

##### **2. Read Committed**
- **Description**: Transactions can only read data that has been committed by other transactions. A transaction cannot read data that is still being modified by another transaction.
- **Example**:
    - Transaction T1 updates a row and commits.
    - Transaction T2 can only read the row after T1 has committed.
    - However, **non-repeatable reads** can occur: If T2 reads the row, then another transaction commits an update, T2 will see a different value if it reads the same row again.
- **Advantages**: Guarantees that transactions won't see uncommitted data, but still allows higher concurrency.
- **Disadvantages**: May result in **non-repeatable reads**.
- **Use Case**: Suitable for systems that require moderate consistency but still want some degree of concurrency (e.g., e-commerce sites).

##### **3. Repeatable Read**
- **Description**: Once a transaction reads a row, it locks the row to ensure that no other transaction can modify it. However, **phantom reads** can still occur, where new rows matching the query conditions are inserted by other transactions.
- **Example**:
    - Transaction T1 reads a row.
    - Transaction T2 tries to update the same row, but is blocked until T1 commits or rolls back.
    - If T1 starts a second read operation, it will see the same data, even if T2 has modified it.
- **Advantages**: Prevents **non-repeatable reads** by locking rows.
- **Disadvantages**: **Phantom reads** may still happen, and there can be **higher contention** for rows.
- **Use Case**: Useful in scenarios like booking systems, where data integrity must be maintained (e.g., seats must not be double-booked).

##### **4. Serializable**
- **Description**: The highest level of isolation. Transactions are executed in such a way that the results are equivalent to executing them serially, one after the other. It ensures that no other transaction can read or modify the data being worked on by the current transaction.
- **Example**:
    - Transaction T1 locks rows for reading and writing.
    - Transaction T2 tries to read or write any row within the locked range and is blocked until T1 finishes.
- **Advantages**: Provides the **highest level of consistency** and prevents all concurrency anomalies, including dirty reads, non-repeatable reads, and phantom reads.
- **Disadvantages**: **Very low concurrency** and higher performance cost due to extensive locking.
- **Use Case**: Critical systems, like banking or financial applications, where **data correctness** is paramount.

---

#### **2.2. Comparison of Isolation Levels**

| **Isolation Level**   | **Dirty Reads** | **Non-Repeatable Reads** | **Phantom Reads** | **Locks Data** | **Performance**     | **Consistency**    |
|-----------------------|-----------------|--------------------------|-------------------|----------------|---------------------|-------------------|
| **Read Uncommitted**   | Allowed         | Allowed                  | Allowed           | No             | Highest             | Lowest            |
| **Read Committed**     | Not Allowed     | Allowed                  | Allowed           | No             | High                | Moderate          |
| **Repeatable Read**    | Not Allowed     | Not Allowed              | Allowed           | Yes            | Moderate            | High              |
| **Serializable**       | Not Allowed     | Not Allowed              | Not Allowed       | Yes            | Lowest              | Highest           |

- **Performance Impact**: As you move from **Read Uncommitted** to **Serializable**, the performance impact increases because of the stricter locking mechanisms that prevent more concurrent transactions.

- **Consistency vs Concurrency**: Lower isolation levels (like **Read Uncommitted**) allow more concurrency, but at the cost of **data consistency**. Higher isolation levels (like **Serializable**) provide strong consistency but significantly reduce the number of concurrent transactions that can be executed.

---

### **3. MVCC and Isolation Levels in PostgreSQL**

In **PostgreSQL**, **MVCC** is the default concurrency control method, and it enables the database to support **Read Committed** and **Repeatable Read** isolation levels efficiently.

- **PostgreSQL's Default Isolation Level** is **Read Committed**, but you can configure it to use **Repeatable Read** or **Serializable**.
- PostgreSQL uses **MVCC** to ensure that transactions only see their own changes and those committed before the transaction started, without blocking other transactions for reads.
- **Serializable Isolation** in PostgreSQL is implemented through a mechanism called **Serializable Snapshot Isolation (SSI)**, which ensures that transactions behave as though they were executed serially, even though they are running concurrently.

---

### **Conclusion: MVCC vs Isolation Levels**

- **MVCC** is an important mechanism in modern relational databases, enabling high concurrency by allowing transactions to read from consistent snapshots of data without blocking each other. It works best in environments where transactions frequently read and update data concurrently.
- **Isolation Levels** provide various guarantees about the consistency of data seen by a transaction in a multi-transaction environment. While **MVCC** helps with **concurrency**, the **isolation level** chosen determines the degree

 of **consistency** and **concurrency trade-off**.

By understanding both **MVCC** and **isolation levels**, database designers can choose the right configuration to balance **performance** and **data consistency** based on the needs of their application.

For further understanding, you can refer to this insightful article on Isolation Levels in RDBMS, written by my manager Mr. Rajesh Kishore:
[**Insight on RDBMS Isolation Level**](https://medium.com/@rajesh.rk.kishore/insight-on-rdbms-isolation-level-f863dd932822)
