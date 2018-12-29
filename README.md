# [nchlswhttkr.github.io](https://nchlswhttkr.github.io)

Built using [Hugo](https://gohugo.io).

If you are reading this on **GitLab**, please be aware that this is just a mirror of the repository on [GitHub](https://github.com/nchlswhttkr/nchlswhttkr.github.io).

Icons for this site are adapted from those provided by Font Awesome, see their license [here](https://fontawesome.com/license/free).

---

## Getting Started

After cloning, run the following command to set up git hooks.

```
sh scripts/init.sh
```

The `dev` branch is used for templates and content, then the built static site is deployed via `master`. When you commmit to the `dev` branch, the site will be automatically rebuilt and committed via a git hook. It is then deployed when you push from the superproject.

---

**Why not git submodules?**

I wasn't quite able to make this approach work. I ended up getting errors inside a git hook script when trying to git commands on the submodule, but I did not encounter these problems when running from CLI. It might be possible to fix using the `-C`, `--git-dir`, and `--work-tree` flags, but I wasn't able to find the config that worked.

This approach is easier to maintain and understand.
