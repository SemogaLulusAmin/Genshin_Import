import express from 'express';
import pool from './db.js';
import 'dotenv/config';
import authRoutes from './routes/authRoutes.js';
import itemRoutes from './routes/itemRoutes.js';
import userItemRoutes from './routes/userItemRoutes.js';

const app = express();

const PORT = process.env.PORT || 3000;

app.use('/auth', authRoutes);
app.use('/userItem', userItemRoutes);
app.use('/items', itemRoutes);

app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

