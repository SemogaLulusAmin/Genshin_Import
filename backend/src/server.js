import express from 'express';
import pool from './db.js';
import 'dotenv/config';
import authRoutes from './routes/authRoutes.js';
import itemRoutes from './routes/weaponRoutes.js';
import userItemRoutes from './routes/userWeaponRoutes.js';

const app = express();

const PORT = process.env.PORT || 3000;

app.use('/auth', authRoutes);
app.use('/userWeapon', userItemRoutes);
app.use('/weapon', itemRoutes);

app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

