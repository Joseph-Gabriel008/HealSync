const User = require('../models/user.model');
const crypto = require('crypto');
const localDb = require('../services/local-db.service');
const { isDatabaseConnected } = require('../config/db');

function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

async function listUsers(req, res, next) {
  try {
    const filter = {};
    if (req.query.role) {
      filter.role = req.query.role;
    }

    const users = isDatabaseConnected()
      ? await User.find(filter).sort({ createdAt: -1 })
      : await localDb.listUsers(filter);
    return res.json({ users });
  } catch (error) {
    return next(error);
  }
}

async function signup(req, res, next) {
  try {
    const { name, email, role, password } = req.body;
    if (!password) {
      return res.status(400).json({ message: 'Password is required' });
    }

    const normalizedRole = `${role ?? ''}`.trim().toLowerCase();
    if (!['patient', 'doctor'].includes(normalizedRole)) {
      return res.status(400).json({ message: 'Invalid role selected' });
    }

    const normalizedEmail = email.toLowerCase();
    const existing = isDatabaseConnected()
      ? await User.findOne({ email: normalizedEmail })
      : await localDb.findUserByEmail(normalizedEmail);
    if (existing) {
      return res.status(409).json({ message: 'User already exists' });
    }

    if (isDatabaseConnected()) {
      const user = await User.create({
        name,
        email: normalizedEmail,
        role: normalizedRole,
        passwordHash: hashPassword(password),
      });
      const sanitizedUser = user.toObject();
      delete sanitizedUser.passwordHash;
      return res.status(201).json({ user: sanitizedUser });
    }

    const user = await localDb.createUser({
      name,
      email: normalizedEmail,
      role: normalizedRole,
      passwordHash: hashPassword(password),
    });
    return res.status(201).json({ user });
  } catch (error) {
    return next(error);
  }
}

async function login(req, res, next) {
  try {
    const { email, password, role } = req.body;
    if (!password) {
      return res.status(400).json({ message: 'Password is required' });
    }

    const normalizedRole = role ? `${role}`.trim().toLowerCase() : null;
    const normalizedEmail = email.toLowerCase();
    const user = isDatabaseConnected()
      ? await User.findOne({ email: normalizedEmail }).select('+passwordHash')
      : await localDb.findUserByEmail(normalizedEmail, { includePasswordHash: true });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (normalizedRole && `${user.role}`.trim().toLowerCase() !== normalizedRole) {
      return res.status(401).json({ message: 'Incorrect role selected' });
    }

    if (user.passwordHash !== hashPassword(password)) {
      return res.status(401).json({ message: 'Incorrect password' });
    }

    const sanitizedUser = isDatabaseConnected() ? user.toObject() : { ...user };
    delete sanitizedUser.passwordHash;
    return res.json({ user: sanitizedUser });
  } catch (error) {
    return next(error);
  }
}

function resolveProfileUserId(req) {
  const headerId = req.header('x-user-id');
  if (headerId && headerId.trim()) {
    return headerId.trim();
  }

  const bodyId = req.body?.userId;
  if (bodyId && `${bodyId}`.trim()) {
    return `${bodyId}`.trim();
  }

  const queryId = req.query?.userId;
  if (queryId && `${queryId}`.trim()) {
    return `${queryId}`.trim();
  }

  return null;
}

async function getProfile(req, res, next) {
  try {
    const userId = resolveProfileUserId(req);
    if (!userId) {
      return res.status(400).json({ message: 'User id is required' });
    }

    const user = isDatabaseConnected()
      ? await User.findById(userId)
      : await localDb.findUserById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    return res.json({ user });
  } catch (error) {
    return next(error);
  }
}

async function updateProfile(req, res, next) {
  try {
    const userId = resolveProfileUserId(req);
    if (!userId) {
      return res.status(400).json({ message: 'User id is required' });
    }

    const { name, phone, age, gender, medicalHistory, specialization } = req.body;
    const normalizedAge =
      age === '' || age === null || age === undefined ? null : Number(age);
    if (normalizedAge !== null && Number.isNaN(normalizedAge)) {
      return res.status(400).json({ message: 'Age must be a valid number' });
    }

    const updates = {
      name: typeof name === 'string' && name.trim() ? name.trim() : undefined,
      phone: typeof phone === 'string' ? phone.trim() : undefined,
      age: normalizedAge,
      gender: typeof gender === 'string' ? gender.trim() : undefined,
      medicalHistory:
        typeof medicalHistory === 'string' ? medicalHistory.trim() : undefined,
      specialization:
        typeof specialization === 'string' ? specialization.trim() : undefined,
    };

    Object.keys(updates).forEach((key) => {
      if (updates[key] === undefined) {
        delete updates[key];
      }
    });

    let user;
    if (isDatabaseConnected()) {
      user = await User.findByIdAndUpdate(userId, updates, {
        new: true,
        runValidators: true,
      });
    } else {
      user = await localDb.updateUserProfile(userId, updates);
    }

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    return res.json({ user });
  } catch (error) {
    return next(error);
  }
}

module.exports = { listUsers, signup, login, getProfile, updateProfile };
