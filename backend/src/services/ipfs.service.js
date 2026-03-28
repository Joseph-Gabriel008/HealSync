const crypto = require('crypto');

async function uploadFile(fileName) {
  if (!fileName) {
    throw new Error('fileName is required for IPFS upload');
  }

  // Replace this mock with Pinata SDK or direct upload when API keys are available.
  const hash = crypto.createHash('sha256').update(`${fileName}-${Date.now()}`).digest('hex');
  return `Qm${hash.slice(0, 44)}`;
}

module.exports = { uploadFile };
