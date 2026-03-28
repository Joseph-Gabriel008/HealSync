const express = require('express');
const controller = require('../controllers/prescription.controller');

const router = express.Router();

router.get('/', controller.listPrescriptions);
router.post('/', controller.createPrescription);

module.exports = router;
