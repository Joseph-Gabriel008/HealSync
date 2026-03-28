const fs = require('fs/promises');
const path = require('path');
const crypto = require('crypto');

const dataDir = path.join(__dirname, '..', '..', 'data');
const dataFile = path.join(dataDir, 'local-db.json');

const emptyDb = () => ({
  users: [],
  appointments: [],
  records: [],
  prescriptions: [],
  recordings: [],
});

async function ensureDbFile() {
  await fs.mkdir(dataDir, { recursive: true });
  try {
    await fs.access(dataFile);
  } catch (_) {
    await fs.writeFile(dataFile, JSON.stringify(emptyDb(), null, 2));
  }
}

async function readDb() {
  await ensureDbFile();
  const raw = await fs.readFile(dataFile, 'utf8');
  try {
    return JSON.parse(raw);
  } catch (_) {
    const fallback = emptyDb();
    await fs.writeFile(dataFile, JSON.stringify(fallback, null, 2));
    return fallback;
  }
}

async function writeDb(db) {
  await ensureDbFile();
  await fs.writeFile(dataFile, JSON.stringify(db, null, 2));
}

function nowIso() {
  return new Date().toISOString();
}

function newId(prefix) {
  return `${prefix}-${crypto.randomUUID()}`;
}

function sanitizeUser(user) {
  if (!user) {
    return null;
  }

  const { passwordHash, ...safeUser } = user;
  return safeUser;
}

function applyFilter(items, filter) {
  return items.filter((item) =>
    Object.entries(filter).every(([key, value]) => item[key] === value),
  );
}

function sortByDateDesc(items, key) {
  return [...items].sort(
    (a, b) => new Date(b[key]).getTime() - new Date(a[key]).getTime(),
  );
}

function sortByDateAsc(items, key) {
  return [...items].sort(
    (a, b) => new Date(a[key]).getTime() - new Date(b[key]).getTime(),
  );
}

async function listUsers(filter = {}) {
  const db = await readDb();
  return sortByDateDesc(applyFilter(db.users, filter), 'createdAt').map(sanitizeUser);
}

async function findUserByEmail(email, { includePasswordHash = false } = {}) {
  const db = await readDb();
  const user = db.users.find((entry) => entry.email === email.toLowerCase());
  if (!user) {
    return null;
  }
  return includePasswordHash ? user : sanitizeUser(user);
}

async function findUserById(id) {
  const db = await readDb();
  return sanitizeUser(db.users.find((entry) => entry._id === id));
}

async function createUser({ name, email, role, passwordHash }) {
  const db = await readDb();
  const user = {
    _id: newId('user'),
    name,
    email: email.toLowerCase(),
    role,
    phone: '',
    age: null,
    gender: '',
    medicalHistory: '',
    specialization: '',
    passwordHash,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.users.push(user);
  await writeDb(db);
  return sanitizeUser(user);
}

async function updateUserProfile(id, updates) {
  const db = await readDb();
  const index = db.users.findIndex((entry) => entry._id === id);
  if (index === -1) {
    return null;
  }

  const current = db.users[index];
  db.users[index] = {
    ...current,
    ...updates,
    email: current.email,
    role: current.role,
    passwordHash: current.passwordHash,
    updatedAt: nowIso(),
  };

  await writeDb(db);
  return sanitizeUser(db.users[index]);
}

async function createAppointment({ patientId, doctorId, consultantIds = [], date, status = 'Scheduled' }) {
  const db = await readDb();
  const appointment = {
    _id: newId('appointment'),
    patientId,
    doctorId,
    consultantIds,
    date,
    status,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.appointments.push(appointment);
  await writeDb(db);
  return populateAppointment(appointment, db.users);
}

async function listAppointments(filter = {}) {
  const db = await readDb();
  const appointments = db.appointments.filter((item) => {
    return Object.entries(filter).every(([key, value]) => {
      if (key === 'clinicianId') {
        return item.doctorId === value || (item.consultantIds || []).includes(value);
      }
      return item[key] === value;
    });
  });
  return sortByDateAsc(appointments, 'date').map((entry) =>
    populateAppointment(entry, db.users),
  );
}

async function addAppointmentConsultant(appointmentId, consultantId) {
  const db = await readDb();
  const index = db.appointments.findIndex((entry) => entry._id === appointmentId);
  if (index === -1) {
    return null;
  }

  const current = db.appointments[index];
  const consultantIds = Array.isArray(current.consultantIds)
    ? [...new Set([...current.consultantIds, consultantId])]
    : [consultantId];

  db.appointments[index] = {
    ...current,
    consultantIds,
    updatedAt: nowIso(),
  };

  await writeDb(db);
  return populateAppointment(db.appointments[index], db.users);
}

async function createRecord({ patientId, doctorId, fileName, ipfsHash, verified = true }) {
  const db = await readDb();
  const record = {
    _id: newId('record'),
    patientId,
    doctorId,
    patientName: '',
    condition: '',
    prescription: '',
    fileName,
    filePath: '',
    ipfsHash,
    verified,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.records.push(record);
  await writeDb(db);
  return populateRecord(record, db.users);
}

async function addMedicalRecord({
  patientId,
  doctorId,
  patientName,
  condition,
  prescription,
  fileName,
  filePath,
  ipfsHash,
  verified = true,
}) {
  const db = await readDb();
  const record = {
    _id: newId('record'),
    patientId,
    doctorId,
    patientName,
    condition,
    prescription,
    fileName,
    filePath,
    ipfsHash,
    verified,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.records.push(record);
  await writeDb(db);
  return populateRecord(record, db.users);
}

async function listRecords(filter = {}) {
  const db = await readDb();
  return sortByDateDesc(applyFilter(db.records, filter), 'createdAt').map((entry) =>
    populateRecord(entry, db.users),
  );
}

async function createPrescription({ patientId, doctorId, condition = '', medication, notes }) {
  const db = await readDb();
  const prescription = {
    _id: newId('prescription'),
    patientId,
    doctorId,
    condition,
    medication,
    notes,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.prescriptions.push(prescription);
  await writeDb(db);
  return populatePrescription(prescription, db.users);
}

async function listPrescriptions(filter = {}) {
  const db = await readDb();
  return sortByDateDesc(applyFilter(db.prescriptions, filter), 'createdAt').map((entry) =>
    populatePrescription(entry, db.users),
  );
}

async function createRecording({
  patientId,
  doctorId,
  filePath,
  fileName,
  duration,
  date,
}) {
  const db = await readDb();
  const recording = {
    _id: newId('recording'),
    patientId,
    doctorId,
    filePath,
    fileName,
    duration,
    date,
    createdAt: nowIso(),
    updatedAt: nowIso(),
  };
  db.recordings.push(recording);
  await writeDb(db);
  return populateRecording(recording, db.users);
}

async function listRecordings(filter = {}) {
  const db = await readDb();
  return sortByDateDesc(applyFilter(db.recordings, filter), 'date').map((entry) =>
    populateRecording(entry, db.users),
  );
}

function populateAppointment(appointment, users) {
  return {
    ...appointment,
    patientId: sanitizeUser(users.find((entry) => entry._id === appointment.patientId)),
    doctorId: sanitizeUser(users.find((entry) => entry._id === appointment.doctorId)),
    consultantIds: (appointment.consultantIds || []).map((id) =>
      sanitizeUser(users.find((entry) => entry._id === id)),
    ).filter(Boolean),
  };
}

function populateRecord(record, users) {
  return {
    ...record,
    patientId: sanitizeUser(users.find((entry) => entry._id === record.patientId)),
    doctorId: sanitizeUser(users.find((entry) => entry._id === record.doctorId)),
  };
}

function populatePrescription(prescription, users) {
  return {
    ...prescription,
    patientId: sanitizeUser(users.find((entry) => entry._id === prescription.patientId)),
    doctorId: sanitizeUser(users.find((entry) => entry._id === prescription.doctorId)),
  };
}

function populateRecording(recording, users) {
  return {
    ...recording,
    patientId: sanitizeUser(users.find((entry) => entry._id === recording.patientId)),
    doctorId: sanitizeUser(users.find((entry) => entry._id === recording.doctorId)),
  };
}

module.exports = {
  addMedicalRecord,
  addAppointmentConsultant,
  createAppointment,
  createPrescription,
  createRecord,
  createRecording,
  createUser,
  findUserByEmail,
  findUserById,
  listAppointments,
  listPrescriptions,
  listRecords,
  listRecordings,
  listUsers,
  updateUserProfile,
};
