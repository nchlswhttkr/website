---
title: "Getting Up to Hijinks With Cloudflare Workers"
description: "Cloudflare has a serverless offering, let's explore!"
date: 2020-02-13T12:00:00.000Z
# cover: ""
# utterances: 0
---

You may have heard of [Workers](https://workers.dev), a product from Cloudflare that lets you run JavaScript/WebAssembly in a serverless fashion on Cloudflare's edge network.

<!--more-->

## What does serverless mean?

Explaining the ins-and-outs of the [serverless model](https://en.wikipedia.org/wiki/Serverless_computing) is a post in an of itself, but I'll try to cover the important bits here.

Compared to the traditional self-hosted servers or virtual machines from cloud providers, serverless applications are spun up "on-demand". This makes them much faster and easier to scale, and allows them to "scale to zero" when there is no traffic. They can encounter significant latency problems when a new instance arises from a "cold start" or when an existing instance is resumed.

Serverless environments usually assume statelessness. You cannot assume memory will persist after a call (for example, sessions). If information needs to persist, you need to rely on some form of external store/database.

The runtime is usually abstracted away to the provider. Instead of worrying about sysadmin work, you can focus on shipping code. You sacrifice control over the runtime for this. Your application is a self-contained blob of code that accepts and responds to incoming requests.

## How do Cloudflare Workers operate?

I think the [Introduction to Workers](https://developers.cloudflare.com/workers/about/how-it-works/) does a great job of summarising, but for the sake of brevity there are few key points to focus on.

- The machines of Cloudlfare's edge network host an instance of the Workers runtime, which uses [Google's V8 engine](https://v8.dev).
- Instead of containerised processes, a Workers scripts are run in V8 _Isolates_, akin to sandboxes, which share a single V8 runtime.
- While this architecture has benefits in terms of performance, the stateless principles of serverless still apply.

The script for a worker has some fairly light boilerplate, setting up an event listener to respond to incoming requests.

```js
addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request));
});

/**
 * Respond to the request
 * @param {Request} request
 */
async function handleRequest(request) {
  return new Response("hello world", { status: 200 });
}
```

So, perhaps in order of increasing insanity, I present several uses for Workers!

## Middleware

In Cloudflare's architecture, Workers sit at the frontline to handle requests (aside from certain WAF-related page rules). This puts them in the ideal position to act a middleware for requests.

As requests come in, a worker can intercept the request and do many things.

- Reject a request for failing to meet requirements (lacking authorisation, insecure/outdated TLS, invalid format for your web-facing API).
- Proxy/direct requests based on metadata/cookies (A/B testing, redirect international visitors to a localized version of your website).
- Modify a response from your origin, such as changing headers for caching purposes.
- Log/monitor traffic without client-side analytics

I think the last use case is very convenient. Say I wanted to record visits to all of my blog posts to gauge popularity of time. I could set up a worker to run on all requests to `/blog/...` routes that logs all requests for each post.

Here's a rough example.

```js
addEventListener("fetch", event => {
  event.passThroughOnException();
  event.respondWith(handleRequest(event));
});

const matcher = /^\/blog\/([a-z0-9-]+)\/(index.html)?$/;

async function handleRequest(event) {
  const m = new URL(event.request.url).pathname.match(matcher);
  if (m !== null) {
    event.waitUntil(
      fetch("<logging-url>", {
        method: "POST",
        body: m[1]
      })
    );
  }

  return fetch(event);
}
```

I can then set this up to run for all requests to `/blog/...` routes in Cloudflare for my site.

![The configuration to run the logging worker on a blog routes,  with  the failure mode set to "fail open"](./logging-worker.png)

There's a few particularly nice features I like here.

- The "fail open" configuration for this route ensures responses are still served from my origin even if I exceed the daily limit of 100,00 requests (of the free tier).
- Similarly, `FetchEvent.passThroughOnException()` means Cloudflare will fall back to my origin if the scripts throws an error at runtime.
- Logging requests do not block the response to a client, as `FetchEvent.waitUntil()` allows work to continue after the handler has returned.

Seeing as Cloudflare already sits between your origin servers and your users, it seems fitting to host your middleware with them.

## Echoing requests to Slack

I've been doing a bit of work involving webhooks lately, so I though it would be useful to have a quick URL I can chuck in for debugging purposes.

Slack allows you to make apps for your own workspaces, so I went an made an echoing app and added it to my private workspace. From here you can generate [incoming message webhook](https://api.slack.com/messaging/webhooks), and this will allow your app to post messages to a nominated channel when you make a request to this URL.

Let's go ahead and write up a Worker to accept requests and echo the headers and body to Slack. I've stripped away the error-handling logic here so it's a bit barebones.

```js
addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  // Grab content from the request
  const DATE = new Date().toISOString();
  const PATH = "/" + request.url.split("/")[4];
  const HEADERS = Array.from(request.headers.entries())
    .map(([key, value]) => `${key.padEnd(24, " ")}\t${value}`)
    .join("\n");
  const BODY = await request.text();

  // Format into a nice message for Slack
  const text = `
New request to \`${PATH}\` at \`${DATE}\`

Headers
\`\`\`
${HEADERS}
\`\`\`

Body
\`\`\`
${BODY}
\`\`\`
`;

  // Post to our #echo Slack channel
  await fetch(ENV_SLACK_INCOMING_MESSAGE_URL, {
    method: "POST",
    headers: {
      "Content-type": "application/json"
    },
    body: JSON.stringify({ text })
  });

  return new Response("Accepted", { status: 201 });
}
```

There's just one problem here. How do we keep our secret value like the Slack incoming message URL hidden? If it's made public, anyone will be able to post to my Slack channel!

> Aside: Since I've started writing this post, Cloudflare have added the ability to [manage environment variables and secrets](https://blog.cloudflare.com/workers-secrets-environment/) through their CLI and dashboard. Although this next bit is redundant, I've left it in because it's an interesting solution.

Luckily, Cloudflare Workers support an optional build step before being deployed. It will run [Webpack](https://webpack.js.org/) and publish the resulting output instead.

I took this as an opportunity to write a small [Babel](https://babeljs.io/) loader that would step through my code and replace any matching identifier with their environment variable counterpart. So long as these variables were available at build time, they would be available in the published worker.

You can see the loader in action in this example. Here's what a snippet of code looks like locally.

```js
if (!request.url.includes(ENV_SECRET_KEY)) {
  return new Response("Must provide a valid SECRET", { status: 400 });
}
```

Compared to how it looks in the published worker. In this case, `ENV_SECRET_KEY` has been replace with a secret.

![An identical snippet of code, but a variable has been replace with a string — a secret value](./published-secret.png)

## Getting cheeky with isolate persistence

A little bit of reading on [how Cloudflare Workers is set up](https://developers.cloudflare.com/workers/about/how-it-works/) will glean these interesting snippets about the Isolate-based approach.

> A given isolate has its own scope, but isolates are not necessarily long-lived. An isolate may be spun down and evicted for a number of reasons.

> Because of this, it is generally advised that you not store mutable state in your global scope unless you have accounted for this contingency.

Because our script is set up as a listener for `fetch` requests, we can have it access variables outside of its scope.

It's reasonable why leveraging this capability isn't recommended, since it goes against the principle of statelessness that accompanies serverless solutions.

However, we _can_ do it nonetheless! Let's look at a basic example.

```js
addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request));
});

let counter = 0;
async function handleRequest(request) {
  return new Response(`<h1>${++counter} request/s made!</h1>`, {
    status: 200,
    headers: {
      "Content-Type": "text/html"
    }
  });
}
```

This gives us an [incrementing counter](https://counter.nchlswhttkr.workers.dev/). Everytime a request is made the the worker, the counter is incremented.

So long as you hit the same node/isolate and the isolate is not discarded, the counter will keep incrementing.

A more practical use might be in storing responses from the web, saving further roundtrips. I'd question whether the potential performance gains are worth it, when it might result in a stale state. It's worth noting that caching is available through [Cloudflare's CDN and Cache API](https://developers.cloudflare.com/workers/about/using-cache/).

## A verdict

I like Cloudflare Workers.

BLAH BLAH BLAH OPINIONS

I hope you've found these uses for Cloudflare Workers interesting. You can find most of the code from this post in my [repo of workers](https://github.com/nchlswhttkr/workers) on GitHub.
