import express from 'express';
import pool from '../db.js';

const router = express.Router();

router.get('/purchased-weapons/:userID',authenticateToken, async (req, res) => {
    try {
        const {userID} = req.params;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const query = `
            SELECT w.name, w.type, w.rarity, w.baseAttack, w.subStat, w.passiveName, w.passiveDesc, w.image_url, w.price, w.stock
            FROM Weapon w
            JOIN WeaponTransaction t ON w.weaponID = t.weaponID
            WHERE t.userID = ?
        `;

        const [rows] = await pool.execute(query, [userID]);

        res.json(rows);

    } catch (error) {
        console.error("Error fetching purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('not-purchased-weapons/:userID', authenticateToken, async (req, res) => {
    try {
        const {userID} = req.params;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const query = `
            SELECT w.name, w.type, w.rarity, w.baseAttack, w.subStat, w.passiveName, w.passiveDesc, w.image_url, w.price, w.stock
            FROM Weapon w
            WHERE NOT EXISTS (
                SELECT 1 
                FROM WeaponTransaction t 
                WHERE t.weaponID = w.weaponID 
                AND t.userID = ?
            )
        `;

        const [rows] = await pool.execute(query, [userID || null]);

        res.json(rows);

    } catch (error) {
        console.error("Error fetching not purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

export default router;