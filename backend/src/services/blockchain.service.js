const ledger = new Map();

async function addRecord(patientWallet, doctorWallet, ipfsHash) {
  const current = ledger.get(patientWallet) || [];
  current.push({
    ipfsHash,
    doctor: doctorWallet,
    timestamp: Date.now(),
  });
  ledger.set(patientWallet, current);
  return current[current.length - 1];
}

async function getRecords(patientWallet) {
  return ledger.get(patientWallet) || [];
}

module.exports = { addRecord, getRecords };
