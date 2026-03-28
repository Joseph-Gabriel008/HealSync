const express = require('express');
const controller = require('../controllers/auth.controller');

const router = express.Router();

router.get('/users', controller.listUsers);
router.get('/profile', controller.getProfile);
router.put('/profile', controller.updateProfile);
router.post('/signup', controller.signup);
router.post('/login', controller.login);

module.exports = router;
