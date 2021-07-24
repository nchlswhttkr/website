---
title: "Exporting iCloud reminders to Fastmail"
date: 2021-07-24T15:00:00+1000
tags:
    - ios-shortcuts
---

If you've snooped the MX records for this site recently, you might have noticed that I've moved to Fastmail. In addition to email hosting, Fastmail also offers CalDAV accounts for users, so I'm trying it out for my calendar and reminders.

While the Apple ecosystem supports CalDAV accounts, they don't make it easy for you to export your reminders from iCloud into your account of choice. A Reddit post points out that it _is_ possible to copy these reminders across with the Shortcuts app though, so I decided to give that a try. Here's a test run with a simple list of reminders.

![Two lists of reminders, one labelled "Test" containing two items, and an empty one label "Test Fastmail"](./1.png)

There's a few catches with the approach to be aware of, since iCloud reminders have some exclusive (CalDAV-incompatible) features.

-   If the reminder has notes attached, they need to be included in the _Notes_ of the "Create reminder" widget or they won't be copied
-   Some details can't be transferred - namely attached photos, due dates and URLs

When selecting the reminders to migrate, you'll want to filter out completed reminders. When the reminders are created in your new list, they'll be marked as incomplete.

Interestingly, a confirmation prompt shows up when deleting reminders. If you're deleting many at once (I had one list of about ~70 reminders), you'll have to OK it several times before the shortcut proceeds.

![A confirmation prompt, reading "Remove 2 reminders? This is a permanent action. Are you sure you want to remove these items?"](./2.png)

Afterwards the shortcut finishes running, all of your reminders will have moved across and you'll be good to go!

![The same list of reminders as before, but the reminders in the "Test" list have moved to the "Test Fastmail" list](./3.png)

Here's the shortcut I wrote, if you'd like to use it.

![omit-alt-text](./4.png)
