const { GoogleGenAI } = require('@google/genai');

const SYSTEM_PROMPT = `
You are a medical assistant for a telemedicine app.
Provide structured, helpful, safe health suggestions.

Your response must always include these headings:
- Possible condition
- Immediate care
- After care
- Recovery time
- Warning signs

Rules:
- Do not claim certainty or give a formal diagnosis.
- Keep the tone calm, practical, and non-alarming.
- If symptoms could be severe, clearly recommend urgent doctor consultation.
`.trim();

const severeKeywords = [
  'chest pain',
  'breathing issue',
  'breathing problem',
  'difficulty breathing',
  'shortness of breath',
  'unconscious',
  'passed out',
  'severe pain',
];

const languageRules = [
  {
    code: 'ta',
    name: 'Tamil',
    disclaimer: '??? ??????? ???????????? ???????. ?????????? ????????.',
    urgentWarning: '?? ???? ?????????? ????????',
    doctorTerms: ['?????????? ????', '???? ??????????', '??????'],
  },
  {
    code: 'en',
    name: 'English',
    disclaimer: 'This is general guidance. Consult a doctor.',
    urgentWarning: '?? Consult doctor immediately',
    doctorTerms: ['consult a doctor', 'urgent', 'emergency', 'seek medical'],
  },
];

function createClient() {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error(
      'GEMINI_API_KEY is missing. Add it to the backend environment before using /chat.',
    );
  }

  return new GoogleGenAI({ apiKey });
}

function hasSevereSymptoms(message) {
  const normalized = message.trim().toLowerCase();
  return severeKeywords.some((keyword) => normalized.includes(keyword));
}

function detectRequestedLanguage(message) {
  const normalized = message.trim().toLowerCase();
  if (
    normalized.includes('tamil') ||
    message.includes('?????') ||
    message.includes('???????')
  ) {
    return languageRules[0];
  }
  return languageRules[1];
}

function buildPrompt(message, language) {
  return `${message}\n\nReply entirely in ${language.name}. Translate the section headings into ${language.name}. End with exactly this disclaimer in ${language.name}:\n${language.disclaimer}`;
}

function ensureDisclaimer(text, language) {
  if (text.includes(language.disclaimer)) {
    return text;
  }
  return `${text.trim()}\n\n${language.disclaimer}`;
}

function ensureUrgentWarning(text, language) {
  if (text.includes(language.urgentWarning)) {
    return text;
  }
  return `${language.urgentWarning}\n\n${text.trim()}`;
}

async function generateChatResponse(message) {
  const client = createClient();
  const isSevere = hasSevereSymptoms(message);
  const language = detectRequestedLanguage(message);

  let response;
  try {
    response = await client.models.generateContent({
      model: process.env.GEMINI_MODEL || 'gemini-2.5-flash',
      contents: buildPrompt(message, language),
      config: {
        systemInstruction: SYSTEM_PROMPT,
        temperature: 0.5,
      },
    });
  } catch (error) {
    const status = error?.status || error?.code;
    if (status === 429) {
      throw new Error(
        'Google AI API quota exceeded for the configured key. Check limits or use another API key.',
      );
    }
    if (status === 401 || status === 403) {
      throw new Error(
        'Google AI API key is invalid or blocked. Update GEMINI_API_KEY in the backend.',
      );
    }
    throw error;
  }

  let reply = response?.text?.trim() || '';
  if (!reply) {
    throw new Error('The AI service returned an empty response.');
  }

  reply = ensureDisclaimer(reply, language);
  if (isSevere) {
    reply = ensureUrgentWarning(reply, language);
  }

  const normalizedReply = reply.toLowerCase();
  const shouldConsultDoctor =
    isSevere || language.doctorTerms.some((term) => normalizedReply.includes(term.toLowerCase()));

  return {
    reply,
    replyLanguage: language.code,
    shouldConsultDoctor,
    isSevere,
  };
}

module.exports = {
  generateChatResponse,
};
