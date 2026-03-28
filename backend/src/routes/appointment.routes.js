const express = require('express');
const controller = require('../controllers/appointment.controller');

const router = express.Router();

router.get('/', controller.listAppointments);
router.post('/', controller.createAppointment);
router.post('/:id/consultants', controller.addConsultant);

module.exports = router;
