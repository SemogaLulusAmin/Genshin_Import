import express from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router()

router.patch('/edit-profile', authenticateToken, async (req, res) => {
    const userID = req.user.userID;

    const {username} = req.body; 

    try {

        const query = `
            UPDATE user
            SET username = ?
            WHERE userID = ?
        `

        const values = [
            username,
            userID
        ]

        await pool.execute(query, values);

        res.status(200).json({
            message: "Successfully update username"
        })

    } catch(error){
        console.log(error);
        res.status(500).json({
            message: error
        })
    }
})

export default router;