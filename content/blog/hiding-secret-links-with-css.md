---
title: "Hiding Secret Links With CSS"
description: "There's beauty all around, even in the inlined styles of a webpage"
date: 2020-06-08T12:00:00+1000
tags:
    - css
    - webdev
---

Every now and then I like to browse the hiring pages of companies I like and admire.

Last week, I noticed an opening that didn't feature the usual prominent call-to-action prompt to apply.

Instead of a button or a link, there was only a message with instructions for applicants.

<!--more-->

> "To apply, submit [...] at the URL that appears when you append the class [`secret-class`] to this tag."

Alright then. A few clicks in devtools give the paragraph its `secret-class`. Lo and behold, a URL appears!

> "To apply, submit [...] at the URL that appears when you append the class [`secret-class`] to this tag. **bit.ly/...**"

So what's the secret sauce that makes this link show up?

A further glance at devtools points to a few inlined styles in the page. Here's the key excerpt.

```css
.secret-class::after {
    content: " bit.ly/...";
    color: #6ba53a;
    font-weight: 600;
}
```

Let's break it down.

Once the target paragraph has the necessary class, the CSS selector kicks in. It creates a special [`::after` pseudo-element](https://developer.mozilla.org/en-US/docs/Web/CSS/::after) that's placed after all of the paragraph's content.

The [`content` property](https://developer.mozilla.org/en-US/docs/Web/CSS/content) used inside the block is a special property that only applies to `::before` and `::after` pseudo-elements. It replaces them with a provided value. In the case of this job posting, that's the application link! With a few more properties to make the link pretty, we've got a cleverly hidden link!

Why employ a move like this? I could hazard a few guesses.

-   A hurdle for applicants to prove some level of familiarity with web tools and development (a requirement of the job)
-   Obscuring the application link encourages applicants to read the complete posting, rather than skimming the page and hitting apply
-   Dissuade third parties (web crawlers, recruiters) from finding and sharing the application link

At the end of the day though, I'm just hypothesising.

My concern with this approach is its accessibility. It's hard to be certain that CSS `content` will be visible to those using assistive technologies, especially screen readers.

This could even be seen as discriminatory, preventing a particular audience from applying for the job. In the case of sufficiently inaccessible content, [adding an `aria-label`](https://www.w3.org/TR/WCAG20-TECHS/ARIA14.html) can make a world of difference. Even with this label, the link itself remains visually hidden!

As an extra step, you can share the link between the `aria-label` and its paragraph using the [`attr()` CSS function](https://developer.mozilla.org/en-US/docs/Web/CSS/attr)!

---

You can see it in action here.

{{% css-hidden-message-demo %}}

```html
{{% css-hidden-message-demo %}}
```
