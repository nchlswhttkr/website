if (GeoPattern) {
  const pattern = GeoPattern.generate(document.title);
  document.getElementsByTagName(
    "hgroup"
  )[0].style.backgroundImage = pattern.toDataUrl();
}
