import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../db.js';
import crypto from 'crypto';
import { authenticateToken } from '../middleware/authMiddleware.js';
import { OAuth2Client } from 'google-auth-library';
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
import axios from 'axios';
const router = express.Router()

router.post('/register', async (req, res) => {
    const {username, email, password} = req.body;

    const hashPassword = bcrypt.hashSync(password, 7);

    try {

        const userID = crypto.randomUUID(); 

        const query = `
            INSERT INTO User (userID, username, email, password, provider, money, roles)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `;

        const values = [
            userID, 
            username, 
            email, 
            hashPassword,
            "local",
            10000,
            "user"
        ]

        await pool.execute(query, values);

        console.log('Success insert a new user!');

        res.status(201).json({
            message: 'Success insert a new user!',
            userID: userID,
            username: username
        })
    } catch (error){
        console.log(error.message);
        res.status(503);
    }

});

router.post('/register/google', async (req, res) => {
    const { accessToken } = req.body; 

    try {
        const googleResponse = await axios.get(
            `https://www.googleapis.com/oauth2/v3/userinfo?access_token=${accessToken}`
        );
        
        const payload = googleResponse.data;
        
        const email = payload.email;
        const username = payload.name;

        if (!email) {
            return res.status(401).json({ success: false, message: "Invalid token!" });
        }

        const [rows] = await pool.execute("SELECT * FROM User WHERE email = ?", [email]);
        let user = rows[0];

        if (!user) {
            const userID = crypto.randomUUID();
            const query = `INSERT INTO User (userID, username, email, password, provider, money, roles) VALUES (?, ?, ?, ?, ?, ?, ?)`;
            const values = [userID, username, email, null, "google", 10000, "user"];
            await pool.execute(query, values);
            const [newUserRows] = await pool.execute("SELECT * FROM User WHERE userID = ?", [userID]);
            user = newUserRows[0];
        }

        const tokenJWT = jwt.sign(
            { id: user.userID, email: user.email, roles: user.roles }, 
            process.env.JWT_SECRET, 
            { expiresIn: '7d' }
        );

        res.status(200).json({
            success: true,
            token: tokenJWT,
            user: { id: user.userID, username: user.username, email: user.email }
        });

    } catch (error) {
        console.error("Auth Error:", error.message);
        res.status(401).json({ success: false, message: "Fail verify to google" });
    }
});

router.post('/login', async (req, res) => {
    const {email, password} = req.body;

    try {
        const [rows] = await pool.execute("SELECT * FROM User WHERE email = ?", [email]);
        const user = rows[0];

        if (!user) {
            return res.status(404).json({ message: "Cannot find user!" });
        }

        if (user.provider === 'google' && !user.password) {
            return res.status(400).json({ message: "Please login using google" });
        }

        const isPasswordValid = bcrypt.compareSync(password, user.password);

        if(!isPasswordValid){
            return res.status(401).json({ message: "Wrong password"});
        }

        const tokenJWT = jwt.sign(
            { id: user.userID, email: user.email }, 
            process.env.JWT_SECRET, 
            { expiresIn: '7d' } 
        );

        res.status(200).json({
            token: tokenJWT,       
            user: {
                id: user.userID,
                username: user.username,
                money: user.money,
                roles: user.roles
            }
        });

    } catch (error){
        console.error(error.message);
        res.status(503);        
    }

})

router.get('/:userID', async (req, res) => {
    try{

        const {userID} = req.params;

        const [rows] = await pool.execute("SELECT username, email, money, roles FROM User WHERE userID = ?", [userID])

        if(rows.length === 0) return res.status(404).json({message: "User not found!"})

        res.status(200).json({
            user: rows[0],
        })
    } catch (error){
        res.status(500).json({
            message: error.message
        })
    }
})



export default router;