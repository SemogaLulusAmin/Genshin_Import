import express from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/buy/:weaponID',authenticateToken, async (req,res) => {
    const userID = req.user.id;

    const {weaponID, quantity, price} = req.body;

    const connection = await pool.getConnection();

    try {

        await connection.beginTransaction();

        const [weapon] = await connection.execute(
            "SELECT stock, price FROM Weapon WHERE weaponID = ? FOR UPDATE", 
            [weaponID]
        );

        const [user] = await connection.execute(
            "SELECT money FROM User WHERE userID = ? FOR UPDATE",
            [userID]
        )

        if (weapon.length === 0) throw new Error("There's no such product!");
        if (weapon[0].stock < quantity) throw new Error("Quantity over stock!");
        const totalPrice = weapon[0].price * quantity;
        if (totalPrice > user[0].money) throw new Error("Not enough money!");

        await connection.execute("UPDATE User SET money = money - ? WHERE userID = ?", [totalPrice, userID]);

        await connection.execute("UPDATE Weapon SET stock = stock - ? WHERE weaponID = ?", [quantity, weaponID])

        await connection.execute("INSERT INTO WeaponTransaction (userID, weaponID, stock) VALUES (?, ?, ?)",[userID, weaponID, quantity]);

        await connection.commit();

        res.status(200);

    } catch (error){
        await connection.rollback();
        console.log(error.message);
        res.status(500);
    } finally {
        connection.release();
    }

})

router.get('/purchased-weapons/',authenticateToken, async (req, res) => {
    try {
        const userID = req.user.id;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const query = `
            SELECT w.name, w.type, w.rarity, w.baseAttack, w.subStat, w.passiveName, w.passiveDesc, w.image_url, w.price, w.stock
            FROM Weapon w
            JOIN WeaponTransaction t ON w.weaponID = t.weaponID
            WHERE t.userID = ?
        `;

        const [rows] = await pool.execute(query, [userID]);

        res.status(200).json(rows);

    } catch (error) {
        console.error("Error fetching purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('not-purchased-weapons/', authenticateToken, async (req, res) => {
    try {
        const userID = req.user.id;

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

        res.status(200).json(rows);

    } catch (error) {
        console.error("Error fetching not purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

export default router;