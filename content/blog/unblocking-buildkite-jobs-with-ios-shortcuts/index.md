---
title: "Unblocking Buildkite Jobs With iOS Shortcuts"
description: "I could do it, I didn't stop to think whether I should do it"
date: 2020-10-16T14:00:00+1100
tags:
    - automation
    - buildkite
    - ios-shortcuts
---

For a while now, I've been automatically [sending out my newsletter](../sending-out-my-newsletter/) as a part of the deployment process for my website. It's a great convenience that means I can focus on writing and publishing new content, instead of worrying about generating and delivering actual emails.

In my current setup, I'm able to preview newsletters from my inbox before they're delivered to my readers. If I think one is good to go, I can hit the big red button to send it out!

While pressing this "big red button" only takes a half-dozen clicks in a web UI, I'd love if it was just _that little bit_ easier on my end. So that's what I set about improving today!

<!--more-->

## The typical process

To quickly recap the necessary technical details, I use [Buildkite](https://buildkite.com/) for my website's builds. Whenever a new newsletter is detected, two extra jobs are appended to the in-progress build. The first sends me a preview newsletter, and the second sends it to my readers.

This second job is blocked from running until I give manual approval. Looking at a recent build, you can see the final "Publish" job only runs after I've explicitly unblocked it.

![A set of three tasks, with the last one labelled "Publish" separated from the other two. Between them is a label that reads "Nicholas Whittaker unblocked this yesterday at 7:35pm"](./build.png)

As I said before, this is easy to do through Buildkite's web UI, but it still takes a moment to get it done. After reviewing a preview newsletter, I wanted to be able to send it out with minimal action on my part.

[Buildkite's REST API](https://buildkite.com/docs/apis/rest-api) had the necessary endpoints to script this, but I had a few requirements of my own to impose. Namely, I needed a solution that was:

-   Accessible from my phone, since I'm not always doing review on my computer
-   Private to me, whether by design or through simple authentication
-   Interactive, so jobs wouldn't be unblocked if I ran the script accidentally
-   Free of third-party code, because I prefer to avoid managing/upgrading dependencies

My first thought was to go for something serverless that's web-accessible, but this requires an authentication layer and doesn't lend itself well to interactivity.

Another option I weighed up was to SSH from my phone into a remote device with the Shortcuts app on iOS. It would mean I'd need to set up authentication and possibly keep a remote machine up to date, but I'd be able to trigger the shortcut itself very easily.

This was when I had the glaring realisation that maybe, _just maybe_, I could do it all within Shortcuts itself! Usage would be restricted to my Apple devices, interaction could be done through system prompts, and all logic would be contained within the app itself!

## A faster process

With a plan in mind, I set about creating a shortcut. After some dragging and dropping, I was able to unblock jobs from the comfort of my phone!

1. Query the Buildkite API for the latest (production) build of my website
1. Look for any blocked jobs in the build
1. Get approval to unblock each blocked job

You can see an example in action here, unblocking the "Goodbye" job. I found system prompts were particularly great for making interaction quick and easy on my part!

For a little bit of excitement, I've also thrown in a piano piece I've been learning recently for some easy listening!

{{% vimeo "468393883" %}}

In general, I think the Shortcuts app is great if your workflow can be expressed as a fairly linear set of tasks. In my opinion though, there's definitely a point you can reach in terms of complexity where you should start _strongly considering_ other options. For me, this shortcut was around that limit.

There are some quirks to making shortcuts, but I'd attribute a lot of that to the app using a visual language that isn't solely meant to cater to programmers. For example, I got tripped up a number of times by the `Get Value From Input` action while building my shortcut.

-   When you convert a one element long list from a JSON response into a dictionary and later retrieve values from it, Shortcuts will look for the specified field on the element itself. No indexing needed.
-   When you retrieve a value from a dictionary and want to compare it to another value, you need to first convert it to a number/text since comparison isn't allowed for null-able values.
-   Boolean fields become `Yes` or `No` when converted to text.

If I had to give advice for those of you making your own shortcuts, I'd highlight three things.

-   **Use variables** when the output for an action isn't used immediately, or is used in multiple places. Shortcuts' logic tracing doesn't indicate when an action reads multiple inputs, and generic variables like "Dictionary" and "Text" don't help you.
-   If you're confined to a small phone screen, **plan out** as much of your action as you can before writing it. Shortcuts has poor support for dynamic text sizing, so your screen can only fit two or three actions at any time. A small screen also makes scrolling and rearranging actions incredibly laborious.
-   When in doubt, consult the [User Guide](https://support.apple.com/guide/shortcuts/welcome/ios) and [Shortcuts subreddit](https://shortcuts.reddit.com/).

Here's the full shortcut if you're interested in adapting it for your needs. Until next time, happy automation!

![](./shortcut.png)

---

PS - FFmpeg and ImageMagick are once again incredibly useful tools for media processing!

```sh
# Grab the audio from piano.mov and combine it with the video from screen-recording.mp4
ffmpeg -vn -to 00:00:39.500 -i piano.mov -an -to 00:00:39.500 -i screen-recording.mp4 -c:a aac -c:v libx265 -tag:v hvc1 buildkite.mp4

# Knit together a collection of screenshots from iCloud, with glob syntax
magick "~/Library/Mobile Documents/com~apple~CloudDocs/Downloads/Unblock jobs *" -append /tmp/shortcut.png
```
