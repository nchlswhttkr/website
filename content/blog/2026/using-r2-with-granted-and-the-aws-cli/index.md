---
title: "Using R2 with Granted and the AWS CLI"
date: 2026-07-14T23:55:16+10:00
tags:
    - aws
    - cloudflare
---

Recently, I've been exploring [Cloudflare's R2 service](https://developers.cloudflare.com/r2/), an S3-compatible object store.

At home and work, I use [Granted](https://granted.dev/) to manage my AWS credentials and sessions. It's a convenient wrapper for switching between multiple accounts without polluting my local environment.

Given R2 is meant to be a (largely) drop-in replacement for S3, I thought I'd do a quick writeup on what's needed to use R2 credentials with the AWS CLI.

<!--more-->

To start, I'm assuming [Granted is installed](https://docs.commonfate.io/granted/getting-started#installing-the-cli) and set up with your credential manager of choice. I use [pass](https://www.passwordstore.org/).

Generate an account API token [via the dashboard](https://dash.cloudflare.com/?to=/:account/api-tokens), copying the provided S3-compatible credentials. If you have existing API tokens for R2, you can derive credentials per [the documentation](https://developers.cloudflare.com/r2/api/tokens/#get-s3-api-credentials-from-an-api-token).

Add these credentials into Granted.

```sh
granted credentials add cloudflare
```

Granted should begin populating your `~/.aws/config` with the `cloudflare` profile.

You should update this profile to use an alternate S3 endpoint, providing your account's dedicated R2 endpoint. It's best that the `region` corresponds to [your preferred bucket location](https://developers.cloudflare.com/r2/reference/data-location/#available-hints).

```ini
[profile cloudflare]
region             = oc # https://developers.cloudflare.com/r2/reference/data-location/#available-hints
credential_process = granted credential-process --profile=cloudflare
services           = cloudflare

[services cloudflare]
s3 =
  endpoint_url = https://<your-account-id>.r2.cloudflarestorage.com
```

With your AWS configuration set up, it's a quick matter to `assume` and access your R2 buckets. Done!

```sh
assume cloudflare
aws s3 ls
```
