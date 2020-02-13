---
title: "Getting Up to Hijinks With Cloudflare Workers"
description: "Cloudflare has a serverless offering, let's explore!"
date: 2020-02-13T12:00:00.000Z
# cover: ""
# utterances: 0
---

You may have heard of [Cloudflare Workers](https://workers.dev), a product from Cloudflare that lets you run JavaScript/WebAssembly in a serverless fashion on Cloudflare's edge network.

<!--more-->

## Middleware

<!--  -->

- Make sure you enable the "fail through" option, so if you exceed the limit requests to your website bypass the now unavailable worker to send requests to your site.
- `FetchEvent.waitUntil()` lets us run the logging request asynchronously so that it doesn't block the response to our user.

## Echoing requests to Slack

<!-- https://api.slack.com/messaging/webhooks -->

## Getting cheeky with isolate persistence

<!-- https://developers.cloudflare.com/workers/about/how-it-works/ -->

> Because of this, it is generally advised that you not store mutable state in your global scope unless you have accounted for this contingency.

Something something although generally inadvisable, we can make use of this. It makes sense why it exists, statelessness and whatnot.

So long as you hit the same node/isolate and the isolate is not discarded, the counter will keep incrementing.

<!-- https://counter.nchlswhttkr.workers.dev -->

So how can we make use of it? Caching a response so we don't even have to rely on Cloudflare's CDN!
