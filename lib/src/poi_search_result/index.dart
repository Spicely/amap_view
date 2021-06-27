part of amap_core;

class PoiSearchResult {
  final List<PoiSearchItem> pois;

  final int pageCount;

  final PoiSearchQuery query;

  final List<String> searchSuggestionKeywords;

  const PoiSearchResult(
    this.searchSuggestionKeywords,
    this.pageCount,
    this.query,
    this.pois,
  );

  factory PoiSearchResult.fromJson(Map<dynamic, dynamic> json) => _$PoiSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$PoiSearchResultToJson(this);
}

class PoiSearchQuery {
  final LatLng location;

  final String building;

  final String category;

  final String city;

  final bool cityLimit;

  final String extensions;

  final bool isDistanceSort;

  final bool isSpecial;

  final int pageNum;

  final int pageSize;

  final String queryString;

  PoiSearchQuery(
    this.location,
    this.building,
    this.category,
    this.city,
    this.cityLimit,
    this.extensions,
    this.isDistanceSort,
    this.isSpecial,
    this.pageNum,
    this.pageSize,
    this.queryString,
  );

  factory PoiSearchQuery.fromJson(Map<dynamic, dynamic> json) => _$PoiSearchQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PoiSearchQueryToJson(this);
}

PoiSearchQuery _$PoiSearchQueryFromJson(Map<dynamic, dynamic> json) {
  return PoiSearchQuery(
    json['location'] as LatLng,
    json['building'] as String,
    json['category'] as String,
    json['city'] as String,
    json['cityLimit'] as bool,
    json['extensions'] as String,
    json['isDistanceSort'] as bool,
    json['isSpecial'] as bool,
    json['pageNum'] as int,
    json['pageSize'] as int,
    json['queryString'] as String,
  );
}

Map<String, dynamic> _$PoiSearchQueryToJson(PoiSearchQuery instance) => <String, dynamic>{
      'location': instance.location.toJson(),
      'building': instance.building,
      'category': instance.category,
      'city': instance.city,
      'cityLimit': instance.cityLimit,
      'extensions': instance.extensions,
      'isDistanceSort': instance.isDistanceSort,
      'isSpecial': instance.isSpecial,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
      'queryString': instance.queryString,
    };

PoiSearchResult _$PoiSearchResultFromJson(Map<dynamic, dynamic> json) {
  return PoiSearchResult(
    json['searchSuggestionKeywords'] as List<String>,
    json['pageCount'] as int,
    PoiSearchQuery.fromJson(json['query'] as Map<dynamic, dynamic>),
    (json['pois'] as List<Map<dynamic, dynamic>>).map((e) => PoiSearchItem.fromJson(e)).toList(),
  );
}

Map<String, dynamic> _$PoiSearchResultToJson(PoiSearchResult instance) => <String, dynamic>{
      'searchSuggestionKeywords': instance.searchSuggestionKeywords,
      'pageCount': instance.pageCount,
      'query': instance.query.toJson(),
      'pois': instance.pois.map((e) => e.toJson()).toList(),
    };
