import jwt from 'jsonwebtoken';
import pool from '../db.js';

const isAdmin = (req, res, next) => {
    if (req.user.roles !== 'admin') {
        return res.status(403).json({ message: "Forbidden!, this area for admin only" });
    }
    next();
};

const authenticateToken = async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: "Denied Access, no token!" });
    }

    try {

        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        const [rows] = await pool.execute(
            "SELECT userID, username, roles FROM User WHERE userID = ?", 
            [decoded.id]
        );
        const user = rows[0];

        if (!user) {
            return res.status(401).json({ message: "Your session has ended, please re-login"});
        }

        req.user = user;

        next();
    } catch (error){
        console.log(error.message)
        return res.status(403).json({
            message: "invalid token or expired"
        })
    }
}

export {authenticateToken, isAdmin}