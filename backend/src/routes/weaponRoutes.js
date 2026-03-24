import express from 'express';
import pool from '../db.js';
import { authenticateToken, isAdmin } from '../middleware/authMiddleware.js';
const router = express.Router();

router.get('/', authenticateToken, isAdmin, async (req, res) => {
    try {
        const [rows] = await pool.execute(`SELECT * FROM Weapon`);
        res.status(200).json(rows);
    } catch (error){
        console.log(error.message); 
        res.status(500).json({message: "Failed to fetch the data!"});
    }
})

router.post('/',authenticateToken, isAdmin, async (req,res) => {

});

router.put('/:weaponID', authenticateToken, isAdmin, (req,res) => {

});

router.delete('/:weaponID', authenticateToken, isAdmin, (req,res) => {

})

export default router;