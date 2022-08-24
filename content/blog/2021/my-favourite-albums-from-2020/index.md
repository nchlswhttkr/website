---
title: "My Favourite Albums From 2020"
description: "Taking the opportunity to share my listening recommendations from the year past"
date: 2021-01-01T19:00:00+1100
cover: "covers.jpg"
coveralt: "A collage of ten assorted album covers"
tags:
    - music
---

![A collage of ten assorted album covers](./covers.jpg)

For me, 2020 was a very quiet year. I spent a lot of time at home, and wasn't out much aside from when I needed to be out. During that time, I found myself drawn to music listening as an escape.

As a way to farewell the year, I thought I'd highlight some of my favourite albums that have come out in the past twelve months.

<!--more-->

You can find links to each album on Bandcamp for easy purchase and streaming. Most of these artists are also on Spotify, Apple Music and YouTube if any of those are your preferred choice.

So now in no particular order, here are my favourite music albums from 2020!

### Strange Satisfaction - Woody & Jeremy

At the end of 2019, I celebrated by taking the plunge and buying the complete Vulfpeck discography after watching their [Madison Square Garden concert](https://www.youtube.com/watch?v=rv4wf7bzfFE) online. When I heard my favourite member, Woody Goss, was doing an album with a friend of his, I was all ears!

The album itself is absolutely funky in my book, and it all just feels remarkably _human_. Perhaps that's to the credit of Jeremy's singing. This album was there for me in a particularly rough time of the year, and it feels like good closure to mention it now.

An interesting discovery I stumbled upon with this album is that the digital download includes a hidden eight track! Whether that a little treat or a mistake in publishing I'm not sure, but I enjoy the bonus nonetheless.

{{< bandcamp-album woodyandjeremy strange-satisfaction >}}

### The Joy of Music, The Job of Real Estate - Vulfpeck

Vulfpeck also released an album as a band in 2020. Some songs in the release have been available online for years, but like that they're collected into a proper release.

The final track for this album was auctioned off to the highest bidder on eBay, with the proceeds going to charity. I've seen fans divided over it, but I like the sellout song.

{{< bandcamp-album vulfpeck the-joy-of-music-the-job-of-real-estate-2 >}}

### Don't Shy Away - LOMA

Sometimes, I sit on Bandcamp's home page to watch the live feed of purchases go by. _Don't Shy Away_ was one of the albums I saw flash by one day, and decided to give it a go.

I find it calming to put this on from time to time. I'm hoping to see more music from LOMA in coming years, but first I also need to try their earlier music. I'll get to it in due time!

{{< bandcamp-album lomamusic dont-shy-away >}}

### Realign - Red Vox

One of my completely new discoveries this year was the band Red Vox. Rock isn't always my genre, but I enjoy the band's sound and I've frequently listened to this album since buying it.

This is also the first album I've bought on vinyl, and I'm looking for working my way back through Red Vox's discography in the near future.

{{< bandcamp-album vine realign >}}

### Lost For A While - Red Vox

_Realign_ also had a follow-up album incorporating a collection of songs that didn't make it onto the initial release. Seeing as this album also came out in 2020, it's fair game to include here!

{{< bandcamp-album vine lost-for-a-while-ep >}}

### A Short Hike - Mark Sparling

I bought the game [A Short Hike](https://ashorthike.com/) as part of a bundle around the middle of the year, and thoroughly enjoyed playing it. Its soothing soundtrack is rife with the acoustic sounds of guitars, pianos and percussion, and it's a fitting accompaniment for protagonist Claire's adventure.

This release includes both full-length and abridged versions of various pieces, since many pieces are designed to be blended to weave in with gameplay.

Now, _technically_ this album was released in 2019, but I'm keeping it in since additional tracks were added with an expansion that released a few months ago. Hooray for technicalities!

{{< bandcamp-album marksparling a-short-hike-original-soundtrack >}}

### That Place, Our Place - Callum Mintzis

Another quiet album I loved was this collection of pieces for keys and strings. I think it's nice to have something softer in contrast to some of the more upbeat and energetic music I listen to.

This is the only album I've mentioned here that's from an Australian artist. I'm endavouring to see more live music performances in Melbourne this year, so hopefully I'll have more local artists to show off next time!

{{< bandcamp-album callummintzis that-place-our-place >}}

### Songs of Supergiant Games - Darren Korb & Ashley Barrett

The team at Supergiant Games celebrates a decade of games with a selection of reorchestrated songs from all of their games.

I'll freely admit that I still need to play several of their games – I'm yet to finish Pyre and I still need to start Hades – but the soundtracks all sit close to me in my music library.

One last thing that amuses me with these arrangements is that they successfully balance a full trombone section (up to three) against only a couple of violins. This is hard to do with an acoustic ensemble, but modern recording/mastering makes it pleasant to my ear!

{{< bandcamp-album supergiantgames songs-of-supergiant-games >}}

### Carry Me Home - KOKOROKO

While technically only a _single_ and not an _album_, I am a big fan of KOROKOKO's afrobeat sound. They've only got a few songs to their name, but I eagerly await more releases! You can find all of their music on Bandcamp, so I'd encourage you to check them out.

{{< bandcamp-album kokoroko carry-me-home >}}

### Modern Johnny Sings: Songs in the Age of Vibe - Theo Katzman

My last album is from another Vulfpeck member, if that suggests a pattern. Theo has a golden voice, with the lyricism to match.

{{< bandcamp-album theokatzman modern-johnny-sings-songs-in-the-age-of-vibe >}}

So there you have it, that's my musical 2020 wrapped! I hope you find something that you're able to enjoy like I did!

---

Shoutout to ImageMagick, I was able to make a pretty collage of all the album covers for this post!

```sh
#!/bin/bash
rm covers.jpg
magick -size 1120x560 xc:wheat -borderColor wheat \
    \( satisfaction.jpg -resize 240x240 -shave 4 -border 4 \) -geometry +0+0 -composite \
    \( joy.jpg -resize 240x240 -shave 4 -border 4          \) -geometry +220+12 -composite \
    \( loma.jpg -resize 240x240 -shave 4 -border 4         \) -geometry +440+24 -composite \
    \( realign.jpg -resize 240x240 -shave 4 -border 4      \) -geometry +660+36 -composite \
    \( vox.png -resize 240x240 -shave 4 -border 4          \) -geometry +880+48 -composite \
    \( hike.png -resize 240x240 -shave 4 -border 4         \) -geometry +0+272 -composite \
    \( place.jpg -resize 240x240 -shave 4 -border 4        \) -geometry +220+284 -composite \
    \( supergiant.jpg -resize 240x240 -shave 4 -border 4   \) -geometry +440+296 -composite \
    \( kokoroko.jpg -resize 240x240 -shave 4 -border 4     \) -geometry +660+308 -composite \
    \( theo.jpg -resize 240x240 -set colorspace CYMK -colorspace sRGB -shave 4 -border 4 \) -geometry +880+320 -composite \
    -gravity center -background wheat -extent 1280x720 \
    covers.jpg
```
