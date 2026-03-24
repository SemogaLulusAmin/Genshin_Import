import express from 'express';
import fs from 'fs';
import multer from 'multer';
import pool from '../db.js';
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

// weaponID VARCHAR(36) PRIMARY KEY,
//                 name VARCHAR(255) NOT NULL,
//                 type VARCHAR(100) NOT NULL,
//                 rarity VARCHAR(50) NOT NULL,
//                 baseAttack VARCHAR(50) NOT NULL,
//                 subStat VARCHAR(100) NOT NULL,
//                 passiveName VARCHAR(255) NOT NULL,
//                 passiveDesc TEXT NOT NULL,
//                 image_url VARCHAR(255) NOT NULL,
//                 price DECIMAL(15, 4) NOT NULL,
//                 stock INTEGER NOT NULL,

router.get('/', authenticateToken, isAdmin, async (req, res) => {
    try {
        const [rows] = await pool.execute(`SELECT * FROM Weapon`);
        res.status(200).json(rows);
    } catch (error){
        console.log(error.message); 
        res.status(500).json({message: "Failed to fetch the data!"});
    }
})

router.post('/',authenticateToken, isAdmin, upload.single('image'), async (req,res) => {
    try {

        const {name, type, rarity, baseAttack, subStat, passiveName, passiveDesc, price, stock} = req.body;

        if (!req.file) return res.status(400).json({message : "No image"});

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

router.put('/:weaponID', authenticateToken, isAdmin, (req,res) => {

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