const Prescription = require('../models/prescription.model');
const localDb = require('../services/local-db.service');
const { isDatabaseConnected } = require('../config/db');

async function createPrescription(req, res, next) {
  try {
    if (!isDatabaseConnected()) {
      const prescription = await localDb.createPrescription(req.body);
      res.status(201).json({ prescription });
      return;
    }

    const prescription = await Prescription.create(req.body);
    const populatedPrescription = await Prescription.findById(prescription._id)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role');
    res.status(201).json({ prescription: populatedPrescription });
  } catch (error) {
    next(error);
  }
}

async function listPrescriptions(req, res, next) {
  try {
    const filter = {};
    if (req.query.patientId) filter.patientId = req.query.patientId;

    if (!isDatabaseConnected()) {
      const prescriptions = await localDb.listPrescriptions(filter);
      res.json({ prescriptions });
      return;
    }

    const prescriptions = await Prescription.find(filter)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role')
      .sort({ createdAt: -1 });
    res.json({ prescriptions });
  } catch (error) {
    next(error);
  }
}

module.exports = { createPrescription, listPrescriptions };
