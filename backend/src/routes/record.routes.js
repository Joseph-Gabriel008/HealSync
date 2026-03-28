const express = require('express');
const controller = require('../controllers/record.controller');

const router = express.Router();

router.get('/', controller.listRecords);
router.get('/:patientId', controller.getPatientRecords);
router.post('/', controller.createRecord);
router.post('/addMedicalRecord', controller.addMedicalRecord);

module.exports = router;
