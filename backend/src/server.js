import express from 'express';
import pool from './db.js';
import 'dotenv/config';
import authRoutes from './routes/authRoutes.js';
import itemRoutes from './routes/weaponRoutes.js';
import userweapon from './routes/userWeaponRoutes.js';

const app = express();

const PORT = process.env.PORT || 3000;

app.use('/assets', express.static('public/assets'));
app.use('/auth', authRoutes);
app.use('/userWeapon', userweapon);
app.use('/weapon', itemRoutes);

app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

