import express from 'express';
import pool from '../db.js';

const router = express.Router();

router.get('/', authenticateToken, isAdmin, (req, res) => {
    
})

router.post('/',authenticateToken, isAdmin, (req,res) => {

});

router.put('/:weaponID', authenticateToken, isAdmin, (req,res) => {

});

router.delete('/:weaponID', authenticateToken, isAdmin, (req,res) => {

})

export default router;