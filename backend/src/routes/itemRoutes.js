import express from 'express';
import pool from '../db.js';

const router = express.Router();

// see all item
router.post('/', authenticateToken, isAdmin, (req, res) => {
    
})

// create a new item
router.post('/',authenticateToken, isAdmin, (req,res) => {

});

// update item
router.put('/:itemID', authenticateToken, isAdmin, (req,res) => {

});

// delete item
router.delete('/:itemID', authenticateToken, isAdmin, (req,res) => {

})

export default router;