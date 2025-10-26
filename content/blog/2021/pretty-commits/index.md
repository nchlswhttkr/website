---
title: "Pretty commits"
date: 2021-05-25T22:00:00+1000
---

In a chance glance through the Git history of one of my projects last week, I found commit [`53331294`](https://github.com/nchlswhttkr/mandarin-duck/commit/53331294bf7e8460b1d05a87a96aa2968687cc9e). A hash with eight leading numbers! A sequence like this isn't particularly rare, but it's also not an everyday occurence.

<!--more-->

Today at work, I notice the palindrome `39eee93` while using `git reset`<sup>1</sup>. SHA-1 works in mysterious ways. :thinking_face:

Of course, there are plenty of other pretty commits out in the wild. You can always try brute-forcing a commit with more leading zeroes than [`00000000000000`](https://github.com/seungwonpark/ghudegy-chain/commit/00000000000000c06d2e8c36f247206a9a4b1c63), or cracking a joke with [`deadbeef`](https://github.com/bradfitz/deadbeef).

If you're musically inclined, what melodies use the natural notes bar G? The lick is unfortunately not SHA-friendly.

When you commit next, consider a pause to admire the hash. Who knows what pattern you might spot?

<sup>1</sup> If you find yourself navigating the fog that is `git rebase`, remember to throw out a tag here and there. It's a great catch if (like me) you occasionally need to reset. :sweat_smile:
