const express = require('express');
const contractController = require('../controller/contract');
const router = express.Router();

router.get('/symbol', contractController.getSymbol);
router.get('/name', contractController.getName);
router.get('/total_supply', contractController.getTotalSupply);
router.post('/get_balance',contractController.getBalanceOfAccount);
router.post('/transfer',contractController.transfer);


module.exports = router;
