// Minimal JS utilities for Maestro (Rhino/GraalJS)
// See: https://docs.maestro.dev/advanced/javascript/make-http-s-requests
(function () {
  function mustEnv(name) {
    var v = env[name];
    if (!v || ("" + v).trim() === "") {
      throw "Missing env var: " + name;
    }
    return "" + v;
  }

  var ACTION = (env.ACTION || "ping") + "";
  var BASE = (env.WIREMOCK_BASE || "http://127.0.0.1:8080") + "";

  function get(url) { return http.get(url); }
  function post(url, body) { return http.post(url, { body: body ? JSON.stringify(body) : "" }); }

  if (ACTION === "ping") {
    var resp = get(BASE + "/__admin/mappings");
    output.wiremock = { ok: resp.status === 200 };
    console.log("WireMock ping: " + resp.status);
    return;
  }

  if (ACTION === "resetRequests") {
    var r = post(BASE + "/__admin/requests/reset", {});
    console.log("WireMock reset requests: " + r.status);
    output.wiremock = { resetRequests: r.status };
    return;
  }

  if (ACTION === "assertRequests") {
    var min = parseInt(env.MIN_COUNT || "1", 10);
    var resp = get(BASE + "/__admin/requests");
    if (resp.status !== 200) throw "Failed to query requests, status=" + resp.status;
    var data = json(resp.body);
    var count = (data && data.requests) ? data.requests.length : 0;
    console.log("WireMock requests seen: " + count);
    if (count < min) throw "Expected at least " + min + " requests, got " + count;
    output.wiremock = { requestCount: count };
    return;
  }

  throw "Unknown ACTION=" + ACTION;
})();
