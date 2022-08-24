---
title: "I'm now using Plausible Analytics"
date: 2021-04-09T06:00:00+1000
tags:
    - site
---

For now, I'm trying out a self-hosted instance of [Plausible Analytics](https://plausible.io/) with this website. I was tempted to go with the hosted option for a while, but I prefer having more control with a self-hosted arrangement.

<!--more-->

Setup so far has been smooth, since the self-hosted option is run as a set of Docker containers. I ran into some TLS erros when interacting with Mailgun from the main Elixir app, but I've found a workaround using the bundled SMTP server that will be fine for now.

Alongside this, I'm adding a [page on privacy](/privacy/) to this site as well. I don't really need a privacy policy, but I don't see any harm in being transparent about how I operate.
