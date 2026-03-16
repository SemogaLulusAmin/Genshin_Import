import pool from "./db.js";

async function initDB() {
    try {
        await pool.query(`
            CREATE TABLE  User (
                userID VARCHAR(36) PRIMARY KEY,
                username VARCHAR(100) NOT NULL,
                email VARCHAR(200) NOT NULL UNIQUE,
                password VARCHAR(255) NOT NULL,
                provider VARCHAR(50) NOT NULL,
                money DECIMAL(15, 4) DEFAULT 0,
                roles ENUM('user', 'admin') DEFAULT 'user',
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);
        console.log("Create User Table Success");
        
        await pool.query(`
            CREATE TABLE Item (
                itemID VARCHAR(100) PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                type VARCHAR(100) NOT NULL,
                rarity VARCHAR(50) NOT NULL,
                baseAttack VARCHAR(50) NOT NULL,
                subStat VARCHAR(100) NOT NULL,
                passiveName VARCHAR(255) NOT NULL,
                passiveDesc TEXT NOT NULL,
                image_url VARCHAR(255) NOT NULL,
                price DECIMAL(15, 4) NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )    
        `)

        console.log("Create Item Table Success");

        await pool.query(`
            CREATE TABLE Transaction (
                userID VARCHAR(36) NOT NULL,
                itemID VARCHAR(36) NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (userID, itemID),
                FOREIGN KEY (userID) REFERENCES User(userID),
                FOREIGN KEY (itemID) REFERENCES Item(itemID)
            )
        `)

        console.log("Create Transaction Table Success");

    } catch (error) {
        console.error("Error on creating table", error);
    }
}

initDB();