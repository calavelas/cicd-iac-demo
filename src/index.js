const lynx = require('lynx');

// instantiate a metrics client
// Use an environment variable for the metrics server host
const metricsServerHost = process.env.metricServerHost || 'localhost'; // Fallback to 'localhost' if not set
const metrics = new lynx(metricsServerHost, 8125);

// sleep for a given number of milliseconds
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {

  // Log the metric value
  const delayValue = Math.random() * 1000;
  console.log(`Sending metric 'test.core.delay' with value: ${delayValue}`);

  // send message to the metrics server
  metrics.timing('test.core.delay', Math.random() * 1000);

  // sleep for a random number of milliseconds to avoid flooding metrics server
  return sleep(3000);
}

// infinite loop
(async () => {
  console.log("🚀🚀🚀");
  while (true) { await main() }
})()
  .then(console.log, console.error);