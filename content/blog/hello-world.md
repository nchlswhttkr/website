---
title: "Hello World"
description: "Testing out markdown"
date: 2017-01-01T12:00:00+10:00
---

I use this article to make sure any styling changes I make don't break.

<!--more-->

## Heading 2

### Heading 3

Aliquam lobortis a quam ut vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, dui in vehicula ullamcorper, augue nisi elementum sapien, at euismod tellus turpis a ligula. Phasellus nec urna velit. Nam vel tempor erat. Proin vel metus mattis tellus vulputate pretium a a sem. Duis at sem aliquam, suscipit lorem ut, venenatis enim. In at dui tempus lacus auctor commodo id id nunc. Nam sit amet lobortis libero. Aenean at nunc et purus fringilla consectetur. Sed nisi libero, gravida in eros ut, sodales condimentum ex.

_italics_

**bold**

~~strike~~

Text<sub>with subtext</sub>

Text<sup>with supertext</sup>

Text with [a link](/) in it.

> "I have definitely said these things" - _Nicholas Whittaker_

---

-   Foo
    -   Foo
    -   Bar
    -   Baz
-   Bar
-   Baz

1.  The first item
1.  The second item
1.  The third and final item

---

| Column 1 | Column 2 |
| -------- | -------- |
| A        | B        |
| C        | D        |

---

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
.show-text::after {
    content: "A special message!";
    color: var(--theme-color);
    background-color: var(--light-color);
    font-weight: 700;
}
```

```html
{{% css-hidden-message-demo %}}
```

I maintain the site source code on the `dev` branch, then deploy builds from `master`.

---

![An image](/media/nicholas.png)

{{% image-caption %}}A caption for the above image{{%/ image-caption %}}

![An image](/media/monty.jpg)

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac porttitor metus. Nam suscipit euismod orci at sagittis. Donec vitae convallis enim. Pellentesque iaculis, ligula eu condimentum sodales, nulla metus blandit diam, non maximus tellus dolor vitae ipsum. Aliquam at cursus lacus, eget eleifend quam.

---

Aliquam lobortis a quam ut vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, dui in vehicula ullamcorper, augue nisi elementum sapien, at euismod tellus turpis a ligula. Phasellus nec urna velit. Nam vel tempor erat. Proin vel metus mattis tellus vulputate pretium a a sem. Duis at sem aliquam, suscipit lorem ut, venenatis enim. In at dui tempus lacus auctor commodo id id nunc. Nam sit amet lobortis libero. Aenean at nunc et purus fringilla consectetur. Sed nisi libero, gravida in eros ut, sodales condimentum ex.

{{< tweet 902019752251465728 >}}

{{< youtube "x3HYRYGZtH0" >}}

{{% vimeo "452492906" %}}
