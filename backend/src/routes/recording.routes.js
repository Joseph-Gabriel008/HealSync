const express = require('express');
const controller = require('../controllers/recording.controller');

const router = express.Router();

router.post('/uploadRecording', controller.uploadRecording);
router.get('/recordings/:patientId', controller.listRecordings);

module.exports = router;
