const { generateChatResponse } = require('../services/chat.service');

async function chat(req, res, next) {
  try {
    const message = req.body?.message?.toString().trim() || '';
    if (!message) {
      return res.status(400).json({ message: 'Message is required.' });
    }

    const result = await generateChatResponse(message);
    return res.json(result);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  chat,
};
