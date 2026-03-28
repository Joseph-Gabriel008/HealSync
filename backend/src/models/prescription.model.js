const mongoose = require('mongoose');

const prescriptionSchema = new mongoose.Schema(
  {
    patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    condition: { type: String, default: '' },
    medication: { type: String, required: true },
    notes: { type: String, required: true },
  },
  { timestamps: true },
);

module.exports = mongoose.model('Prescription', prescriptionSchema);
