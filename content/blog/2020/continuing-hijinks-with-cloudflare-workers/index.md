---
title: "Continuing Hijinks With Cloudflare Workers"
description: "Once was not enough, so did more experimenting!"
date: 2020-05-24T12:00:00+1000
tags:
    - cloudflare
    - golang
    - javascript
    - serverless
series: "cloudflare-workers-hijinks"
---

A while back I wrote about a few things I'd been trying with [Cloudflare Workers](https://workers.dev/). I've been trying a few more things since then, so now I can dive into even more uses for Cloudflare Workers!

<!--more-->

Once again, you can find the code for these workers on my [GitHub repo](https://github.com/nchlswhttkr/)!

### Running Go on a worker

At the moment, the documentation around running WebAssembly on a worker only covers Rust, C and C++. It seems reasonable that we'd be able to run anything that compiles to WASM though, so how about Go?

I started digging around, and ended up with this rough proof of concept. A little bit of Go, with a little JavaScript to stick it together.

```go
package main

var called = 0

func main() {
    called++
    println("Hello from TinyGo! Called", called, "times so far!")
}

//export multiply
func multiply(x, y int) int {
    return x * y
}

//export runSayHello
func runSayHello() {
    sayHello()
}

func sayHello()
```

```js
require("./polyfill_performance.js");
require("./wasm_exec.js");

addEventListener("fetch", (event) => {
    event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
    // Create our instance, with an imported function
    const go = new Go();
    go.importObject.env["main.go.sayHello"] = () => {
        console.log("Hello from the imported function!");
    };
    const instance = await WebAssembly.instantiate(WASM, go.importObject);

    // Memory for this instance persists between runs
    go.run(instance); // Hello from TinyGo! Called 1 times so far
    go.run(instance); // Hello from TinyGo! Called 1 times so far

    // We can use its exported functions
    console.log(instance.exports.multiply(2, 2)); // 4
    console.log(instance.exports.multiply(3, 4)); // 12

    // Our Golang has access to the imported function
    instance.exports.runSayHello(); // Hello from the imported function!

    // Take query params to the worker and show a result
    let a = Number(new URL(request.url).searchParams.get("a"));
    let b = Number(new URL(request.url).searchParams.get("b"));
    if (Number.isNaN(a) || Number.isNaN(b)) {
        return new Response("Make sure a and b are numbers\n", { status: 400 });
    }
    const product = instance.exports.multiply(a, b);
    return new Response(`${a} x ${b} = ${product}\n`, { status: 200 });
}
```

It turns out there's quite a few things we can accomplish here:

-   Bind JavaScript functions for Go to use (like `sayHello()`)
-   Access exported functions from our Go instance (like `multiply()` and `runSayHello()`)
-   Run our Go much like a regular program

There's a few things I discovered along the way that are worth digging into.

Go-as-WASM relies on several JavaScript bindings at runtime, which come bundled with the standard toolchain. That's the `wasm_exec.js` file you see imported at the top of the worker's JavaScript.

I opted to use [TinyGo](https://tinygo.org/) for this instead of the main Go toolchain. Cloudflare has a [hard limit of 1MB](https://developers.cloudflare.com/workers/about/limits/#script-size) on scripts and bindings (like our WASM), and while Go's "Hello world!" only comes to ~350KB gzipped, it's a lot of uneccessary bloat when alternatives exist. At the moment, the web editor also displays an unknown error (`10013`?) when handling plain Go rather than TinyGo.

The runtime environment can be a bit unpredictable. You'll find yourself needing to polyfill a few things, like the [Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance), because Cloudflare [does not allow scripts to measure their runtime](https://developers.cloudflare.com/workers/about/security/).

In terms of imports/exports, my understanding is that exports need to be explicit to the compiler (hence `//exports multiply`), and imported functions should have a declaration, but no body.

I'm sure there's more to dig into here, but I'm happy enough to just have my Go snippet running on a worker!

```sh
curl 'https://experimental-golang-worker.nchlswhttkr.workers.dev/?a=23&b=4'
# 23 x 4 = 92
```

If Go, Rust, C or C++ aren't quite your flavour though, you'll be glad to know that [COBOL](https://blog.cloudflare.com/cloudflare-workers-now-support-cobol/) is always an option.

### A markdown reader that loads a little bit faster

Consider a service that fetches a markdown file from the internet, parses it, and displays it in a pretty response. Something like that is simple enough to implement in a worker.

Aside from the main document containing your markdown rendered as HTML, you'll probably want to add some CSS to make the whole thing [a bit less of an eyesore](http://bettermotherfuckingwebsite.com/).

There's a pain point that comes with needing a stylesheet though, as it won't be requested until a browser parses the HTML. Our worker already has a considerable response time, as it needs to fetch the markdown file on each request. In turn, this delays our CSS.

Having the two requests chained one after the other isn't very desirable. How can we improve this?

Caching is nice, but it only comes into effect on repeated requests.

The boring option is to inline the styles. This negates the need for a second request, but it means our CSS can't be cached between reloads. Let's try for an option that's more fun.

HTTP/2 introduced the capability for a server to preemptively send resources to a client, and it's [supported by Cloudflare](https://blog.cloudflare.com/announcing-support-for-http-2-server-push-2/)! Enabling it is a one-liner, and now Cloudflare will send our CSS as well when responding.

```diff
  headers: {
      "Content-Type": "text/html",
+     "Link": "</reader.css>; rel=preload; as=style"
  }
```

While it's nice that Cloudflare is saving clients the work of initiating a request for the CSS, the push is still blocked by the time taken to generate a response with the necessary headers.

What if we could get Cloudflare to push the CSS to a client before the markdown is ready? That's where streamed responses come in!

Imagine briefly that we wanted to proxy a particularly large request through Cloudflare Workers. It's a very real possibility that we might hit the worker memory limit from buffering our origin's entire response. Instead, Cloudflare lets us stream it through in chunks to stay under the memory limit.

This also means any response can be streamed! We can create a `TransformStream()` and return the readable portion of it in our response body. The moment we write _anything_ to this stream, Cloudflare will start responding to our client!

This can be done before we start fetching and preparing the markdown, so a client can receive our CSS in parallel to the main document!

Let's dig into some code again.

```js
let { readable, writable } = new TransformStream();

// Don't need to await, the requests persists while the stream is open
streamMarkdownFromUrl(writable, url);

return new Response(readable, {
    status: 200,
    headers: {
        "Content-Type": "text/html",
        "Link": "</reader.css>; rel=preload; as=style",
    },
});

async function streamMarkdownFromUrl(writable, url) {
    const writer = writable.getWriter();
    const encoder = new TextEncoder();

    // Send an initial chunk to trigger a server response
    // Gives clients a chance to preload assets (CSS) before the <body> arrives
    await writer.write(encoder.encode(HTML_HEAD));

    try {
        const markdown = await fetch(url).then((r) => r.text());
        const body = marked(markdown);
        await writer.write(
            encoder.encode(HTML_BODY_BEFORE + body + HTML_BODY_AFTER)
        );
    } catch (error) {
        await writer.write(
            encoder.encode(
                HTML_BODY_BEFORE +
                    `<h1>Could not load markdown</h1>
                    <p>${error.message}</p>` +
                    HTML_BODY_AFTER
            )
        );
    }

    await writer.close();
}
```

Notice how we don't `await` the result of `streamMarkdownFromUrl()`, since that would block our handler from returning. Instead, we call the function to _start_ writing a response, and return the readable portion of the stream. So long as the stream isn't closed, our worker will keep running.

However, there is a compromise that comes with preparing our response in chunks. If anything goes wrong while preparing the markdown portion of our response, we can't return a `500` status or the like. We've already sent a `200` in our initial chunk. The cost of our little optimisation game.

Is it worth it? Maybe not for a critical production service, but it feels pretty good to shorten the critical path.
