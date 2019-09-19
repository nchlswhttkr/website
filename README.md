# nchlswhttkr.com

Built using [Hugo](https://gohugo.io/).

If you are reading this on **GitLab**, please note that edits should be made to the upstream [GitHub repo](https://github.com/nchlswhttkr.github.io/).

Icons for this site are modified from those provided by Font Awesome, see their license [here](https://fontawesome.com/license/free/).

Shoutout to [favicon.io](https://favicon.io/) for the favicon, sweet!

<!-- Install git hooks using `scripts/init.sh`, make sure you have [Hugo](https://gohugo.io/install/) installed. -->

**Why not git submodules?**

I wasn't quite able to make this approach work. I ended up getting errors inside a git hook script when trying to execute git commands on the submodule, but I did not encounter these problems when running from CLI. It might be possible to fix these using a certain combination of the `-C`, `--git-dir`, and `--work-tree` flags, but I wasn't able to find the config that worked in a reasonable amount of time.

The current approach (a gitignore'd directory) is easier to maintain and understand.
