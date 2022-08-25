---
title: "Disappearing Blog Posts"
date: 2020-09-25T12:00:00+1000
# expirydate: 2020-10-09T12:00:00+1000
aliases:
    - /blog/temporary/this-post-will-disappear-after-two-weeks/
tags:
    - hugo
---

> **Update:**
>
> I've brought this disappearing post back from the abyss, enjoy!

_That's right, there's self-destructing blog posts now_

I've been toying with the idea of writing expiring blog posts for a while now, ever since discovering the `expiryDate` variable in Hugo.

Being able to have temporary posts that get cleaned up after a period of time seems like an interesting challenge and a nice convenience. For example, if I want to blog a short-term update that gets taken down once it's no longer relevant.

While this is easy in a dynamic site (`currentDate > expiryDate`), it's something that static sites struggle with. If a site's content changes over time, a static site must be updated with each change. I know I'm certainly not going to remember to redeploy my site weeks after publishing a temporary post!

With scheduled builds and a little extra configuration though, I've managed to automate my troubles away!

<!--more-->

There's two parts to my approach:

-   Posts with a set `expirydate` won't show up when the site is built by Hugo after a specified date.
-   Weekly scheduled builds redeploy the site and clean up content as it expires.

This meets my needs, although it comes with a few concessions.

-   Expired posts don't disappear immediately, the only guarantee is that they will _eventually_ disappear.
-   Posts can still be easily found (web archivers, Git history), but if that was a concern I wouldn't be touching the public web!

### Setting content to expire

New content on my site starts from base templates Hugo refers to as _archetypes_. I can make a new archetype for temporary posts, with a default expiry date defaulting to two weeks after the post's creation.

Here's what it looks like when I create a temporary post now.

```sh
hugo new --kind temporary blog/temporary/this-post-will-disappear-in-two-weeks.md
```

Since this post sits inside the blog folder, it's visible alongside my other posts and in my site's RSS feed. Once the post expires though, it will stop showing up.

With that, it's time to make sure the site is deploying on a recurring basis to clean up these temporary posts.

### Scheduled builds to ensure cleanup

Since I use Buildkite, it makes sense to leverage their CRON-style [scheduled builds](https://buildkite.com/docs/pipelines/scheduled-builds#main). I could use the `@weekly` interval, but for my own convenience I'll set it to 8pm local time each Sunday (`0 20 * * SUN Australia/Melbourne`).

Done, right? We've got builds running each week, so can we call it a day? Not quite.

In my case, builds don't just deploy changes to my site. They also [send out my newsletter](/blog/sending-out-my-newsletter/) if the build's HEAD commit includes a new or updated newsletter. If a scheduled build runs on one of these commits, my newsletter will be sent out multiple times!

While it won't reach my readers' inboxes (that requires my manual approval), newsletters will still be sent to me. I try to keep a clean inbox, so I'd like to avoid this scenario if possible.

I landed on a fix by filtering out the newsletter-sending step if a build was scheduled. Since a build's metadata includes the source that triggered it, I can use that.

Here's an (abridged) version of my pipeline config now.

```yaml
steps:
    - label: "Build & Deploy"
      if: 'build.branch == "main"'
      command: .buildkite/build.sh
    - wait
    - label: "Newsletter"
      if: 'build.branch == "main" && build.source != "schedule"'
      command: .buildkite/trigger-newsletter-if-new-issue.sh
```

While changes on the main working branch will always be deployed, the newsletter-sending job won't be triggered if the build is scheduled!

So with that, enjoy this blog post while it lasts!

Now it's just a waiting game.
