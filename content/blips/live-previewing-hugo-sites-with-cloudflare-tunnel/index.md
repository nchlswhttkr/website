---
title: "Live previewing Hugo sites with Cloudflare Tunnel"
date: 2021-05-09T15:00:00+1000
tags:
    - cloudflare
    - hugo
    - webdev
---

Recently, Cloudflare made their Tunnel service (formerly Argo Tunnel) [free and available for all Cloudflare users](https://blog.cloudflare.com/tunnel-for-everyone/). For an existing free-tier user like myself, there's no better time to try it out!

Tunnels are designed for securely connecting an origin server to a web-facing endpoint. They're particularly great if

-   You're a service operating from a network/zone that doesn't allow inbound connections
-   You're a developer looking to expose your local server to the web

There are generic tools out there that fill this niche ([ngrok](https://ngrok.com/) is great for quick demos, and there's [inlets](https://docs.inlets.dev/) if you prefer self-hosting), but Cloudflare's offering works well for me because I already use them to manage my website.

**Down to business** - I'll be using my website for this example because it's built with Hugo.

After [installing the `cloudflared` tunnel client](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation), there's a few commands to authenticate and create a tunnel. I'm calling my tunnel `preview`, and exposing it at `tunnel.nicholas.cloud`.

```sh
cloudflared tunnel login
cloudflared tunnel create preview
cloudflared tunnel route dns preview tunnel.nicholas.cloud
```

With a tunnel created, we can start tunnelling traffic from port `1313`, the default port for Hugo's dev server.

```sh
cloudflared tunnel run --url localhost:1313 preview
```

Visiting `https://tunnel.nicholas.cloud/` now will show a `502 Bad gateway` error, since our Hugo server isn't running yet. Let's start it up!

```sh
hugo server \
    --baseURL=https://tunnel.nicholas.cloud/ \
    --liveReloadPort=443 \
    --appendPort=false
```

There's a few options we specify with this development server, seeing as we're no longer serving traffic from `localhost`.

-   Overriding the default URL to your chosen URL with `baseURL`
-   Disabling `appendPort`, since the tunnel's exit responds to traffic on the default HTTPS port `443`
-   Likewise, the `liveReloadPort` should be `443` so pages will be reloaded as we make changes

There you have it, a live preview of your Hugo site on your own domain thanks to Cloudflare Tunnel!

Thanks to Hugo (not the site generator!) for his bit on [previewing Hugo sites in GitHub Codespaces](https://hugo.md/post/editing-in-github-codespaces/), which inspired me to try this out!
