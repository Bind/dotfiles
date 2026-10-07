// Readiness requires an authenticated application response, not an Access redirect.
async function main() {
  const useRuntime = Boolean(process.env.EXECUTOR_CF_ACCESS_CLIENT_ID || process.env.EXECUTOR_CF_ACCESS_CLIENT_SECRET);
  const id = useRuntime ? process.env.EXECUTOR_CF_ACCESS_CLIENT_ID : process.env.HEX_PROVISIONER_ACCESS_CLIENT_ID;
  const secret = useRuntime ? process.env.EXECUTOR_CF_ACCESS_CLIENT_SECRET : process.env.HEX_PROVISIONER_ACCESS_CLIENT_SECRET;
  if (!id || !secret) throw new Error('Missing a complete Cloudflare Access credential pair. Next: add EXECUTOR_CF_ACCESS_CLIENT_ID and EXECUTOR_CF_ACCESS_CLIENT_SECRET to the encrypted Sutro .env on an authorized Mac, then transfer its updated keys if needed. Existing HEX_PROVISIONER_ACCESS_CLIENT_ID and HEX_PROVISIONER_ACCESS_CLIENT_SECRET also work.');
  const response = await fetch('https://exc.binder.sh/api/integrations', {
    headers: { 'CF-Access-Client-Id': id, 'CF-Access-Client-Secret': secret },
    redirect: 'manual',
    signal: AbortSignal.timeout(15000),
  });
  if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
    throw new Error(`Executor readiness failed: HTTP ${response.status}. Next: ask the hosted Executor administrator to check Access policy and token expiry, then rerun 07-check.sh.`);
  }
  await response.json();
  console.log('dotenvx decryption and authenticated remote Executor API: ready');
}
main().catch((error) => { console.error(error.message); process.exitCode = 1; });
