const express = require('express');
const controller = require('../controllers/doctor.controller');

const router = express.Router();

router.get('/', controller.getDoctors);

module.exports = router;
