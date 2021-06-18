part of amap_core;

class PoiResult {
  final List<PoiItem> pois;

  final int pageCount;

  final List<String> searchSuggestionKeywords;

  const PoiResult({
    this.pageCount = 0,
    this.pois = const [],
    this.searchSuggestionKeywords = const [],
  });
}
