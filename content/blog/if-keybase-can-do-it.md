---
title: "If Keybase Can Do It"
description: "Recreating the file sharing functionality of Keybase"
date: 2020-05-16T12:00:00.000Z
---

[Keybase](https://keybase.pub) has a really nice feature where you can sync files between your devices, and (optionally) make them publicly accessible.

They were also [acquired by Zoom](https://keybase.io/blog/keybase-joins-zoom) last week. While I think it's too early to say whether this means good or bad things for Keybase, it seemed like a timely opportunity to try recreating this feature I love.

<!--more-->

With this post, I thought it would be interesting to talk a little about my process when approaching a problem like this. Maybe the journey isn't as interesting as the end result, but it can't hurt to write about it!

## Break it down

I'm rebuilding something that already exists, so let's start with a high-level description of what Keybase does for me. In particular, what are the key elements to it?

> With minimal interaction, Keybase allows me to make files on my machine visible to the web.

The key benefit here is that it's almost entirely hands-free. Publicly sharing files is something that can already be easily done with plenty of drag-and-drop programs, but I need to go through a web UI or client to make this happen.

How does Keybase implement this? There's more to dig into to here, and I think it's about understanding where the solution starts and ends. Nitty-gritty details!

> Files located inside `/Keybase/public/nchlswhttkr/` can be viewed in near real time at `https://keybase.pub/nchlswhttkr/`.

I need a way to get directory contents synced to a web-facing location, with changes being actively carried across. With that in place, so long as I can see what's inside the directory from a web request, we're good!

I'll need something to handle file serving for me, since I don't want to handle web traffic on my own machine. I could use object storage with a cloud provider, but in the interest of avoiding bills I'll stick with my existing web server.

Assuming my web server is able to handle the requests, the remaining work involves keeping it in sync with whatever might be happening locally. So two moving parts overall, clean enough.

Let's wrap this up with a rough description of the end product and get onto building!

> When filesystem changes happens locally, they are synced to my remote web server. This server then makes the files available to the web.

## Serving files to the web is easy

This was a pretty quick addition to the Nginx config for my server, on it goes!

```diff
  server {
      server_name nicholas.cloud;
      ...

+     location /files/ {
+         alias /home/nicholas/public-files/;
+         autoindex on;
+     }
  }
```

With an `alias` to serve local files for matching locations and the `autoindex` directice to generate directory views on index routes, web visitors can browse my public files.

## Syncing files between devices is hard

I have files I want share in `~/public-files/`. I want them on the remote at `~/public-files/`. I want them synced automatically/in the background.

That shouldn't be too difficult to set up right?

Coveniently enough, I happen to know that macOS comes with a built-in framework for scripting automation! With any compliant implementation of their [Open Scripting Architecture](https://en.wikipedia.org/wiki/AppleScript#Open_Scripting_Architecture), you can programmatically interact with the system.

Meet AppleScript. This snippet syncs my files every hour, showing me an alert to investigate if something ever goes dreadfully wrong.

```applescript
on idle

	try
		do shell script "rsync --delete --checksum --recursive --itemize-changes ~/public-files/ nicholas@nicholas.cloud:~/public-files/ > /tmp/sync.log"
		display notification "Successfully synced" with title "Sync" sound name "purr"
	on error
		display alert "Could not sync files to remote server" as critical
		quit
	end try

	return 60 * 60

end idle
```

Maybe not the prettiest, but it gets the job done and it comes with some very nice features!

Aside from being able to easily show system-integrated elements like notifications, I can also package this snippet so that macOS treats it like an application! This means I can have a sync "app" appear in my dock when it's active, starting up when I log in.

This about meets the requirements I set out earlier. I can manage files locally, and they're available to the web soon after with no action needed on my part.

Compared to other tools (cron, systemd) it might be unwieldy, but for me the system integrations make it much friendlier to work with.

However, we can actually introduce one last change to make it a little better though!

## Replacing a background job with a manual trigger

There's a useful little app that comes with macOS called Automator. Automator lets you set up a similar level of automation to what you can achieve with AppleSCript, but through a GUI. In Automator, the automation documents are called workflows.

If your macOS machine is like mine and has a touch bar, it can be set to show any "Quick Action" workflows you create in Automator. Given a workflow can itself run AppleScript, I can run my snippet from the comfort of my touch bar!

While it _is more effort_ than letting an automated process to the syncing for me, I think it's a nice trade to be able to sync at my discretion.

So there you have it, file syncing from my machine to the web!

If you'd like to see the end result, just head to [https://nicholas.cloud/files/](https://nicholas.cloud/files/)!

## Thanks

I wouldn't have known about macOS automation if [Josh Parnham](https://joshparnham.com/) hadn't given a talk on it a few years ago. You can find [his slides on GitHub](https://github.com/josh-/automating-macOS-with-JXA-presentation) to see what he spoke about, as well as links to plenty of resources on jumping into automation in macOS!

---

As as aside, it's worth noting that you can also convert my AppleScript right back into a shell script. With the `osascript` command you can execute any OSA-complient snippets. For example, this command is perfectly valid.

```sh
osascript -e 'display notification "Hello world!" sound name "frog"'
```

As another aside, it's also worth mentioning that you can hook automation like this directly into filesystem events, but that wasn't something I looked at while writing this.
