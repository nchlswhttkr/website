---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
description: ""
date: {{ printf "%sT12:00:00.000Z" ( now.Format "2006-01-02" ) }}
expirydate: {{ printf "%sT12:00:00.000Z" ( dateFormat "2006-01-02" (now.AddDate 0 0 14) ) }}
---

<!--more-->
