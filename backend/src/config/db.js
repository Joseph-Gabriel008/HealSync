const mongoose = require('mongoose');

function isDatabaseConnected() {
  return mongoose.connection.readyState === 1;
}

async function connectDatabase() {
  const mongoUri = process.env.MONGO_URI;
  if (!mongoUri) {
    console.warn('MONGO_URI not provided. Backend will start without a database connection.');
    return;
  }

  try {
    await mongoose.connect(mongoUri);
    console.log('MongoDB connected');
  } catch (error) {
    console.warn('MongoDB connection failed. Continuing in degraded demo mode.');
    console.warn(error.message);
  }
}

module.exports = { connectDatabase, isDatabaseConnected };
