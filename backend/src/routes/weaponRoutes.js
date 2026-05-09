import express from 'express';
import fs from 'fs';
import multer from 'multer';
import pool from '../db.js';
import path from 'path';
import { authenticateToken, isAdmin } from '../middleware/authMiddleware.js';

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
        const { status } = req.query; 

        if(status === "not-available"){
            const [result] = await pool.execute(`SELECT * FROM Weapon WHERE stock = 0`);
            rows = result;
        } else if(status === "available"){
            const [result] = await pool.execute(`SELECT * FROM Weapon WHERE stock > 0`);
            rows = result;
        } else {
            const [result] = await pool.execute(`SELECT * FROM Weapon`);
            rows = result;
        }

        res.status(200).json(rows);
    } catch (error){
        console.log(error.message); 
        res.status(400).json({message: "Failed to fetch the data!"});
    }
})

router.get('/:weaponID', authenticateToken, async (req, res) => {
    try {
        const { weaponID } = req.params;
        const [result] = await pool.query(`SELECT * FROM Weapon WHERE weaponID = ?`, [weaponID]);
        
        if (result.length === 0) {
            return res.status(404).json({message: "Weapon not found"});
        }

        res.status(200).json(result[0]);
    } catch (error){
        console.log(error.message); 
        res.status(500).json({message: "Failed to fetch the weapon!"});
    }
})

router.post('/',authenticateToken, isAdmin, upload.single('image'), async (req,res) => {
    try {

        const {name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, price, stock} = req.body;

        if (!req.file) return res.status(400).json({message : "No image was uploaded!"});

        const imageUrl = `/assets/${req.file.filename}`;

        const weaponID = crypto.randomUUID();

        const query = `
            INSERT IGNORE INTO WEAPON (weaponID, name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, price, stock, image_url)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) 
        `;

        const values = [
            weaponID,
            name,
            type,
            rarity,
            baseAttack,
            subStat,
            passiveName,
            passiveDesc,
            price,
            stock,
            imageUrl
        ];

        await pool.execute(query, values);

        res.status(200).json({
            message: "Success insert a new weapon"
        });

    } catch (error){
        console.log(error.message);
        res.status(500);
    }
});

router.put('/:weaponID', authenticateToken, isAdmin, upload.single('image'), async (req,res) => {
    const { weaponID } = req.params;
    const {name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, price, stock} = req.body;

    try {
        const [rows] = await pool.execute(`SELECT image_url FROM Weapon WHERE weaponID = ?`, [weaponID]);

        if(rows.length === 0) return res.status(400).json({message: "Data is not found"});

        const oldImageUrl = rows[0].image_url;
        let newImageUrl = oldImageUrl;

        if(req.file){
            newImageUrl = `/assets/${req.file.filename}`;

            const oldPath = `/public${oldImageUrl}`;

            if(fs.existsSync(oldPath)) fs.unlinkSync(oldPath);

        }

        const query = `
            UPDATE Weapon
            SET name = ?, type = ?, rarity = ?, baseAttack = ?, subStat = ?, passiveName = ?, passiveDesc = ?, price = ?, stock = ?
            WHERE weaponID = ? 
        `;

        const values = [
            name, 
            type,
            rarity,
            baseAttack, 
            subStat, 
            passiveName,
            passiveDesc,
            price,
            stock,
            weaponID
        ]

        await pool.execute(query, values);

        res.status(200);

    } catch (error){
        console.log(error.message);
        res.status(500);
    }
});

router.delete('/:weaponID', authenticateToken, isAdmin, async (req,res) => {
    const {weaponID} = req.params;

    try {
        const [rows] = await pool.execute("SELECT image_url FROM Weapon WHERE weaponID = ?", [weaponID]);

        if (rows.length === 0) {
            return res.status(404).json({ message: "Cannot find a weapon!" });
        }

        const imageUrl = rows[0].image_url;

        await pool.execute("DELETE FROM Weapon WHERE weaponID = ?", [weaponID]);

        const filePath = `./public${imageUrl}`; 
        
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath); 
        }

        res.status(200);

    } catch (error){
        console.log(error.message);
        res.status(500);
    }
})

export default router;