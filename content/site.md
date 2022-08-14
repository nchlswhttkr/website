---
title: "Site"
description: "The inner workings of nicholas dot cloud"
---

There's a few more moving parts to my website than there were when [I first made it years ago](/blog/simple-static-sites/), so I've put this page together to cover all the pieces!

These are all the main parts that I can think of off the top of my head. If you've got questions, feel free to [contact me](/about/#contact)!

## Acknowledgements

All content on this website is my own unless otherwise credited.

With that said, there's a number of tools and services this website depends on. You can read more about them below.

-   [Hugo](https://gohugo.io/) lets me quickly build and preview my website content.
-   I use [Buildkite](https://buildkite.com/) to automate deployments and other assorted jobs.
-   All of my web traffic needs are handled by [Cloudflare](https://cloudflare.com/).
-   I manage this website's infra with [Terraform](https://terraform.io/) and [Ansible](https://docs.ansible.com/ansible/latest/).
-   Some of my Git repositories are mirrored here, with [Stagit](https://git.codemadness.org/stagit/file/README.html) generating web views for them.
-   A self-hosted [Plausible Analytics](https://plausible.io/) instance gives me a little insight on my website's visitors.
<!-- TODO: Add better explanations later and mention Terraform/Ansible/Plausible -->

There's also several other resources that this site uses.

-   Footer icons are provided by [Feather](https://feathericons.com/).
-   The site favicon uses an icon from [Font Awesome](https://fontawesome.com/license/free/).
-   Background pattern comes from [Hero Patterns](https://www.heropatterns.com/).

## Writing and publishing content

Almost all content and code sits in a [single Github repo](https://github.com/nchlswhttkr/website/).

I use the static site generator [Hugo](https://gohugo.io/) with a custom theme to build my website. It's fast and meets my needs for templating/content management.

I like being able to write my posts locally in markdown. It's easy to read and write, and whenever I need something more complex I can easily drop in custom HTML snippets with Hugo.

As I write and push changes to Github, [Buildkite](https://buildkite.com/) schedules builds to be run. Good thing they have a free tier for community/open source projects! It performs other scripted work as well, like [scheduling delivery of my newsletter](/blog/sending-out-my-newsletter/).

## Serving incoming traffic

I currently run everything off a single DigitalOcean droplet. I configure and manage it with [Terraform](https://www.terraform.io/) and [Ansible](https://docs.ansible.com/ansible/latest/). It's included with my website's source code.

I previously ran everything off an old Raspberry Pi model 1B on my home network, but [I've retired it for now](/blips/for-now-goodbye-raspberry-pi/).

There's a couple of other services hosted on this droplet too.

-   Git's FastCGI client with [Stagit](https://git.codemadness.org/stagit/file/README.html) for my self-hosted repositories
-   A self-hosted [Plausible Analytics](https://plausible.io/) instance
-   A self-hosted [https://writefreely.org/] instance, but only for personal use

Web traffic is handled by [Nginx](https://nginx.org/en/). It makes serving static content a breeze, while still giving me a great deal of fliexibility. For example, my RSS feed is aliased to common paths (like `/feed` for Wordpress sites) to make it easier to find.

## Domain management

I originally called `nchlswhttkr.com` my home, but later moved. While "Nicholas Whittaker with no vowels" sounds good in my head, it becomes problematic when someone else had to type it out. I use a [Cloudflare Worker](https://github.com/nchlswhttkr/workers/tree/main/workers/nchlswhttkr-dot-com/) to redirect to my new website, because I try to avoid link rot.

Both this old domain and my current domain, `nicholas.cloud`, are registered with [Porkbun](https://porkbun.com/). I've been very happy with them so far for their pricing and excellent customer support.

The nameservers for both domains are with Cloudflare, because it's easier to manage DNS records when my traffic is proxied through their network. The added benefit of caching is nice too, though I get a negligible amount of traffic.

My main reason for using Cloudflare is [Cloudflare Workers](https://workers.dev), which are great when I need little more than what a purely static website offers. If you'd like to see a few more things that are possible with Cloudflare Workers, I've [written a couple of blog posts](/blog/getting-up-to-hijinks-with-cloudflare-workers) about uses I've found for them. Hooray for serverless!
