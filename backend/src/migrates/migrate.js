import pool from "../db.js";

async function initDB() {
    try {
        await pool.query(`
            CREATE TABLE User (
                userID VARCHAR(36) PRIMARY KEY,
                username VARCHAR(100) NOT NULL,
                email VARCHAR(200) NOT NULL UNIQUE,
                password VARCHAR(255),
                provider ENUM('local','google') NOT NULL,
                bearer_token VARCHAR(255),
                money DECIMAL(15, 4) DEFAULT 0,
                roles ENUM('user', 'admin') DEFAULT 'user',
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);
        console.log("Create User Table Success");
        
        await pool.query(`
            CREATE TABLE Weapon (
                weaponID VARCHAR(36) PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                type VARCHAR(100) NOT NULL,
                rarity VARCHAR(50) NOT NULL,
                baseAttack VARCHAR(50) NOT NULL,
                subStat VARCHAR(100) NOT NULL,
                passiveName VARCHAR(255) NOT NULL,
                passiveDesc TEXT NOT NULL,
                image_url VARCHAR(255) NOT NULL,
                price DECIMAL(15, 4) NOT NULL,
                stock INTEGER NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )    
        `)

        console.log("Create Weapon Table Success");

        await pool.query(`
            CREATE TABLE WeaponTransaction (
                userID VARCHAR(36) NOT NULL,
                weaponID VARCHAR(36) NOT NULL,
                stock INTEGER NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (userID, weaponID, createdAt),
                FOREIGN KEY (userID) REFERENCES User(userID),
                FOREIGN KEY (weaponID) REFERENCES Weapon(weaponID)
            )
        `)

        console.log("Create WeaponTransaction Table Success");

        await pool.query(`
            CREATE TABLE Artifact (
                artifactID VARCHAR(36) PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                set_name VARCHAR(100) NOT NULL,
                max_rarity VARCHAR(5) NOT NULL,
                stock INTEGER NOT NULL, 
                image_url VARCHAR(255) NOT NULL,
                price DECIMAL(15,4) NOT NULL,
                piece_bonus_2 TEXT,
                piece_bonus_4 TEXT
            )
        `)

        console.log("Create Artifact Table Success");

        await pool.query(`
            CREATE TABLE ArtifactTransaction (
                userID VARCHAR(36) NOT NULL,
                artifactID VARCHAR(36) NOT NULL,
                stock INTEGER NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (userID, artifactID, createdAt),
                FOREIGN KEY (userID) REFERENCES User(userID),
                FOREIGN KEY (artifactID) REFERENCES Artifact(artifactID)
            )
        `)

        console.log("Create ArtifactTransaction Table Success");
        
    } catch (error) {
        console.error("Error on creating table", error);
    } finally{
        await pool.end();
        process.exit(0);
    }
}

initDB();