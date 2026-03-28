require('dotenv').config();

const app = require('./app');
const { connectDatabase } = require('./config/db');

const PORT = process.env.PORT || 5000;

async function start() {
  await connectDatabase();
  app.listen(PORT, () => {
    console.log(`HealSync API listening on port ${PORT}`);
  });
}

start().catch((error) => {
  console.error('Unable to start HealSync backend', error);
  process.exit(1);
});
