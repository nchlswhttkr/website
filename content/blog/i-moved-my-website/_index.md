---
title: "I Moved My Website"
description: "A small change, an hour of debugging"
date: 2019-01-31T12:00:00+10:00
draft: false
layout: "single"
---

I may not have been on the #movingtogitlab train, but recently I decided to try moving my website from GitHub Pages to GitLab pages. Trouble ensued, but helpful documentation saved the way!

<!--more-->

For reference, this site runs through Cloudflare nameservers. At the time of writing, I owned this domain through Namecheap, though shortly after I moved over to using Cloudflare as my registrar as well.

The first step was changing my DNS config in Cloudflare to use a CNAME pointing to `nchlswhttkr.gitlab.io`, replacing the original `nchlswhttkr.github.io`. A few changes later and a 5 minute wait later and I'm presented with this beauty.

![GitLab Pages returns a 404](./the-classic-404.png)

<span class="center-text">_You thought this was only going to be a one-step process?_</span>

Success! Cloudflare has switched over, now I just need to flick some switches on GitLab and it'll be all smiles, right? I'd just need to go through the process on [GitLab Pages' setup section for custom domains](https://about.gitlab.com/2016/04/07/gitlab-pages-setup#custom-domains), and I'd be finished.

> Add your domain to the first field: `mydomain.com`

> If you have an SSL/TLS digital certificate and its key, add them to their respective fields. If you don't, just leave the fields blank.

Not knowing anything about these certificates, I left the fields blank and hit submit.

![Submitting requires certificate and key fields to be filled for HTTPS-only sites](./you-need-keys.png)

<span class="center-text">_Not quite what I was hoping for..._</span>

So, something is missing here. A few minutes of searching later and I stumble across an article from the GitLab blog about [using Cloudflare with GitLab Pages](https://about.gitlab.com/2017/02/07/setting-up-gitlab-pages-with-cloudflare-certificates).

Thanks to this, a lot of time spent worrying and searching was saved - the lesson of the story is write up the little problems you encounter and how you solve them from time to time. Thanks Marcia from GitLab, with your help I'd have spent a lot longer trying to resolve this, especially on the bit about combining the PEM and root certificates!

After following their instructions and giving the changes a few minutes to apply, I checked up on my site.

![HTML with no CSS applied](./css-not-required.png)

<span class="center-text">_This is where I give a shoutout to [https://motherfuckingwebsite.com](https://motherfuckingwebsite.com)_</span>

Although `index.html` was loading, other requests for CSS and media were failing with a [404 response](https://httpstatusdogs.com/404).

I decided to go for a walk and hoped everything would fix itself, maybe the static files were still being uploaded to a bucket somewhere after a successful build, or maybe some caching issues were occuring.

Coming back half an hour later, my website was back in proper shape. Business as usual!

At this point I'm still not sure what caused some requests to 404. I'm sure the reason will haunt me for many years to come, or however long it takes for me to properly investigate the architecture behind GitLab Pages.

Until then, I hope you enjoyed reading about my experience going through this, and seeing how it was resolved!
