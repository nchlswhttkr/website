---
title: "Site"
description: "The inner workings of nicholas dot cloud"
---

There's a few more moving parts to my website than there were when [I first made it years ago](/blog/simple-static-sites/), so I've put this page together to cover all the pieces!

These are all the main parts that I can think of off the top of my head. If you've got questions, feel free to [contact me](/#contact)!

## Writing and publishing content

Almost all content and code sits in a [single Github repo](https://github.com/nchlswhttkr/website/).

I use the static site generator [Hugo](https://gohugo.io/) (with my own theme) to build my website.

As I write and push changes to Github, [Buildkite](https://buildkite.com/) schedules builds to be run. Conveniently, they a free tier for community/open source projects!

## Serving incoming traffic

I run everything off an aged Raspberry Pi (model 1B, plain Raspbian for now) on my home network. It's not the fastest arrangement, but it meets my needs and saves me paying for cloud compute capacity.

A Buildkite agent continuously checks for new jobs and rebuilds my site as needed. It performs other scripted work as well, like [sending out new issues of my newsletter](/blog/sending-out-my-newsletter/).

Web traffic is handled by [Nginx](https://nginx.org/en/). It makes serving static content a breeze, while still giving me a great deal of fliexibility. For example, my RSS feedis aliased to common paths (like `/feed` for Wordpress sites) to make it easier to find.

## Domain management

I originally called `nchlswhttkr.com` my home, but later moved over to `nicholas.cloud`. While "Nicholas Whittaker with no vowels" sounded good in my head, it became problematic when someone else had to type it out.

I've got `nicholas.cloud` registered with [Porkbun](https://porkbun.com). Not all registrars support the `.cloud` TLD, but thankfully Porkbun do! I've been happy so far with their pricing and customer support.

I keep `nchlswhttkr.com` registered with Cloudflare (no markup!) for legacy reasons, because I don't like link rot and it only takes [a few rules in Nginx](https://github.com/nchlswhttkr/website/blob/HEAD/nchlswhttkr.com.nginx) to redirect to my newer domain.

The nameservers for both domains are with Cloudflare, because it's easier to manage DNS records when my traffic is proxied through Cloudflare. The added benefit of caching is nice too, though I get a negligible amount of traffic.

My main reason for using Cloudflare is [Cloudflare Workers](https://workers.dev), which are great when I need little more than what a purely static website offers. Hooray for serverless!

-   I can drop in more complex functionality on routes that need it, like the [subscribe form for my newsletter](/newsletter/subscribe/).
-   I can respond to requests from Cloudflare's edge if I want something to be fast, rather than waiting on an origin call.

If you'd like to see a few more things that are possible with Cloudflare Workers, I've [written a couple of blog posts](/blog/getting-up-to-hijinks-with-cloudflare-workers) about uses I've found for them.
