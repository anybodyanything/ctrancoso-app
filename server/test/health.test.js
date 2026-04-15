const request = require("supertest");
const { createApp } = require("../src/app");

describe("GET /api/health", () => {
  it("should respond ok=true and service", async () => {
    const app = createApp();

    const res = await request(app).get("/api/health").expect(200);

    expect(res.body).toHaveProperty("ok", true);
    expect(res.body).toHaveProperty("service", "ctrancoso-server");
    expect(typeof res.body.now).toBe("string");
  });
});
