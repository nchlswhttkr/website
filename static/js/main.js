if (GeoPattern) {
  const pattern = GeoPattern.generate(document.title);
  document.getElementById('hero').style.backgroundImage = pattern.toDataUrl();
}
