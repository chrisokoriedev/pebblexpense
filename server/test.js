const http = require('http');
const app = require('./server');

const TEST_PORT = 3001;

async function runTests() {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(TEST_PORT, resolve));
  const baseUrl = `http://127.0.0.1:${TEST_PORT}`;

  console.log(`Test server running at ${baseUrl}`);
  let passed = 0;
  let failed = 0;

  function assert(condition, name) {
    if (condition) {
      console.log(`✓ ${name}`);
      passed++;
    } else {
      console.error(`✗ ${name}`);
      failed++;
    }
  }

  const testBucket = `test_${Date.now()}`;

  try {
    // 1. GET /api/:bucket/expenses (new bucket pre-populated)
    const listRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`);
    const listData = await listRes.json();
    assert(listRes.status === 200, 'GET list returns 200');
    assert(Array.isArray(listData.expenses), 'Response has expenses array');
    assert(listData.expenses.length > 0, 'New bucket is pre-populated with sample expenses');
    assert(listData.expenses[0].id.startsWith('exp_'), 'Sample expense ID has exp_ prefix');

    const firstSample = listData.expenses[0];

    // 2. GET /api/:bucket/expenses/:id
    const singleRes = await fetch(`${baseUrl}/api/${testBucket}/expenses/${firstSample.id}`);
    const singleData = await singleRes.json();
    assert(singleRes.status === 200, 'GET single expense returns 200');
    assert(singleData.id === firstSample.id, 'Single expense matches requested ID');

    // 3. GET unknown ID -> 404
    const notFoundRes = await fetch(`${baseUrl}/api/${testBucket}/expenses/exp_unknown123`);
    const notFoundData = await notFoundRes.json();
    assert(notFoundRes.status === 404, 'GET unknown expense returns 404');
    assert(notFoundData.error === 'expense not found', 'GET 404 returns structured error');

    // 4. POST /api/:bucket/expenses (valid)
    const postRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Lunch with team',
        amountKobo: 450000,
        category: 'Food'
      })
    });
    const postData = await postRes.json();
    assert(postRes.status === 201, 'POST returns 201 Created');
    assert(postData.id && postData.id.startsWith('exp_'), 'POST generates exp_ id');
    assert(postData.title === 'Lunch with team', 'POST title matches');
    assert(postData.amountKobo === 450000, 'POST amountKobo matches');
    assert(postData.category === 'Food', 'POST category matches');
    assert(typeof postData.createdAt === 'string', 'POST has ISO createdAt timestamp');

    // 5. POST validation: empty title
    const badTitleRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: '   ',
        amountKobo: 1000,
        category: 'Food'
      })
    });
    const badTitleData = await badTitleRes.json();
    assert(badTitleRes.status === 400, 'Empty title rejected with 400');
    assert(badTitleData.error === 'title is required', 'Empty title error contract matches');

    // 6. POST validation: invalid amountKobo
    const badAmountRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Snack',
        amountKobo: -50,
        category: 'Food'
      })
    });
    assert(badAmountRes.status === 400, 'Negative amountKobo rejected with 400');

    // 7. POST validation: non-integer amountKobo
    const floatAmountRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Snack',
        amountKobo: 50.5,
        category: 'Food'
      })
    });
    assert(floatAmountRes.status === 400, 'Float amountKobo rejected with 400');

    // 8. POST validation: invalid category
    const badCatRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Snack',
        amountKobo: 5000,
        category: 'RandomCategory'
      })
    });
    assert(badCatRes.status === 400, 'Invalid category rejected with 400');

    // 9. POST with null category
    const nullCatRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Miscellaneous',
        amountKobo: 5000,
        category: null
      })
    });
    const nullCatData = await nullCatRes.json();
    assert(nullCatRes.status === 201, 'Null category accepted with 201');
    assert(nullCatData.category === null, 'Category saved as null');

    // 10. DELETE /api/:bucket/expenses/:id
    const deleteRes = await fetch(`${baseUrl}/api/${testBucket}/expenses/${postData.id}`, {
      method: 'DELETE'
    });
    assert(deleteRes.status === 204, 'DELETE existing expense returns 204');

    // 11. DELETE again -> 404
    const deleteAgainRes = await fetch(`${baseUrl}/api/${testBucket}/expenses/${postData.id}`, {
      method: 'DELETE'
    });
    assert(deleteAgainRes.status === 404, 'DELETE non-existent expense returns 404');

    // 12. X-Force-Error: 500
    const forceErrRes = await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      headers: { 'X-Force-Error': '500' }
    });
    const forceErrData = await forceErrRes.json();
    assert(forceErrRes.status === 500, 'X-Force-Error returns 500');
    assert(forceErrData.error === 'internal error', 'X-Force-Error returns structured internal error');

    // 13. X-Delay: 200
    const start = Date.now();
    await fetch(`${baseUrl}/api/${testBucket}/expenses`, {
      headers: { 'X-Delay': '200' }
    });
    const elapsed = Date.now() - start;
    assert(elapsed >= 180, `X-Delay waited at least ~200ms (waited ${elapsed}ms)`);

    // 14. Unknown route -> 404
    const unknownRouteRes = await fetch(`${baseUrl}/api/unknown/something`);
    assert(unknownRouteRes.status === 404, 'Unknown route returns 404');

  } catch (err) {
    console.error('Test execution error:', err);
    failed++;
  } finally {
    server.close();
  }

  console.log(`\nTests finished: ${passed} passed, ${failed} failed.`);
  if (failed > 0) process.exit(1);
}

runTests();
