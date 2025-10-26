---
title: "Archive"
---

You can find a list of all my blog posts below. Alternatively, you can [browse them by tag](/tags/).

---

{{< archive.inline >}}
{{ range (where .Site.RegularPages "Section" "blog").GroupByDate "2006" }}

<h3>{{ .Key }}</h3>
<p>
    {{ range .Pages }}
    <code>{{ .Date.Format "2006-01-02" }}</code> &bull;
    <a href="{{ .Permalink }}">{{ .Title }}</a><br />
    {{ end }}
</p>
{{ end }}
{{</ archive.inline >}}
