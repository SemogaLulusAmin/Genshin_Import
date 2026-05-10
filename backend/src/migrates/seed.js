import pool from "../db.js";
import axios from 'axios';
import crypto from 'crypto';

async function seedDB() {
    try {
        const {data: weaponsID} = await axios.get('https://genshin.jmp.blue/weapons');
        for (const weaponID of weaponsID) {
            const { data: w } = await axios.get(`https://genshin.jmp.blue/weapons/${weaponID}`);
            const itemID = crypto.randomUUID();

            const query = `
                INSERT IGNORE INTO Weapon
                (weaponID, name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, image_url, price, stock) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

            const values = [
                itemID,                              
                w.name,                   
                w.type,                              
                w.rarity ? w.rarity.toString() : '0',  
                w.baseAttack ? w.baseAttack.toString() : '0', 
                w.subStat || 'N/A',                    
                w.passiveName || 'No Passive',         
                w.passiveDesc || 'No Description',     
                `https://genshin.jmp.blue/weapons/${weaponID}/icon.png`, 
                1000.00,
                1000 
            ];

            await pool.execute(query, values);
            console.log(`Inserted weapon: ${w.name} (ID: ${weaponID})`);
        }

        const { data: artifactsID } = await axios.get('https://genshin.jmp.blue/artifacts');

        for (const id of artifactsID) {
            try{
                const { data: a } = await axios.get(`https://genshin.jmp.blue/artifacts/${id}`);
                const { data: artifactPieces } = await axios.get(`https://genshin.jmp.blue/artifacts/${id}/list`);

                for (const artifactPiece of artifactPieces) {
                    try{
                        const artifactID = crypto.randomUUID();

                        const image_url = `https://genshin.jmp.blue/artifacts/${id}/${artifactPiece}`;

                        const query = `
                            INSERT IGNORE INTO Artifact
                            (artifactID, name, set_name, max_rarity, piece_bonus_2 , piece_bonus_4 , image_url, price, stock) 
                            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                        `;

                        const values = [
                            artifactID,
                            artifactPiece,       
                            a.name,              
                            a.max_rarity,
                            a['2-piece_bonus'],  
                            a['4-piece_bonus'],
                            image_url,
                            1000.00,
                            1000                   
                        ];

                        await pool.execute(query, values);
                        console.log(`Inserted artifacts: ${artifactPiece}`);
                    } catch(error){
                        continue;
                    }
                }
            } catch(error){
                continue;
            }
        }

        {
            
            const query = `
                INSERT INTO User
                (userID, username, email, password, provider, bearer_token, money, roles)
                (?, ?, ?, ?, ?, ?, ?, ?)
            `

            const values = [
                "c8a54cd8-a9ed-4b5b-8dd4-471d9cf1bd13",
                "Ayam Jago",
                "ayamjago@gmail.com",
                "Aiueo1234@",
                "local",
                "9a7b501d4130b88836f02607bd1ff186721e6ff5",
                100000,
                "admin"
            ]

            await pool.execute(query, values);
        }

        {
            
            const query = `
                INSERT INTO User
                (userID, username, email, password, provider, bearer_token, money, roles)
                (?, ?, ?, ?, ?, ?, ?, ?)
            `

            const values = [
                "f9aeb268-04cc-4aad-8e16-2d5ab77b365e",
                "Maltzu",
                "maltzu@gmail.com",
                "Aiueo1234@",
                "local",
                "0aa1fde3ce0399f87d0b0805b2dac83a6af6a309",
                10000,
                "user"
            ]

            await pool.execute(query, values);
        }

        console.log("Seeding completed successfully.");
    } catch (error) {
        console.error("Error on seeding data", error);
    } finally {
        await pool.end();
        process.exit(0);
    }
}

seedDB();