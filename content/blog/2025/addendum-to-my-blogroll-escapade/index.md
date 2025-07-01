---
title: "Addendum to my blogroll escapade"
date: 2025-05-18T20:24:04+10:00
---

Following on from [setting up my blogroll](../committing-xml-horrors-to-style-my-blogroll/) last week, I've realised it doesn't render as a pretty webpage in most web browsers. Serves me right for only testing in Firefox!

<!--more-->

To style the document, I wrote the XLST in an `xsl:stylesheet` element with an `id="blogroll"` attribute. A processing instruction applies the stylesheet to the document.

```xml
<?xml-stylesheet type="text/xsl" href="#blogroll"?>
```

XML processors will look for the stylesheet by its ID, `blogroll` in this case. But when looking at an element, how do know if one of its attributes is an ID? The XML spec [goes into detail about this](https://www.w3.org/TR/xslt20/#embedded).

> In order for such an attribute value to be used as a fragment identifier in a URI, the XDM attribute node must generally have the is-id property [...]. This property will typically be set if the attribute is defined in a DTD as being of type ID, or if is defined in a schema as being of type xs:ID.

Turns out, most processors need the ID attribute to be explicitly labelled. So I added the necessary document type declaration (DTD) explicitly specifying the `ID` attribute for `xsl:stylesheet` elements - in this case called `id`.

```xml
<!DOCTYPE OPML [<!ATTLIST xsl:stylesheet id ID #REQUIRED>]>
```

In Firefox's case, the browser seems to assume `id` will be the ID attribute. As other browsers show though, that isn't a safe assumption.

Anyway with [a fix now in place](https://github.com/nchlswhttkr/website/commit/2570f66992e5bc7b1f31b6ba0a507e2449329245), I hope you enjoy perusing my blogroll!
