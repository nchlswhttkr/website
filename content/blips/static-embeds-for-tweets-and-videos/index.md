---
title: "Static embeds for tweets and videos"
date: 2021-03-11T00:00:00+1100
tags:
    - site
---

Tweets and videos embedded in this site are now static, displayed using my own custom HTML/CSS! Previously I used the templates provided by Hugo, but I had a few motivations for going with own approach.

-   Remove third-party iframes and scripts from my website
-   Load content lazily, and without causing page reflow
-   Generate embeds at build time, rather when clients load a page

Embeds from Vimeo and YouTube are pretty basic, with a thumbnail linking to the respective sites. While you can't actually _watch_ videos on my site, but in return mobile clients can now use their native app for viewing. I think this is more desirable.

Tweets are bit more interesting. They aren't just plain text, and they can include images and video. The design and approach I use is based on work by [Jane Manchun Wong](https://wongmjane.com/) in her own site.

{{< tweet 1330273157245243394 >}}

I still have a little more work to do before I'm completely satisfied with these static embeds, and then I'll write more about _how_ they work. For example, I still hotlink to media files like images and video. Fixing that is work for another day though.
