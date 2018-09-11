# nchlswhttkr.github.io

Build using [Hugo](https://gohugo.io).

---

## Getting Started

After cloning, run the following command to set up git hooks.

```
sh scripts/init.sh
```

The `dev` branch is used for templates and content, then the built static site is deployed via `master`. When you commmit to the `dev` branch, the site will be automatically rebuilt and committed via a git hook. It is then deployed when you push from the superproject.

---

_Why not git submodules?_

I wasn't quite able to make this approach work. I ended up getting errors inside a git hook script when trying to git commands on the submodule, but I did not encounter these problems when running from CLI. It might be possible to fix using the `-C`, `--git-dir`, and `--work-tree` flags, but I wasn't able to find the config that worked.

This approach is easier to maintain and understand.
