import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../db.js';
import crypto from 'crypto';

const router = express.Router()

router.post('/register', async (req, res) => {
    const {username, email, password} = req.body;

    const hashPassword = bcrypt.hashSync(password, 7);

    try {
        const [rows] = await pool.execute("SELECT * FROM User WHERE email = ?", [email]);
        const user = rows[0];

        if (user) {
            return res.status(400).json({ message: "User already exists!" });
        }

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
    const {username, email} = req.body;

    try {
        
        const [rows] = await pool.execute("SELECT * FROM User WHERE email = ?", [email]);
        let user = rows[0];

        const newBearerToken = crypto.randomBytes(20).toString('hex');

        if(user){
            await pool.execute("UPDATE User SET bearer_token = ? WHERE userID = ?", [newBearerToken, user.userID]);
            user.bearer_token = newBearerToken; 
        } else {
            const userID = crypto.randomUUID();

            const query = `
            INSERT INTO User (userID, username, email, password, provider, money, roles, bearer_token)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            `;

            const values = [
                userID, 
                username, 
                email, 
                null,
                "google",
                10000,
                "user",
                newBearerToken
            ]

            await pool.execute(query, values);

            const [newUser] = await pool.execute("SELECT * FROM User WHERE userID = ?", [userID]);
            user = newUser[0];
        }

        const tokenJWT = jwt.sign(
            { id: user.userID, email: user.email }, 
            process.env.JWT_SECRET, 
            { expiresIn: '7d' }
        );

        res.status(200).json({
            message: 'Success insert a new user!',
            token: tokenJWT,
            user: {
                userID : user.userID,
                username : user.username
            }
        });

    } catch (error){
        console.error(error.message);
        res.status(503);        
    }

})

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

        const newBearerToken = crypto.randomBytes(20).toString('hex');

        const tokenJWT = jwt.sign(
            { id: user.userID, email: user.email }, 
            process.env.JWT_SECRET, 
            { expiresIn: '7d' } 
        );

        await pool.execute("UPDATE User SET bearer_token = ? WHERE userID = ?", [newBearerToken, user.userID]);

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

router.post('/logout', async (req, res) => {
    try {
        const { userID } = req.body;
        await pool.execute("UPDATE User SET bearer_token = NULL WHERE userID = ?", [userID]);
        res.json({ message: "Logged out!" });
    } catch (error){
        console.error(error.message);
        res.status(503);
    }
});

export default router;