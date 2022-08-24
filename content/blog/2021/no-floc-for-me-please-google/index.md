---
title: "No FLoC for me please Google"
date: 2021-04-23T22:00:00+1000
---

[A new approach to online tracking being trialed by Google](https://www.eff.org/deeplinks/2021/04/fighting-floc-and-fighting-monopoly-are-fully-compatible) has been under scrutiny this week, from developers and privacy advocates alike.

<!--more-->

Along with others, I'm explicitly opting-out my website out of this program. Thankfully it's a one-liner in my Nginx config.

```diff
+ add_header "Permissions-Policy" "interest-cohort=()";
```

According to Google, this tracking method is activated (_for the time being_) when sites do either of the following.

-   Call `document.interestCohort()`
-   Load ads or ad-related resources (whatever Google determines this to be)

With that said, there's no saying when or how this will change. Taking the hardline approach to avoid this behaviour seems sensible to me.

I've got more to say on the stances companies like Google take on privacy, but that's a longer piece of writing for another day.

Thanks to Ruben Schade for [his bit on FLoC](https://rubenerd.com/opting-out-of-googles-floc/) too!
