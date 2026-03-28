const { listDoctors } = require('../services/doctor-catalog.service');

async function getDoctors(req, res, next) {
  try {
    const doctors = listDoctors({
      category: req.query.category,
      search: req.query.search,
    });
    return res.json({ doctors });
  } catch (error) {
    return next(error);
  }
}

module.exports = { getDoctors };
