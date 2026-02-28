import "dotenv/config";

// Import the framework and instantiate it
import Fastify from "fastify";
const fastify = Fastify({
  logger: true,
});

// Declare a route
fastify.get("/", async function handler() {
  return { hello: "world" };
});

// Run the server!
try {
  await fastify.listen({ port: Number(process.env.PORT) || 8081 });
} catch (err) {
  fastify.log.error(err);
  process.exit(1);
}
