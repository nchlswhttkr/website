if (GeoPattern) {
  const pattern = GeoPattern.generate(document.title);
  document.body.style.backgroundImage = pattern.toDataUrl();
}
