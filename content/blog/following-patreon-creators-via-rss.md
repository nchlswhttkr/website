---
title: "Following Patreon Creators via RSS"
description: "Building the features I want to see in the world"
date: 2020-10-23T15:00:00+1100
tags:
    - serverless
    - vercel
---

Over the last few months, I've started supporting a few content creators I follow through a monthly subscription on [Patreon](https://patreon.com/).

Whenever these creators post new content, Patreon notifies me with an email. This works well enough, but I'd rather be using my true love to stay up to date: RSS!

Does Patreon support RSS feeds? My cursory internet searching turns up that they're only available for podcasters posting audio content.

So if general RSS feeds for Patreon aren't available, why not make my own?

<!--more-->

## Scoping out a design

First things first, I need data! Time for some light reverse-engineering.

The Patreon web client is a React app that relies on a number of API calls to fetch data on different pages. Navigate around the site with your devtools open, and you'll see it fetching data from various `/api/...` routes.

Some requests, like loading user data and pledge rewards, require authentication to access exclusive and private data. Other portions of the API are publicly accessible though, encouraging anonymous users to sign up and nudging existing users to pledge more. In these cases the web client shows post titles but hides the key content, prompting users to "pledge \$X per month" to unlock the post.

Even though the responses in the public API aren't as rich as the ones authenticated users receive, they're rich enough to satisfy me. The alternative involves authenticating with Patreon and making requests on behalf of individual users, carrying with it additional risks I'd rather avoid in terms of privacy and security.

Another option I investigated was Patreon's developer API, but as far as I could tell it didn't support listing posts from the current user's pledges. This approach also still has the same risks as using authenticated endpoints on the main API does, so I'd rather take the simpler route of using the public API.

## Generating RSS feeds

So, I'm making a service to sit between Patreon and RSS readers. In terms of behaviour, I'm looking for something similar to the home page feed I see on Patreon. I want to be able to fetch the latest posts from all of my pledged creators, and collect them all together.

The Patreon API can filter posts by creator ID, so to me it seems most reasonable to have one feed for creator. I could support bulk requests for multiple creators in a single feed, but this still requires _N_ requests to Patreon for _N_ creators on my end. Since many RSS readers support folders for grouping feeds, it's fine to have a number of individual feeds.

When it comes to generating the RSS feed itself, the work itself is fairly straightforward. With the necessary query parameters figured out, all that's left is to do is transform the API's JSON response into the XML format readers expect.

Here's a sample from one such feed.

```sh
curl https://patreon-rss.nicholas.cloud/api/feeds/90486
#
# <rss version="2.0">
# <channel>
# <title>Red Letter Media</title>
# <link>https://www.patreon.com/redlettermedia</link>
# <description>We talk about movies and make our own</description>
#
# <item>
#     <title>Best of the Worst: Halloween Spooktacular!</title>
#     <link>https://www.patreon.com/posts/best-of-worst-43246603</link>
#     <description>This post is exclusive to Red Letter Media patrons, you can view it on &lt;a href=&quot;https://www.patreon.com/posts/best-of-worst-43246603&quot;&gt;Patreon&lt;/a&gt;.</description>
#     <guid>https://www.patreon.com/posts/best-of-worst-43246603</guid>
#     <pubDate>2020-10-28T13:01:22.000+00:00</pubDate>
# </item>
#
# ...
```

Since patron-exclusive content isn't visible in the public API, all I can do is show a placeholder and redirect users to the Patreon web client. Given posts can only be viewed in their entirety in the web client though (emails are often trimmed), this is acceptable.

## Onboarding new readers

At the moment, getting a creator's feed requires knowing their ID. Most creators are known by a vanity name though, like `ai_and_games` or `falseknees`, and their ID isn't easily found. It's also inconvenient to add feeds one by one for anyone looking to use this service.

Fortunately, both of these problems can be solved with the developer API. While this API isn't great for fetching posts, it is great for accessing user data, including pledge information.

With an OAuth2 flow, users can grant me permission to read their pledges, which I can use to get the list of creators they pledge to from the developer API. Since I don't need the authentication tokens granted to me outside of this one request, I can discard them right afterwards as well!

With this list of creators (and their IDs), I can create an OPML file with all of the RSS feeds to subscribe to. This OPML file can be loaded into the user's reader of choice, and it'll create a "Patreon" folder with the feeds of all their creators.

As an extra step, we can grab the _tiers_ of a user's pledges to include in the RSS feed URL. This extra parameter lets me filter the responses from the Patreon API to only include posts the user is eligible to see. For users pledged to lower tier on a creator, this eliminates a lot of pointless noise from posts they don't have permission to view.

## Hosting

The last piece in this puzzle is to host this service on the web somewhere. In my eyes, a serverless approach is a great fit in this situation!

-   Most functionality is just a wrapper over the Patreon API.
-   In terms of "architecture", this is just a set of independent functions and their corresponding endpoints.

I opted to go with [Vercel](https://vercel.com/) (formerly Zeit) because their tooling makes it easy to quickly bootstrap a project with several serverless functions. I'm particularly a fan of how it maps filepaths to endpoints, which saves me the need to worry about route configuration and file naming.

Seriously, all I need to do to declare three function is to create their respective TypeScript files!

```sh
git ls-tree -r main | cut -f 2 | grep "api/"
# api/authorize.ts
# api/callback.ts
# api/feeds/[campaign_id].ts
```

From here, deployments are just a matter of configuring environment variables and running `vc --prod`.

## In closing, an aside

Before I call it a day, there's one last thing worth mentioning: While building projects like this is useful for me in a number of ways, it's definitely toeing a line by scraping the Patreon API.

For quite a while, my work was blocked by Cloudflare bot protections. Said protections seem to have been removed (for now) though. On my end, I've tried be responsible in my usage by caching responses for several hours and not rehosting any content beside what's essential to the RSS feeds I produce.

Anyway, if you fall into the overlap of people who use Patreon and peolpe who use RSS readers, feel free to [give my service a try](https://patreon-rss.nicholas.cloud/)!
