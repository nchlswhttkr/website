---
title: "DDD Melbourne 2019"
description: "A conference reflection"
date: 2019-08-13T12:00:00+10:00
draft: false
slug: "ddd-melbourne-2019"
---

I had the pleasure of attending DDD Melbourne this past weekend, seeing talks from many people in Melbourne's tech space. Across 5 tracks of talks, there was a wide array of presentations on a variety of technical, personal and professional topics.

<!--more-->

I mightn't have been able to attend all the presentations on the day, but there's no harm in writing about the ones I was able to see!

I was originally planning to write up my thoughts on all of the presentations. I've since changed my mind and limited discussion to some of the meatier bits.

First of all the least I can do is give thanks to the team at [JuniorDev](https://juniordev.io), who gave me a discount code to attend DDD. They run monthly meetups where members from Melbourne's tech community can give presentations.

![A photo of the DDD 10th anniversary logo, with the inset caption "It's a great day"](./snap.png)

## API Development

[Rob Crowley](https://twitter.com/robdcrowley) / [Slides](https://speakerdeck.com/robcrowley/graphql-grpc-or-rest-resolving-the-api-developers-dilemma)

Admittedly a lot of this talk when over my head. Having usually worked as a frontend developer with usually REST-style APIs, I was able to recognise SOAP, but terms like gRPC/OData went over my head.

The most important takeaway for me was recognising that more often than not, the architecture/development of a solution is dictated by its environment and the requirements set out for it.

This can include considerations like the expected API consumers, where you might only need to cater to a single application/process, or you may need to make something generally available to a wider audience (think public APIs like Reddit or Twitter). You could go for a standard response format with a resource-focused approach like REST, or allow clients to refine a query for their own convenience, a-la GraphQL.

## Microfrontends

Michael King

_Forenote, I was late for the first 10-15 minutes of this talk while I was speaking with one of the event sponsors. If I've misunderstood something, feel free to let me know so I can correct it._

Microfrontends, similar to the microservice architecture pattern, focus around decomposing a monolithic frontend into smaller applets with specific purposes. As the user navigates through sub-pages of your site, bundles/static content are lazy-loaded as needed.

The main strength I found appealing with this approach is that it allows for frontend applets to be updated independently of the entire frontend. For example, an update to the `/billing` applet would not need to interfere with other applets like `/account` and `/dashboard`, since the deployment would only touch files isolated to a specified applet.

Since each applet is self-sufficient, its maintenance can be handled by a single team as well. There is less need to coordinate/align releases between teams, allowing them to move at their own rates and without stepping on each other's toes.

The cost of using microfrontends is that you can't (easily) share state between applets, as they're not "aware" of each other. Sharing code is also not possible/simple, meaning applets might waste client resources downloading the same frontend framework and button components each time the user goes from page to page.

In short, the simultaneous strength and weakness of microfrontends is that each applet is self-contained. The isolation grants a great deal of independence, but requires a worst-case assumption when it comes to external dependencies. That is, nothing is shared and everything must be loaded.

I can see the case for microfrontends, with large frontends maintained by multiple teams. I think I'd be a bigger fan if code-sharing was a greater focus (a-la jQuery days), allowing common dependencies (bulky frontend frameworks, company design system components) to be loaded once only. This does go against the core concept of independence though.

## Imposter Syndrome

[Cameo Langford](https://www.cameocodes.com/)

Cameo's presentation covered her transition into the IT industry and her role at MYOB. I won't be writing up her story here in a blog post, but I'm glad that she managed to get up and present for the JuniorDev track. It takes a lot to get up on stage and talk to a room of (largely) strangers about what it's like to deal with personal problems and impostor syndrome, and not something I'd feel ready to be open about in such an exposed setting.

It was very endearing to see her team at MYOB listening from the front row. The key component of a strong team is the human element, something that sits above the actual work that a team performs. To me, it's the birthday lunches and the chatter in the office that make a team strong. Today it was the attendance and support from the whole team in attending the talk. The team isn't an entity, it's the people inside that matter.

Impostor syndrome is something that's rife in the world of IT. New languages, frameworks and paradigms pop up every second week. Job adverts are only ever looking for the best polyglots with years of experience across numerous platforms and environments. At conferences and meetups you can find people with thousands of followers on Twitter and hundreds of stars on their open source repos - it's a crowded room, and it's easy to feel "less" than those around you.

To feel inadequate in an environment like this isn't surprising. I'm sure there are studies showing that impostor syndrome affects a large portion of the tech community, whether intermittently or ongoing. With my graduate job applications and the mixed results I've been having I know I've felt a great deal of doubt in my own knowledge and abilities too in the last few months.

Most importantly, value the people around you. Whether they're coworkers or friends, whether from IT or outside. Value them.

Thank you for speaking Cameo.

_I'm also stealing your "dog picture break" idea for my own presentations._

## Junior Developer Panel

[Terence Huynh](https://twitter.com/terencehuynh) (Moderator) / Kate Illsley / Amir Moghimi / Erin Zimmer / Sabrina Swatee

After a lunch break and a breather from the morning presentations, I made my way back up to the JuniorDev track for a Q&A-style panel focusing around the role of junior developers.

There were different areas covered in the panel

- Bootcamps and alternative pathways into the IT industry, along with the benefits/drawbacks they bring
- Plateuing as a developer, and finding the drive to continue grow
- The traits that differentiate junior developers from more senior roles, and how to know what to work on

An interesting discussion focused around the difference between junior developers and mid/senior developers. It's a mix of the individual's self-perception, and it's contextual to the business/environment/work accomplished.

A more lighthearted moment was when everyone in the room was asked to raise their hand if they'd ever broken something in prod. A sea of hands followed. It's a gentle reminder that no developer is perfect, and that mistakes can be made by anyone at any stage of a software project. What's more important is to care about fixing the problem quickly and effectively when it's caught.

## Notifications and Dark Patterns

[Bec Martin](https://twitter.com/coder_bec)

In general, we no longer pay attention to the ominous notification badge on our apps. Case in point, there are many people with thousands of unread emails on their phone home screens.

The continuous spam of low-quality content through these high-priority channels (push notifications, popups, notification badges) has lead to users devauling them and even ignoring them.

Australia has a special case where text messages are still usually treated as important.

Differing between communications in terms of importance feels like the best route, but of course everyone argues their communications are important. You could consider limiting the rate of non-critical communication, but then you leave yourself to the whims of a release schedule or the like.

Services like Gmail offer to only send notifications for "important" emails (blindly guessed by a black box), but I'm part of the crowd that fears missing that one critical email.

## Serverless

[Matt Tyler](https://matthewtyler.io/)

An interesting opinion espoused was about caring less about the performance and price in decision-making, as these metrics can vary with time. Engineers working for the service providers are paid to optimise these systems and to improve the infrastructure as a whole. Care more about the service itself and whether the functionality/capability benefits you. I'm still not sure I entirely agree with this, but the reasoning is sensible.

His talk also made me harken back to past work at Monash University, where we were building a solution primarily on AWS Lambda. A problem that we'd found irritating with AWS Lambda as a service was the cold starts, which could lead to response times upwards of 15 seconds in select scenarios (there's enough to this for a separate blog post). Over the course of development, we'd seen this time occassionally drop closer to 3-5 seconds. A hypothesis was that AWS had done something to enable faster cold starts for Lambda function needing to execute inside a VPC. During his talk Matt showed that new developments were getting these problematic cold starts down to a much more acceptable response time (just shy of 1 second).

In this case, the performance of our chosen service had gradually improved over time, all without any action/optimisation on our end as the customer. I don't think it's wise to take these kinds of performance improvements for granted, but it does bear keeping in mind that they can occur.

## Performance & Scale

[Marcel Dempers](https://marcel.guru/)

When it comes to work in large systems, problems can arise from anywhere in the pipeline. Understanding the complete stack is important if performance matters. In the case of Marcel's work, handling an incredibly high volume of requests, there was work done in many places.

- The code itself
- The debugging tools you use
- The generation of mock requests
- Monitoring/measuring the performance of the system

## Locknote

[Aaron Powell](http://www.aaron-powell.com/)

Aaron was kind enough to speak at Monash University earlier this year, giving an introduction to Docker ("_from scratch_" :laughing:) as a part of Techfest, a week-long event organised by [WIRED Monash](https:wired.org.au).
I can see why this was the closing talk. Nostaligia kick for sure.

## Stray thoughts

I've got a few last thoughts that don't really tie themselves to any particular talk, but I still feel like noting down.

- Sponsor bingo was great fun and an effective way to encourage interaction between attendees and sponsors. It made it easier for sponsors to strike up a conversation with attendees, as they visited each stall for a stamp.
- It was good to see coloured lanyards for photo opportunities (a yellow lanyard for those who didn't want pictures of them taken). If resources/planning allow, a middleground colour for "permission first" would be great to see - that may just be my personal preference though.
- There's got to be a designer out there who will come up with a double-sided name tag, I had to flip my lanyard over so many times that day.

Going to DDD this year has been a fantastic experience, and has me excited to be part of more of these events in future.

<span class="center-text"><strong>Until DDD Melbourne 2020!</strong></span>
