const fs = require('fs/promises');
const path = require('path');

const localDb = require('../services/local-db.service');

const recordingsDir = path.join(__dirname, '..', '..', 'uploads', 'recordings');

async function ensureRecordingsDir() {
  await fs.mkdir(recordingsDir, { recursive: true });
}

async function uploadRecording(req, res, next) {
  try {
    const { patientId, doctorId, duration, date, fileName, fileContent } = req.body;
    if (!patientId || !doctorId || !fileName || !fileContent) {
      return res.status(400).json({
        message: 'patientId, doctorId, fileName, and fileContent are required',
      });
    }

    await ensureRecordingsDir();
    const safeFileName = `${Date.now()}-${fileName.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
    const normalized = fileContent.includes(',')
      ? fileContent.split(',').pop()
      : fileContent;
    await fs.writeFile(
      path.join(recordingsDir, safeFileName),
      Buffer.from(normalized, 'base64'),
    );

    const recording = await localDb.createRecording({
      patientId,
      doctorId,
      filePath: `/uploads/recordings/${safeFileName}`,
      fileName: safeFileName,
      duration: duration || 0,
      date: date || new Date().toISOString(),
    });

    return res.status(201).json({ recording });
  } catch (error) {
    return next(error);
  }
}

async function listRecordings(req, res, next) {
  try {
    const { patientId } = req.params;
    const recordings = await localDb.listRecordings({ patientId });
    return res.json({ recordings });
  } catch (error) {
    return next(error);
  }
}

module.exports = { uploadRecording, listRecordings };
