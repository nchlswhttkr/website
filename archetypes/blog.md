---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
description: ""
date: {{ printf "%sT12:00:00+10:00" ( now.Format "2006-01-02" ) }}
draft: true
slug: "{{ .TranslationBaseName }}"
---

<!--more-->
