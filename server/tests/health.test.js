const request = require('supertest');
const { createApp } = require('../app');

describe('GET /api/health', () => {
  let app;

  beforeAll(() => {
    process.env.BASE_API_URL = process.env.BASE_API_URL || 'api';
    process.env.NO_DB = 'true'; // avoid DB requirement in unit test
    app = createApp();
  });

  it('responds with ok and db state', async () => {
    const res = await request(app).get(`/${process.env.BASE_API_URL}/health`);
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('ok', true);
    expect(res.body).toHaveProperty('db');
  });
});
