---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
description: ""
date: {{ now.Format "2006-01-02T15:00:00-0700"  }}
expirydate: {{ dateFormat "2006-01-02T15:00:00-0700" (now.AddDate 0 0 14) }}
---

<!--more-->
