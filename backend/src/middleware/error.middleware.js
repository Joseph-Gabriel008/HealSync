function notFound(req, res, _next) {
  res.status(404).json({ message: `Route not found: ${req.originalUrl}` });
}

function errorHandler(error, _req, res, _next) {
  console.error(error);
  res.status(500).json({
    message: error.message || 'Unexpected server error',
  });
}

module.exports = { notFound, errorHandler };
