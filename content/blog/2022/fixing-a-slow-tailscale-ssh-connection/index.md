---
title: "Fixing a slow Tailscale SSH connection"
date: 2022-09-25T22:00:00+1000
description: "Discovering a tradeoff Tailscale makes for convenience"
tags:
    - tailscale
---

I've been trying out [Tailscale](https://tailscale.com/) recently to simplify networking between my devices. With the beta launch of [Tailscale SSH](https://tailscale.com/blog/tailscale-ssh/) offering the ability to connect to my DigitalOcean droplet without SSH keypairs, I was eager to incorporate it into my setup.

Said setup is a matter for another time, but with Tailscale SSH enabled for my droplet I was able to remote in with a plain `ssh nicholas@gandra-dee`!

However, there was a visible half-second delay when entering commands. While not a dealbreaker, it made each session a frustrating experience!

<!--more-->

I started off by getting a gauge of the problem. How responsive was the connection? It wasn't _too_ slow, but it wasn't fast either.

```sh
$ ping -qc 10 gandra-dee
PING gandra-dee.nchlswhttkr.github.beta.tailscale.net (100.79.138.83): 56 data bytes

--- gandra-dee.nchlswhttkr.github.beta.tailscale.net ping statistics ---
10 packets transmitted, 10 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 353.175/535.999/1690.879/398.688 ms
```

Fortunately in this debugging adventure, I _did_ have a suspect: I'd recently added a firewall on the DigitalOcean side, so there was a good chance I'd missed a rule along the way. It was strange that I could still connect to the droplet despite the firewall likely blocking some of my requests.

Glancing through [the Tailscale documentation on firewall rules](https://tailscale.com/kb/1082/firewall-ports/) revealed a likely cause for the slower than expected connection.

> However, when both devices are on difficult networks Tailscale may not be able to connect devices peer-to-peer. You’ll still be able to send and receive traffic, thanks to our secure relays (DERP), but the relayed connection won’t be as fast as a peer-to-peer one.

Bingo. A quick `tailscale status` confirmed the connection was over a relay.

```sh
$ tailscale status
100.79.138.83   gandra-dee           nchlswhttkr@ linux   -
100.82.154.68   flugelhorn           nchlswhttkr@ iOS     offline
100.88.173.96   phoenix              nchlswhttkr@ macOS   active; relay "syd", tx 1764024 rx 22460936
```

While I'd remembered to add a rule to `ufw` on the droplet to allow Tailscale traffic, the firewall rules on the DigitalOcean side were blocking traffic beyond that. Even though Tailscale couldn't connect over its typical port it was able to fall back to the HTTPS relay, which the firewall allowed.

The fix is thankfully quick, adding a couple of firewall exceptions with Terraform.

```terraform
# Allow inbound Tailscale requests
inbound_rule {
  protocol         = "udp"
  port_range       = "41641"
  source_addresses = ["0.0.0.0/0", "::/0"]
}

# Allow outbound Tailscale requests
outbound_rule {
  protocol              = "udp"
  port_range            = "41641"
  destination_addresses = ["0.0.0.0/0", "::/0"]
}
```

Reconnecting to the instance now after applying the change, the remote session starts noticeably faster! The response time to my typing is immediate, and my calm is restored. Running `tailscale status` again confirms the problem is fixed. (_Omitting my IP, of course_)

```sh
$ tailscale status
100.79.138.83   gandra-dee           nchlswhttkr@ linux   -
100.82.154.68   flugelhorn           nchlswhttkr@ iOS     offline
100.88.173.96   phoenix              nchlswhttkr@ macOS   active; direct 192.0.2.0:22697, tx 1794276 rx 22486396
```

What's the connection like now?

```sh
$ ping -qc 10 gandra-dee
PING gandra-dee.nchlswhttkr.github.beta.tailscale.net (100.79.138.83): 56 data bytes

--- gandra-dee.nchlswhttkr.github.beta.tailscale.net ping statistics ---
10 packets transmitted, 10 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 89.109/121.486/405.295/94.605 ms
```

Bliss.
