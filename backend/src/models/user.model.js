const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    role: { type: String, enum: ['patient', 'doctor'], required: true },
    email: { type: String, required: true, unique: true, lowercase: true },
    phone: { type: String, default: '' },
    age: { type: Number, default: null },
    gender: { type: String, default: '' },
    medicalHistory: { type: String, default: '' },
    specialization: { type: String, default: '' },
    passwordHash: { type: String, required: true, select: false },
  },
  { timestamps: true },
);

module.exports = mongoose.model('User', userSchema);
