import express from 'express';
import pool from './db.js';
import 'dotenv/config';

const app = express();

const PORT = process.env.PORT || 3000;

app.get('/purchased-items', async (req, res) => {
    try {
        const {userID} = req.params;

        const query = `
            SELECT i.*
            FROM Item i
            JOIN Transaction t ON i.itemID = t.itemID
            WHERE t.userID = ?
        `;

        const [rows] = await pool.execute(query, [userID || null]);

        res.json(rows);

    } catch (error) {
        console.error("Error fetching purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('not-purchased-items', async (req, res) => {
    try {
        const {userID} = req.params;

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

app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

