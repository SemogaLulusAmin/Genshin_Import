import express from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/buy/:artifactID',authenticateToken, async (req,res) => {
    const userID = req.user.userID;

    const {artifact} = req.params;
    const { quantity, price} = req.body;

    const connection = await pool.getConnection();

    try {

        await connection.beginTransaction();

        const [artifact] = await connection.execute(
            "SELECT stock, price FROM Artifact WHERE artifactID = ? FOR UPDATE", 
            [artifactID]
        );

        const [user] = await connection.execute(
            "SELECT money FROM User WHERE userID = ? FOR UPDATE",
            [userID]
        )

        if (artifact.length === 0) throw new Error("There's no such artifact!");
        if (artifact[0].stock < quantity) throw new Error("Artifact over stock!");
        const totalPrice = artifact[0].price * quantity;
        if (totalPrice > user[0].money) throw new Error("Not enough money!");

        await connection.execute("UPDATE User SET money = money - ? WHERE userID = ?", [totalPrice, userID]);

        await connection.execute("UPDATE Artifact SET stock = stock - ? WHERE artifactID = ?", [quantity, artifactID])

        await connection.execute("INSERT INTO ArtifactTransaction (userID, artifactID, stock) VALUES (?, ?, ?)",[userID, artifactID, quantity]);

        await connection.commit();

        res.status(200).json({message: "Successful buy an artifact"});

    } catch (error){
        await connection.rollback();
        console.log(error.message);
        res.status(500);
    } finally {
        connection.release();
    }

})

router.get('/',authenticateToken, async (req, res) => {
    try {
        const userID = req.user.userID;

        if (!userID) return res.status(400).json({ error: 'User ID is required' });

        const {status} = req.query;

        let query = "";
        if(status === "purchased"){
            query = `
                SELECT a.name, a.set_name, a.max_rarity, SUM(t.stock) as totalOwned, a.image_url, a.price, a.piece_bonus_2, a.piece_bonus_4
                FROM Artifact a
                JOIN ArtifactTransaction t ON a.artifactID = t.artifactID
                WHERE t.userID = ?
                GROUP BY a.artifactID
            `;
        } else if(status === "not-purchased"){
            query = `
                SELECT a.name, a.set_name, a.max_rarity, a.stock, a.image_url, a.price, a.piece_bonus_2, a.piece_bonus_4
                FROM Artifact a
                WHERE NOT EXISTS (
                    SELECT 1 
                    FROM ArtifactTransaction t
                    WHERE t.artifactID = a.artifactID
                    AND t.userID = ?
                )
            `;
        }

        const [rows] = await pool.execute(query, [userID]);

        res.status(200).json(rows);

    } catch (error) {
        console.error("Error fetching purchased items", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

export default router;