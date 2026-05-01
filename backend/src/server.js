import express from 'express';
import cors from 'cors';
import pool from './db.js';
import 'dotenv/config';
import authRoutes from './routes/authRoutes.js';
import itemRoutes from './routes/weaponRoutes.js';
import userweapon from './routes/userWeaponRoutes.js';
import userartifact from './routes/userArtifactRoutes.js';
import artifactRoutes from './routes/ArtifactRoutes.js';
import cors from 'cors';
const app = express();

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json())
app.use('/assets', express.static('public/assets'));

app.use('/auth', authRoutes);
app.use('/userWeapon', userweapon);
app.use('/weapon', itemRoutes);
app.use('/userArtifact', userartifact);
app.use('/artifact',artifactRoutes);
app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

