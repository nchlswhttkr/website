---
title: "Using Buildkite OIDC with Hashicorp Vault"
date: 2023-09-19T17:54:23+10:00
tags:
    - buildkite
    - hashicorp-vault
---

Earlier this year, Buildkite announced [support for OpenID Connect tokens](https://buildkite.com/changelog/197-oidc-support-is-now-available). Briefly, a Buildkite agent can request a signed JWT (JSON Web Token) from Buildkite representing details (claims) about its current job. This JWT can then be used to authenticate with systems that accept it.

For Hashicorp Vault, services typically authenticate using [the AppRole method](https://developer.hashicorp.com/vault/docs/auth/approle) with a senstive set of credentials. It's fine to use this flow on a Buildkite agent to access Vault secrets, but the credentials for this are long-lived.

The new OIDC flow removes to need to manage these long-lived credentials, and also makes it possible to craft fine-grained policies for a Buildkite agent without requiring multiple sets of login credentials!

<!--more-->

I currently run my general-purpose CI workloads on [a single autoscaling cluster of Buildkite agents](https://buildkite.com/docs/agent/v3/elastic-ci-aws/elastic-ci-stack-overview). This lean approach is great for me since I don't have the need to scale or segment my CI setup like a larger organisation might.

There are shortcomings though to all my pipelines sharing these agents. Each pipeline may have its own secrets, but agents must have access to _all of them_ because they could run jobs from _any_ pipeline. Even if secrets follow least privilege practices, an agent's overly broad access grows with each new secret.

As an example, here's a policy that allows secrets in a key-value store matching the path `buildkite/*` to be read.

```terraform
resource "vault_policy" "buildkite_agent" {
  name = "buildkite-agent"
  policy = <<-POLICY
    path "kv/data/buildkite/*" {
      capabilities = ["read"]
    }
  POLICY
}
```

An authenticated agent running a job for the `chocolate` pipeline can read the `buildkite/chocolate` secret, but there's nothing stopping it from _also_ reading the `buildkite/strawberry` secret.

Without dedicated agents for each pipeline, jobs have unchecked access to all `buildkite/*` secrets. Setting up OIDC authentication for my agents instead provides an alternative method to enforce stricter policies and limit access.

First off, we need to create the Vault backend that will accept the JWTs obtained from Buildkite.

```terraform
resource "vault_jwt_auth_backend" "buildkite" {
  path               = "buildkite"
  oidc_discovery_url = "https://agent.buildkite.com"
}
```

A new role for this backend dictates the requirements to log in with a JWT. Setting the `bound_audiences` and `bound_claims` is important to ensure the JWTs are intended for my Vault instance and that they belong to my Buildkite organisation.

```terraform
resource "vault_jwt_auth_backend_role" "buildkite_agent" {
  backend        = vault_jwt_auth_backend.buildkite.path
  role_name      = "buildkite-agent"
  token_policies = ["default", vault_policy.buildkite_agent.name]
  role_type      = "jwt"
  user_claim     = "sub"

  bound_audiences = ["vault.nicholas.cloud"]
  bound_claims = {
    organization_slug = "nchlswhttkr"
  }

  claim_mappings = {
    pipeline_slug = "pipeline_slug"
  }
}
```

The `claim_mappings` block above specifies metadata to be copied from the JWT's claims, in this case the `pipeline_slug` denoting the pipeline the job belongs to.

The metadata can be referenced in a role's policies using [template syntax](https://developer.hashicorp.com/vault/docs/concepts/policies#templated-policies), which we can use to limit the `buildkite-agent` policy from before.

```diff
  resource "vault_policy" "buildkite_agent" {
    name = "buildkite-agent"
    policy = <<-POLICY
-     path "kv/data/buildkite/*" {
+     path "kv/data/buildkite/{{identity.entity.aliases.${vault_jwt_auth_backend.buildkite.accessor}.metadata.pipeline_slug}}" {
        capabilities = ["read"]
      }
    POLICY
  }
```

The template itself is a little cumbersome, but the resulting policy works like a charm. For a job to read the `buildkite/chocolate` secret now, it must originate from the `chocolate` pipeline.

```hcl
path "kv/data/buildkite/{{identity.entity.aliases.auth_jwt_e9c0606b.metadata.pipeline_slug}}" {
  capabilities = ["read"]
}
```

Logging into Vault now requires only the short-lived token from Buildkite!

```sh
vault write auth/buildkite/login role=buildkite-agent \
  jwt="$(buildkite-agent oidc request-token --audience vault.nicholas.cloud)"
```
