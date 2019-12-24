---
title: "Barhack: Linting Buildkite Pipelines"
description: ""
date: 2019-12-23T01:16:43+11:00
layout: "single"
# cover: ""
# utterances: 0
---

<!--more-->

I like using [Buildkite](https://buildkite.com). Heaps.

{{< tweet 1208417061896015872 >}}

So after a bit of trial and error, I had a pipeline set up that met the above conditions.

We can do a bit better though. At the moment, we need to run two full jobs before our file is linted. If we include the linting script as a command for the pipeline itself, rather than a command in the `pipeline.yml` file within the repository, we can skip the pipeline uploading process. This has the added benefit of shaving about 5 seconds of runtime from the pipeline!

This also has the benefit of eliminating a previous problem where a file that passed linting would briefly be marked as failed while the first pipeline upload job had finished but the second linting job had not yet started (or more precisely, had not run its `post-checkout` hook).

https://buildkite.com/nchlswhttkr/barhack/builds/22

https://buildkite.com/nchlswhttkr/barhack/builds/23

https://buildkite.com/nchlswhttkr/barhack/builds/29

https://buildkite.com/nchlswhttkr/barhack/builds/30

```sh
curl \
    -H "Authorization: Bearer $BUILDKITE_TOKEN"\
    -X POST "https://api.buildkite.com/v2/organizations/nchlswhttkr/pipelines/barhack/builds" \
    -d '{
        "commit": "HEAD",
        "branch": "lint-in-single-job",
        "env": {
            "BARHACK_LINT": "true",
            "BARHACK_PIPELINE_TO_LINT": "/tmp/pipeline-to-lint.yml",
            "BARHACK_CREDENTIALS_FILE": "/tmp/buildkite.token"
        }
    }'
```

Could we go further?

We could try pinging the Buildkite API with a pipeline update ourselves, but this would involve parsing the `pipeline.yml` file, which I think negates the purpose of this exercise.
