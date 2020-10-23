---
title: "Hello World"
description: "Testing out markdown"
date: 2017-01-01T12:00:00+1100
color: "#cc2d79"
---

I use this article to make sure any styling changes I make don't break.

<!--more-->

## Text and images

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sagittis diam id ante euismod condimentum. Curabitur pharetra eget arcu sed euismod. Nunc sed elementum enim, vel lobortis tortor. Donec pretium eros sed ante commodo hendrerit. Phasellus luctus egestas cursus. Vestibulum condimentum nunc eget erat pellentesque eleifend.

### Subheading

Aliquam lobortis a quam ut vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, dui in vehicula ullamcorper, augue nisi elementum sapien, at euismod tellus turpis a ligula. Phasellus nec urna velit. Nam vel tempor erat.

---

Proin vel metus mattis tellus vulputate pretium a a sem. Duis at sem aliquam, suscipit lorem ut, venenatis enim. In at dui tempus lacus auctor commodo id id nunc. Nam sit amet lobortis libero. Aenean at nunc et purus fringilla consectetur. Sed nisi libero, gravida in eros ut, sodales condimentum ex.

This is an example of _emphasised_ test.

This an an example of **bold** text.

This is an example of ~~strikethough~~ text.

This text includes a [link](/).

> This text is in a blockquote

This text includes an `inline code block`.

![A generic image](/media/nicholas.png)

{{% image-caption %}}A caption for the above image{{%/ image-caption %}}

## Tables and lists

This is an unordered list.

-   Foo
    -   Foo
    -   Bar
    -   Baz
-   Bar
-   Baz

This is an ordered list.

1.  The first item
1.  The second item
1.  The third and final item

This is a table.

| Column 1 | Column 2 |
| -------- | -------- |
| A        | B        |
| C        | D        |

## Code block and syntax highlighting

```sh
osascript -e 'display notification "Hello world!" sound name "frog"'
```

```c
#include <stdio.h>

// I'm including this really long line of code to show that scrolling sideways works. Look at how long it is, it just extends off the page!

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

```diff
- rsync --archive --no-times -v          --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
+ rsync --recursive          --verbose   --itemize-changes --checksum --delete $PWD/public/ nicholas@$DEPLOYMENT_IP:/var/www/nicholas.cloud
```

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

```py
class IdentityService:
    """
    Implements all identity-related logic, usually about the current user and
    their current session (whether they are authenticated).
    """

    @staticmethod
    def get_required_session_user(request):
        """
        Will return a user's identity if they are authenticated, but will throw
        if no user is authenticated.
        This can be used to as the first step in handling a request, stopping
        users who are not authenticating from proceeding.
        """
        user = IdentityService.get_session_user(request)
        if user is None:
            raise AuthenticationRequiredException(
                "You are not logged in, authentication is required."
            )
        return user
```

```rs
let database: &str;
let mut path = PathBuf::new(); // Guess Rust wants this declared here

if let Some(value) = matches.value_of("database") {
    database = value
} else {
    let home;
    if cfg!(windows) {
        home = env::var("APPDATA")?;
    } else {
        home = env::var("HOME")?;
    }
    path.push(&home);
    path.push(".bookmark");
    fs::create_dir_all(&path)?;
    path.push("bookmarks.db");
    database = path.to_str().unwrap();
}
```

```css
.blog-article .twitter-tweet {
    /* Isolated hack to override inline styling, sorry */
    width: unset !important;
    margin: 16px auto !important;
}
```

```html
{{% css-hidden-message-demo %}}
```

## Embedded content

{{< tweet 902019752251465728 >}}

{{< youtube "x3HYRYGZtH0" >}}

{{% vimeo "468393883" %}}
