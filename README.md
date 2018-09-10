# nchlswhttkr.github.io

Build using [Hugo](https://gohugo.io).

## Getting Started

After cloning, run the following command to set up git submodules and hooks.

```
sh scripts/init.sh
```

The `dev` branch is used for templates and content, then the built static site is deployed via `master`. When you commmit to the `dev` branch, the site will be automatically rebuilt and deployed via a pre-commit hook.
