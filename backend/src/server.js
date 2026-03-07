import express from 'express';
import pool from './db.js';
import 'dotenv/config';

const app = express();

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Yeah server online on http://localhost:${PORT}`);
});

