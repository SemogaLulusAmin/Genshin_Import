import express from 'express';
import pool from '../db.js';

const router = express.Router();

router.get('/purchased-items/:userID',authenticateToken, async (req, res) => {
    try {
        const {userID} = req.params;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const query = `
            SELECT i.*
            FROM Item i
            JOIN Transaction t ON i.itemID = t.itemID
            WHERE t.userID = ?
        `;

        const [rows] = await pool.execute(query, [userID]);

        res.json(rows);

    } catch (error) {
        console.error("Error fetching purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('not-purchased-items/:userID', authenticateToken, async (req, res) => {
    try {
        const {userID} = req.params;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const query = `
            SELECT i.*
            FROM Item i
            WHERE NOT EXISTS (
                SELECT 1 
                FROM Transaction t 
                WHERE t.itemID = i.itemID 
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