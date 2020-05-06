---
title: "A Pretty Little Bit of Rsync"
description: "The unexpectedly lengthy story about improving one line in a script"
date: 2020-04-14T12:00:00.000Z
utterances: 22
---

Recently I've grown to love using [rsync](https://rsync.samba.org/), a tool for transferring files between local and remote destinations.

I hit a bit of a snag though recently when improving an rsync command in the script to deploy my website, so what better opportunity to write about it?

<!--more-->

For context, I use [Hugo](https://gohugo.io) to build my website. Output comes as a collection of static files, and rsync is perfect for copying these files to a web-facing location. In my case, this is a directory served by [Nginx](https://nginx.org/en/).

## Using rsync

With rsync, it's easy to copy a local file to a remote computer.

```sh
rsync ~/Documents/hello.txt nicholas@192.168.1.99:~/
```

Under the hood, rsync establishes an SSH connection and copies over `hello.txt` into the remote user's home directory. If this file already exists, it's updated instead.

It has mechanisms to make this efficient as well, reducing the amount of data in transit over a (comparatively) slow network connection:

-   Skipping files that have likely not changed (same size and modification time)
-   Instead of transferring a whole file, only transmit the changes needed to update it

When it came to my website, I had a few motivations to improve how I was using rsync to deploy:

-   Timestamps were not reliable in identifying new/updated files to transfer
-   Files were being updated on the remote even if their contents had not changed

The last point was of concern because when [Nginx serves static files for my website](https://github.com/nchlswhttkr/website/blob/6cdee73a859c70d8dacd723ec1780114d604315b/nicholas.cloud.nginx#L20), it uses a file's modification timestamp to set the `Last-Modified` header for caching purposes. The less often this timestamp was changed, the more often clients would be able to save resources by falling back to a cached copy of my site.

It was in my interests to help rsync avoid making unnecessary updates while deploying.

## Improving my script

Let's take a look at how the command started out in my deployment script.

```sh
rsync -a --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

This works well enough, updating my website with the latest build artifacts and cleaning up any (removed) files that should no longer with `--delete`. The dangerous option here is that unassuming `-a`, which we'll see later.

The trouble here is that most of these artifacts are generated _during_ a build. Even if they don't change between builds, rsync will still waste time on them because they have a "newer" timestamp.

Since timestamps can't be used to identify a change, another option is to compare a hash of the file contents. Thankfully, rsync supports a `--checksum` option, so now files will be updated if they have a different size or checksum!

```diff
- rsync -a            --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
+ rsync -a --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

I thought this would work well enough, but looking at the remote I could see that timestamps on many files were still being updated. I hadn't changed any content, so why was this happening?

I added in some options to start debugging. Aside from the usual `-v`/`--verbose` for extra information, I used `--itemize-changes` to see exactly how rsync was performing updates.

```diff
- rsync -a                      --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
+ rsync -a -v --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

How does the command play out in my build logs?

```sh
sending incremental file list
.d..t...... ./
.f..t...... 404.html
.f..t...... index.html
.f..t...... index.xml
.f..t...... sitemap.xml
.d..t...... blog/
.f..t...... blog/index.html
.f..t...... blog/index.xml
.d..t...... blog/2017-reflection/
.f..t...... blog/2017-reflection/index.html
...
```

While rsync wasn't modifying any _file contents_, it was modifying _file timestamps_. What could be causing that?

This was the point where I thought to look back over exactly what that `-a` option was doing, to see if it was responsible for this mess. First point of call, the man page!

```
-a, --archive       archive mode; equals -rlptgoD (no -H,-A,-X)
```

So `-a` implies several options, many related to file metadata: owner, group, permissions and, sure enough, **timestamp**.

I had my culprit.

<!-- TODO https://developers.google.com/web/fundamentals/performance/lazy-loading-guidance/images-and-video/#for_video_acting_as_an_animated_gif_replacement -->
<video autoplay="true" muted="true" loop="true" src="https://media.tenor.com/videos/ec4e9072f89d8d86c01e19906df7dcb1/mp4">
<p>An animation of the dancing pallbearers meme.</p>
</video>

With a further option, we can apply a workaround to skip updating timestamps.

```diff
- rsync -a            -v --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
+ rsync -a --no-times -v --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

To go the extra mile though, it's much better to replace `--archive` with the only option I actually need: `--recursive`. It was also a good time to use long names for each option!

```diff
- rsync --archive --no-times -v          --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
+ rsync --recursive          --verbose   --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

Checking back on it a few days later, it seems to be faring well enough!

```sh
$ ls -lR /var/www/nicholas.cloud | grep 'Apr' |sed 's;.*A;A;' | cut -b -12 | sort --unique
Apr 10 04:09
Apr 10 05:49
Apr 11 03:12
Apr 13 06:32
Apr 13 07:34
```

## Is this better/optimal?

While I prefer this updated rsync command, it's worth noting that there a lot of moving partss to consider.

-   The delta-transfer algorithm rsync employs greatly reduces the amount of data transferred when two files are largely similar/identical
-   Generating/comparing checksums may actually be slower than relying on timestamps and the false positives they entail
-   Nginx also employs the `ETag` header in addition to the `Last-Modified` header for certain resources

Is my solution really faster? Does it lead to better caching performance for end users? I don't think you can tell without benchmarking, but that's something to investigate another day.

If you'd like to know more about how rsync functions, I'd recommend checking out the [man page](https://download.samba.org/pub/rsync/rsync.html) and this [higher-level overview](https://rsync.samba.org/how-rsync-works.html)!
