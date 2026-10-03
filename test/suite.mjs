export async function suite(h) {
  const token = await h.token();
  const c = await h.deploy("TokenSplitter", [
    token.target,
    [h.addresses[1], h.addresses[2]],
    [1, 3],
    h.addresses[0],
  ]);
  await h.tx(token.approve(c.target, 10000));
  await h.tx(c.fund(1000));
  await h.test("immutable weighted entitlements", async () => {
    h.eq(await c.claimable(h.addresses[1]), 250n);
    h.eq(await c.claimable(h.addresses[2]), 750n);
  });
  await h.test("third-party release cannot redirect", async () => {
    await h.tx(c.release(h.addresses[1]));
    h.eq(await token.balanceOf(h.addresses[1]), 250n);
  });
  await h.test("empty repeated release rejected", () =>
    h.revert(() => c.release(h.addresses[1])),
  );
  await h.test("nonpayee cannot claim", () =>
    h.revert(() => c.release(h.addresses[3])),
  );
  await h.test("new funding preserves cumulative shares", async () => {
    await h.tx(c.fund(400));
    h.eq(await c.claimable(h.addresses[1]), 100n);
    h.eq(await c.claimable(h.addresses[2]), 1050n);
  });
  await h.test("pause does not freeze release", async () => {
    await h.tx(c.setPaused(true));
    await h.tx(c.release(h.addresses[2]));
    h.eq(await token.balanceOf(h.addresses[2]), 1050n);
  });
}
