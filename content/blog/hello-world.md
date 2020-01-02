---
title: "Hello World"
description: "Testing out markdown"
date: 2017-01-01T12:00:00+10:00
layout: "single"
utterances: 1
---

I use this article to make sure any styling changes I make don't break.

<!--more-->

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6

Aliquam lobortis a quam ut vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, dui in vehicula ullamcorper, augue nisi elementum sapien, at euismod tellus turpis a ligula. Phasellus nec urna velit. Nam vel tempor erat. Proin vel metus mattis tellus vulputate pretium a a sem. Duis at sem aliquam, suscipit lorem ut, venenatis enim. In at dui tempus lacus auctor commodo id id nunc. Nam sit amet lobortis libero. Aenean at nunc et purus fringilla consectetur. Sed nisi libero, gravida in eros ut, sodales condimentum ex.

_italics_

**bold**

~~strike~~

Text<sub>with subtext</sub>

Text<sup>with supertext</sup>

Text with [a link](https://nchlswhttkr.com/) in it.

> "I have definitely said these things" - _Nicholas Whittaker_

---

- Foo
  - Foo
  - Bar
  - Baz
- Bar
- Baz

1.  The first item
1.  The second item
1.  The third and final item

- [ ] Incompete
- [x] Complete

---

```c
#include <stdio.h>

// I'm including this really long line of code to show that scrolling sideways works.

int main () {
  printf("Hello world!\n");
  return 0;
}
```

```ts
// Refer to https://tools.ietf.org/html/rfc6265.html#section-4.1 for grammar

export default class CookieReader {
  /**
   * Attempts to obtain the value of the 'csrftoken' cookie (expected from
   * Django), and falls back to an empty string when one is not found.
   */
  static getCsrfToken(): string {
    const match = document.cookie.match(
      /csrftoken="?([\u0021\u0023-\u002B\u002D-\u003A\u003C-\u005B\u005D-\u007E]*)"?/
    );
    return match ? match[1] : "";
  }
}
```

I maintain the site source code on the `dev` branch, then deploy builds from `master`.

---

![An image](/media/nicholas.png)

{{% image-caption %}}A caption for the above image{{%/ image-caption %}}

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac porttitor metus. Nam suscipit euismod orci at sagittis. Donec vitae convallis enim. Pellentesque iaculis, ligula eu condimentum sodales, nulla metus blandit diam, non maximus tellus dolor vitae ipsum. Aliquam at cursus lacus, eget eleifend quam.

---

Aliquam lobortis a quam ut vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, dui in vehicula ullamcorper, augue nisi elementum sapien, at euismod tellus turpis a ligula. Phasellus nec urna velit. Nam vel tempor erat. Proin vel metus mattis tellus vulputate pretium a a sem. Duis at sem aliquam, suscipit lorem ut, venenatis enim. In at dui tempus lacus auctor commodo id id nunc. Nam sit amet lobortis libero. Aenean at nunc et purus fringilla consectetur. Sed nisi libero, gravida in eros ut, sodales condimentum ex.

{{< tweet 902019752251465728 >}}
