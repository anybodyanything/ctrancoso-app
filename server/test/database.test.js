const request = require("supertest");
require('dotenv').config();
const db = require("../src/db");
const { createApp } = require("../src/app");

describe("GET /api/db-time", () => {
  it("should respond ok=true and timestamp", async () => {
    const app = createApp();
    const response = await request(app).get("/api/db-time").expect(200);

    expect(response.body).toHaveProperty("ok", true);
    expect(response.body.dbTime).toBeDefined();

    const timestamp = new Date(response.body.dbTime);
    expect(timestamp.toISOString()).toBe(response.body.dbTime);
  });
});
