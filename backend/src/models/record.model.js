const mongoose = require('mongoose');

const recordSchema = new mongoose.Schema(
  {
    patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    patientName: { type: String, required: true },
    condition: { type: String, required: true },
    prescription: { type: String, required: true },
    ipfsHash: { type: String, required: true },
    fileName: { type: String, required: true },
    filePath: { type: String, default: '' },
    verified: { type: Boolean, default: false },
  },
  { timestamps: true },
);

module.exports = mongoose.model('Record', recordSchema);
