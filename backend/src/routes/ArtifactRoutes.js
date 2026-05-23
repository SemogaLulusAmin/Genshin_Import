import express from 'express';
import fs from 'fs';
import multer from 'multer';
import pool from '../db.js';
import { authenticateToken, isAdmin } from '../middleware/authMiddleware.js';
import path from 'path';
const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/assets/'); 
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

router.get('/', authenticateToken, async (req, res) => {
    try {
        let rows = []
        const {status} = req.query;

        if(status === "not-available"){
            const [result] = await pool.query(`SELECT * FROM Artifact WHERE stock = 0`);
            rows = result;
        } else if(status === 'available'){
            const [result] = await pool.query(`SELECT * FROM Artifact WHERE stock > 0`);
            rows = result;
        } else {
            const [result] = await pool.query(`SELECT * FROM Artifact`)
            rows = result;
        }

        res.status(200).json(rows);
    } catch (error){
        console.log(error.message); 
        res.status(500).json({message: "Failed to fetch the data!"});
    }
})

router.get('/:artifactID', authenticateToken, async (req, res) => {
    try {
        const { artifactID } = req.params;
        const [result] = await pool.query(`SELECT * FROM Artifact WHERE artifactID = ?`, [artifactID]);
        
        if (result.length === 0) {
            return res.status(404).json({message: "Artifact not found"});
        }

        res.status(200).json(result[0]);
    } catch (error){
        console.log(error.message); 
        res.status(500).json({message: "Failed to fetch the artifact!"});
    }
})
router.post('/', authenticateToken, isAdmin, upload.single('image'), async (req, res) => {
    try {
        const { name, set_name, max_rarity, stock, price, piece_bonus_2, piece_bonus_4 } = req.body;
        if (!req.file) return res.status(400).json({ message: "No image was uploaded!" });

        const imageUrl = `/assets/${req.file.filename}`;
        const artifactID = crypto.randomUUID();

        const query = `
            INSERT IGNORE INTO Artifact (artifactID, name, set_name, max_rarity, stock, image_url, price, piece_bonus_2, piece_bonus_4)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) 
        `;

        const values = [artifactID, name, set_name, max_rarity, stock, imageUrl, price, piece_bonus_2, piece_bonus_4];
        await pool.execute(query, values);

        res.status(201).json({ message: "Success insert a new artifact" }); 
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ message: error.message });
    }
});

router.put('/:artifactID', authenticateToken, isAdmin, upload.single('image'), async (req, res) => {
    const { artifactID } = req.params;
    const { name, set_name, max_rarity, stock, price, piece_bonus_2, piece_bonus_4 } = req.body;

    try {
        const [rows] = await pool.execute(`SELECT image_url FROM Artifact WHERE artifactID = ?`, [artifactID]);
        if (rows.length === 0) return res.status(404).json({ message: "Data not found" });

        const oldImageUrl = rows[0].image_url;
        let finalImageUrl = oldImageUrl; // Gunakan variabel yang jelas

        if (req.file) {
            finalImageUrl = `/assets/${req.file.filename}`;
            const oldPath = `./public${oldImageUrl}`; // Pakai ./ biar path-nya benar
            if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
        }

        const query = `
            UPDATE Artifact
            SET name = ?, set_name = ?, max_rarity = ?, stock = ?, image_url = ?, price = ?, piece_bonus_2 = ?, piece_bonus_4 = ?
            WHERE artifactID = ? 
        `;

        const values = [name, set_name, max_rarity, stock, finalImageUrl, price, piece_bonus_2, piece_bonus_4, artifactID];

        await pool.execute(query, values);
        res.status(200).json({ message: "Artifact updated successfully" }); 
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ message: error.message });
    }
});

router.delete('/:artifactID', authenticateToken, isAdmin, async (req, res) => {
    const { artifactID } = req.params;
    try {
        const [rows] = await pool.execute("SELECT image_url FROM Artifact WHERE artifactID = ?", [artifactID]);
        if (rows.length === 0) return res.status(404).json({ message: "Artifact not found" });

        const imageUrl = rows[0].image_url;
        await pool.execute("DELETE FROM Artifact WHERE artifactID = ?", [artifactID]);

        const filePath = `./public${imageUrl}`; 
        if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

        res.status(200).json({ message: "Artifact deleted" }); 
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ message: error.message });
    }
});

export default router;