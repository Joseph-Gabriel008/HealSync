const Record = require('../models/record.model');
const { uploadFile } = require('../services/ipfs.service');
const blockchainService = require('../services/blockchain.service');
const localDb = require('../services/local-db.service');
const { isDatabaseConnected } = require('../config/db');
const fs = require('fs/promises');
const path = require('path');

const uploadsDir = path.join(__dirname, '..', '..', 'uploads');

async function ensureUploadsDir() {
  await fs.mkdir(uploadsDir, { recursive: true });
}

async function persistBase64File(fileName, fileContent) {
  if (!fileName || !fileContent) {
    return '';
  }

  await ensureUploadsDir();
  const safeFileName = `${Date.now()}-${fileName.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
  const normalized = fileContent.includes(',')
    ? fileContent.split(',').last
    : fileContent;
  await fs.writeFile(
    path.join(uploadsDir, safeFileName),
    Buffer.from(normalized, 'base64'),
  );
  return `/uploads/${safeFileName}`;
}

function formatHistoryRecord(record) {
  const createdAt = record.createdAt || new Date().toISOString();
  return {
    id: record._id?.toString() || record.id?.toString() || '',
    patientName:
      record.patientName ||
      record.patientId?.name ||
      'Patient',
    file: record.filePath || record.fileName || '',
    fileName: record.fileName || '',
    condition: record.condition || '',
    prescription: record.prescription || '',
    date: new Date(createdAt).toISOString().split('T').first,
    createdAt,
  };
}

async function createRecord(req, res, next) {
  try {
    const { patientId, doctorId, fileName, patientWallet, doctorWallet } = req.body;
    const ipfsHash = await uploadFile(fileName);
    await blockchainService.addRecord(
      patientWallet || `wallet-${patientId}`,
      doctorWallet || `wallet-${doctorId}`,
      ipfsHash,
    );

    if (!isDatabaseConnected()) {
      const record = await localDb.createRecord({
        patientId,
        doctorId,
        fileName,
        ipfsHash,
        verified: true,
      });
      res.status(201).json({ record });
      return;
    }

    const record = await Record.create({
      patientId,
      doctorId,
      fileName,
      ipfsHash,
      verified: true,
    });

    const populatedRecord = await Record.findById(record._id)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role');

    res.status(201).json({ record: populatedRecord });
  } catch (error) {
    next(error);
  }
}

async function listRecords(req, res, next) {
  try {
    const filter = {};
    if (req.query.patientId) filter.patientId = req.query.patientId;
    if (req.query.doctorId) filter.doctorId = req.query.doctorId;

    if (!isDatabaseConnected()) {
      const records = await localDb.listRecords(filter);
      res.json({ records });
      return;
    }

    const records = await Record.find(filter)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role')
      .sort({ createdAt: -1 });
    res.json({ records });
  } catch (error) {
    next(error);
  }
}

async function getPatientRecords(req, res, next) {
  try {
    const { patientId } = req.params;
    const records = !isDatabaseConnected()
      ? await localDb.listRecords({ patientId })
      : await Record.find({ patientId })
          .populate('patientId', 'name email role')
          .populate('doctorId', 'name email role')
          .sort({ createdAt: -1 });

    res.json(records.map(formatHistoryRecord));
  } catch (error) {
    next(error);
  }
}

async function addMedicalRecord(req, res, next) {
  try {
    const {
      patientId,
      doctorId,
      patientName,
      condition,
      prescription,
      file,
      fileContent,
    } = req.body;

    if (!patientId || !doctorId || !condition || !prescription) {
      return res.status(400).json({
        message: 'patientId, doctorId, condition, and prescription are required',
      });
    }

    const storedFilePath = await persistBase64File(file || '', fileContent || '');
    const fileName = file || 'record-note.txt';
    const ipfsHash = await uploadFile(fileName);
    await blockchainService.addRecord(
      `wallet-${patientId}`,
      `wallet-${doctorId}`,
      `${patientName || patientId}:${fileName}`,
    );

    if (!isDatabaseConnected()) {
      const record = await localDb.addMedicalRecord({
        patientId,
        doctorId,
        patientName: patientName || 'Patient',
        condition,
        prescription,
        fileName,
        filePath: storedFilePath,
        ipfsHash,
        verified: true,
      });
      return res.status(201).json({ record: formatHistoryRecord(record) });
    }

    const record = await Record.create({
      patientId,
      doctorId,
      patientName: patientName || 'Patient',
      condition,
      prescription,
      fileName,
      filePath: storedFilePath,
      ipfsHash,
      verified: true,
    });
    const populatedRecord = await Record.findById(record._id)
      .populate('patientId', 'name email role')
      .populate('doctorId', 'name email role');
    return res.status(201).json({ record: formatHistoryRecord(populatedRecord) });
  } catch (error) {
    next(error);
  }
}

module.exports = { createRecord, listRecords, getPatientRecords, addMedicalRecord };
