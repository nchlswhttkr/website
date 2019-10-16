---
title: "My First Project"
description: "Lessons learned from my first project"
date: 2017-11-28T12:00:00+10:00
draft: false
layout: "single"
---

Often, the first steps in developing any project are the most critical. _"What environment should I be working in?"_ _"How to I implement X feature?"_ I found out the hard way today why taking these first steps seriously is important.

<!--more-->

## On the importance of the planning stage...

I'm going to cover the mistakes I made when starting off on a little project of mine, scraping DotA2 sub-patches. The premise was simple, learn to do basic scraping to read patch notes direct from the DotA2 blog, then translate it into HTML document reminiscient of official patch pages. I could download hero and icon images from the official site or a wiki if needed.

**Oh, how I was wrong...**

## There's an API for that!

Let's skip a couple of weeks ahead. I've been working to improve the way in which hero and item icons are obtained. At that point in time, I would retrieve them from separate sites, but I was unable to resolve to the fact that some items and hero have old or outdated names.

While looking at another repo for a discord bot that reports DotA2 matches, I noticed they were sending requests to "api.steampowered.com". Turns out Steam's API had the capability to provide up-to-date stats about DotA2. Suddenly, my process is greatly simplified. All I had to do was send a GetHeroes and GetGameItems request and parse the returned JSON.

```json
{
  "name": "npc_dota_hero_antimage",
  "id": 1
}
```

Success! I could now use this name ID to find an icon's URL and request it from DotA2's CDN, but I still didn't have access to the current in-game hero name. This was fixed by adding "language=en" as a parameter in my query, and I was good to go.

```json
{
  "name": "npc_dota_hero_antimage",
  "id": 1,
  "localized_name": "Anti-Mage"
}
```

The end result: I was able to replace a whole section of scraping with a simple API requests. All I needed to have done at the start was google 'DotA2/Steam/Valve API'.

## Investigate your options

I was going to need a library to scrape patch notes. Luckily for a common language like Python, finding a community written and supported one was a quick search away. I jumped right in and chose the first result.

Fast forward to Wednesday this week. I'm working to implement the Steam API and it seems to largely be working as I'd hoped. I run the full script, including parsing patch notes. ERROR. Suddenly my function to parse the page document isn't working as intended anymore. Admittedly I did get frustrated while fixing the bug, to the point where I started to blame the library I was using instead of placing the blame on my poor code.

After taking a break, I decided to investigate other options. Fortunately, my friend Eric had recommended another library which he had been using. 10 minutes later and I'm up and running. The next day, I push the Steam API integration, as well as improving the scraper.

Had I taken the time to investigate other options and talk to my colleagues, I would have avoided hours of frustration down the line.
