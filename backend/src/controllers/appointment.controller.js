const Appointment = require('../models/appointment.model');
const localDb = require('../services/local-db.service');
const { isDatabaseConnected } = require('../config/db');

async function createAppointment(req, res, next) {
  try {
    if (!isDatabaseConnected()) {
      const appointment = await localDb.createAppointment(req.body);
      res.status(201).json({ appointment });
      return;
    }

    const appointment = await Appointment.create(req.body);
    const populatedAppointment = await Appointment.findById(appointment._id)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role');
    res.status(201).json({ appointment: populatedAppointment });
  } catch (error) {
    next(error);
  }
}

async function listAppointments(req, res, next) {
  try {
    const filter = {};
    if (req.query.patientId) filter.patientId = req.query.patientId;
    if (req.query.doctorId) filter.doctorId = req.query.doctorId;
    if (req.query.clinicianId) filter.clinicianId = req.query.clinicianId;

    if (!isDatabaseConnected()) {
      const appointments = await localDb.listAppointments(filter);
      res.json({ appointments });
      return;
    }

    const query = {};
    if (filter.patientId) query.patientId = filter.patientId;
    if (filter.doctorId) query.doctorId = filter.doctorId;
    if (filter.clinicianId) {
      query.$or = [
        { doctorId: filter.clinicianId },
        { consultantIds: filter.clinicianId },
      ];
    }

    const appointments = await Appointment.find(query)
      .populate('patientId', 'name email role medicalHistory')
      .populate('doctorId', 'name email role medicalHistory')
      .populate('consultantIds', 'name email role medicalHistory')
      .sort({ date: 1 });
    res.json({ appointments });
  } catch (error) {
    next(error);
  }
}

async function addConsultant(req, res, next) {
  try {
    const { consultantId } = req.body;
    if (!consultantId) {
      return res.status(400).json({ message: 'consultantId is required' });
    }

    if (!isDatabaseConnected()) {
      const appointment = await localDb.addAppointmentConsultant(req.params.id, consultantId);
      if (!appointment) {
        return res.status(404).json({ message: 'Appointment not found' });
      }
      res.json({ appointment });
      return;
    }

    const appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      { $addToSet: { consultantIds: consultantId } },
      { new: true },
    )
      .populate('patientId', 'name email role medicalHistory')
      .populate('doctorId', 'name email role medicalHistory')
      .populate('consultantIds', 'name email role medicalHistory');

    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    res.json({ appointment });
  } catch (error) {
    next(error);
  }
}

module.exports = { createAppointment, listAppointments, addConsultant };
