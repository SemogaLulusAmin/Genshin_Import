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
                INSERT IGNORE INTO Item 
                (itemID, name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, image_url, price, stock) 
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

            await pool.query(query, values);
            console.log(`Inserted weapon: ${w.name} (ID: ${weaponID})`);
        }

        console.log("Seeding completed successfully.");
    } catch (error) {
        console.error("Error on seeding data", error);
    }   
}

seedDB();