---
title: "Introducing Tags and a New Site Design!"
date: 2020-10-19T19:00:00+1100
# expirydate: 2020-11-01T19:00:00+1100
tags:
    - site
aliases:
    - /blog/temporary/introducing-tags-and-a-new-site-design/
---

For the last week or so, I've been working on a few improvements to this site!

I don't usually write about this stuff, but I thought it might be interesting to briefly mention a few of the things I've done.

<!--more-->

### Finding posts by tags and series

I've gone through most of my old posts and added tags to them, so now you can find posts on certain topics more easily! You can find all the tags listed on the [tags page](/tags/).

Some blog posts belong to a series, and these posts now have a little list at the top of their respective pages for easy navigation. Previously, I included links within each post's content. This was workable, but relied on me updating and managing all the links between posts.

If you want to see an example of all this is action, start with my posts about [building a Golf Peaks solver](../../building-a-solver-for-golf-peaks/)!

### Better caching behaviour

As part of Cloudflare's free plan, I'm able to cache content on their network. Since origin calls are slow in [my current arrangement](/site/#serving-incoming-traffic), caching as much as possible on Cloudflare helps to keep page loads fast for end users. Not all content types are cached by default though. HTML in particular is not cached, so Cloudflare needs to make an origin call for on page load. This impacts every page on this website.

I've updated the domain settings in Cloudflare to cache all content, and rewritten the Nginx rules that power my website to add the appropriate `Cache-Control` headers. This also allows me to vary cache durations depending on the content type requested, and whether the cache is in Cloudflare or a user's browser.

There's more to dig into with these changes, but the key takeaway is that now you'll only see slow page loads when you visit "cold" pages that aren't in Cloudflare's cache. If any page gets hit by a "hug of death", I (hopefully!) shouldn't need to worry about it.

### Site background

If you're on a tablet or desktop, you might notice the new background image. It's just a little nature photography, but I think it's a nice addition.

### Fewer requests, faster page loads

When you previously visited most pages on this site, you'd usually be making at least ten requests. Now, that number is down to four! This involved a number of changes.

First, the SVG icons I use in the footer have been replaced with smaller variants and inlined into the page. Thanks [Feather](https://feathericons.com/)! This eliminates a half-dozen requests right off the bat, with the acceptable tradeoff of adding an extra 2KB to each page.

Second, I've implemented my own primitive CSS bundling. Most pages on this site rely on a handful of shared CSS files, with the exact selection differing slightly between pages. For example, a blog post with syntax-highlighted code blocked needs `main.css`, `blog-article.css`, and `highlight.css`. This would previously take three requests, but now only a single bundled file is requested!

Lastly, every page is also weighed down by the newly-added background image. Background images require CSS to be fetched and parsed before they can be loaded, so they're traditionally slow to load. I've mitigated this with a [`preload` hint](https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content) for supporting browsers, and by deferring to an inline thumbnail of the background during page load. This inline placeholder adds about 2KB to each page, but I'm alright with this tradeoff for smoother background loading.

### Nice things in development land

The nice additions haven't just been in userland either! For local development, I've been enjoying a few new things.

I'm now using [VS Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets) in a few places. They make it easy for me to add and fill out generic snippets of markdown, especially for my newsletter where it pastes links from my clipboard!

I've started leveraging [base templates in Hugo](https://gohugo.io/templates/base/), so now each page on my site stems from the same template. Individual page templates then only need to specify their CSS and main content.

To give one last mention as well, the background image and theme color can be customised for individual pages. I can't show it off quite yet, but it's going to look awesome in a future blog post!

### On the horizon

For a while now, I've been considering adding privacy-friendly, lightweight analytics to this site. I'm trying to justify the cost of [Plausible](https://plausible.io/) at the moment, as they have a [strong stance on user privacy](https://plausible.io/data-policy). I've also been looking at other options like [Umami](https://umami.is/), which I could feasibly self-host once I get an SQLite fork working.

I'm pretty chuffed to have made all the improvements, and I've got plenty of blog posts in the pipeline for the near future!
