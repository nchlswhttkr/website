---
title: "If Keybase Can Do It"
description: "Recreating the functionality Keybase's file sharing service"
date: 2020-05-12T12:00:00.000Z
---

[Keybase](https://keybase.pub) has a really nice feature that lets you share sync files around under your account, and optionally to make them publicly accessible.

They were also [acquired by Zoom](https://keybase.io/blog/keybase-joins-zoom) last week. While I think it's early days to say whether this means good or bad things for Keybase, it seemed like a timely opportunity to recreate some of their services for myself.

<!--more-->

Keybase also helps with proving my identity across other mediums, but digging into that is work for another day. It did get me into the habit of signing my commits though, which has been a good learning experience!

But back to the task at hand. We're here to talk about file sharing, not how I could botch up cryptography implementations.

## What are the moving parts?

With projects like this, I like to start by trying to identify why I'm building something.

> With minimal interaction, Keybase allows me to make files on my machine visible to the web.

The key benefit here is that it's mostly hands-free. Sharing files publicly can be easily done (publish to GitHub, upload to Google Drive), but action on my part is needed to upload and share the files.

From here, it's time to start digging for a more precise description of where my solution starts and ends. In this case, what exactly does Keybase do for me?

> Files located inside `/Keybase/public/nchlswhttkr/` can be viewed in near real time at `https://keybase.pub/nchlswhttkr/`.

So I need some way of getting directory contents to a web-facing location, with changes actively being carried across. If I can see what's in the directory from a web request, we're good.

Given serving web traffic directly off my machine isn't the wisest idea, some work needs to be done elsewhere. I could go with a object storage in a cloud provider, but in the interests of keeping my bills down I'll stick with my existing web server.

Let's wrap this up with a rough description of the end product.

> When files are created/edited/deleted locally, they are synced to my remote web server. This server makes them available to the web.

## Serving files to the web is easy

This was a pretty quick addition to my Nginx config.

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

With an `alias` to server local files for matching locations and the `autoindex` directice to generate directory views on index routes, visitors could browse my files.

## Syncing files between devices is hard

I have files in `~/public-files/`.

I want them on the remote at `~/public-files/`.

I want them synced in the background.

Coveniently enough, macOS comes with a built-in framework for automation! With any compliant implementation of their Open Scripting Architecture, you can programmatically interact with the system.

Meet AppleScript.

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

With this snippet, I can sync files to the remote every hour. If something goes wrong, I'm alerted to investigate.

Another benefit of packaging my script this way is that macOS will actually treat it like an application. It appears in my dock and it can be set to open when I log in.

This about meets the requirements I set out earlier for this solution. I manage the applicable files locally, and they're available to the web soon with no action needed on my part.

Compared to other tools (cron, systemd), it's unwieldy. However, the ability to smoothly integrate system-level functionality, like notifications, results in a much better user experience for me.

We can actually make one last change to make it even a little better though!

## Replacing a background job with a manual trigger

There's a useful little app called Automator that comes on macOS, which provides similar capabilities to these OSA scripts but behind a GUI.

If your macOS device has a touch bar, it can list any "Quick Action" workflows you create in Automator. Given these actions can run AppleScript, this makes it possible to trigger syncing from the comfort of the touch bar!

Instead of a recurring script, I can trigger syncing from my touch bar!

While it's technically more effort than running my script as an application, but it's a nice tradeoff for being able to sync at my own discretion.

So there you have it, file syncing from my machine to the web!

If you'd like to see the end result, just head to [https://nicholas.cloud/files/](https://nicholas.cloud/files/)!

## Thanks

I wouldn't have known about macOS automation if [Josh Parnham](https://joshparnham.com/) hadn't given a talk on it.

You can find [the slides on GitHub](https://github.com/josh-/automating-macOS-with-JXA-presentation) to see what he spoke about, as well as links to a lot of resources on jumping into automatoin in macOS!

---

As as aside, it's worth noting that you can also convert my AppleScript right back into a shell script. With the `osascript` command you can execute any OSA-complient snippets. For example, this command is perfectly valid.

```sh
osascript -e 'display notification "Hello world!" sound name "frog"'
```
