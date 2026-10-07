const { spawnSync } = require('node:child_process');
const { join } = require('node:path');
const assert = require('node:assert/strict');
const probe = join(__dirname, 'probe.cjs');
for (const scenario of ['ready', 'legacy', 'redirect', 'html', 'missing', 'partial']) {
  const script = `
    const assert = require('node:assert/strict');
    process.env.EXECUTOR_CF_ACCESS_CLIENT_ID = 'fake-id';
    process.env.EXECUTOR_CF_ACCESS_CLIENT_SECRET = 'fake-secret';
    delete process.env.HEX_PROVISIONER_ACCESS_CLIENT_ID;
    delete process.env.HEX_PROVISIONER_ACCESS_CLIENT_SECRET;
    if (${JSON.stringify(scenario)} === 'legacy') {
      delete process.env.EXECUTOR_CF_ACCESS_CLIENT_ID;
      delete process.env.EXECUTOR_CF_ACCESS_CLIENT_SECRET;
      process.env.HEX_PROVISIONER_ACCESS_CLIENT_ID = 'fake-id';
      process.env.HEX_PROVISIONER_ACCESS_CLIENT_SECRET = 'fake-secret';
    }
    if (['missing', 'partial'].includes(${JSON.stringify(scenario)})) delete process.env.EXECUTOR_CF_ACCESS_CLIENT_SECRET;
    if (${JSON.stringify(scenario)} === 'partial') {
      process.env.HEX_PROVISIONER_ACCESS_CLIENT_ID = 'fake-id';
      process.env.HEX_PROVISIONER_ACCESS_CLIENT_SECRET = 'fake-secret';
    }
    global.fetch = async (url, options) => {
      assert.equal(url, 'https://exc.binder.sh/api/integrations');
      assert.equal(options.redirect, 'manual');
      assert.equal(options.headers['CF-Access-Client-Secret'], 'fake-secret');
      return {
        ok: ${JSON.stringify(scenario)} !== 'redirect',
        status: ${JSON.stringify(scenario)} === 'redirect' ? 302 : 200,
        headers: { get: () => ${JSON.stringify(scenario)} === 'html' ? 'text/html' : 'application/json' },
        json: async () => [],
      };
    };
    require(${JSON.stringify(probe)});
  `;
  const result = spawnSync(process.execPath, ['-e', script], { encoding: 'utf8' });
  assert.equal(result.status, ['ready', 'legacy'].includes(scenario) ? 0 : 1, result.stderr);
  assert.ok(!(result.stdout + result.stderr).includes('fake-secret'));
}
console.log('PASS: authenticated JSON response required; redirects, HTML and missing tokens rejected');
