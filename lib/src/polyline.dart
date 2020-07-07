part of amap_view;

@immutable
class PolylineId {
  PolylineId(this.value) : assert(value != null);

  /// value of the [PolylineId].
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final PolylineId typedOther = other;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'PolylineId{value: $value}';
  }
}

@immutable
class Polyline {
  Polyline({
    @required this.polylineId,
    this.width = 10.0,
    this.visible = true,
    this.zIndex = 0.0,
    this.color = Colors.blue,
    this.points,
    this.onTap,
  }) : assert(points != null),
        assert(width == null || (0.0 <= width && width <= 50.0));

  final PolylineId polylineId;
  final double width;
  final bool visible;
  final double zIndex;
  final Color color;
  final List<LatLng> points;
  final VoidCallback onTap;

  Polyline copyWith({
    double widthParam,
    bool visibleParam,
    double zIndexParam,
    Color colorParam,
    List<LatLng> pointsParam,
    VoidCallback onTapParam,
  }) {
    return Polyline(
      polylineId: polylineId,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      color: colorParam ?? color,
      points: pointsParam ?? points,
      onTap: onTapParam ?? onTap,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent('polylineId', polylineId.value);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('width', width);
    addIfPresent('color', color.value);
    addIfPresent('points', points.map((i)=> i.toJson()).toList());
    return _data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Polyline typedOther = other;
    return polylineId == typedOther.polylineId;
  }

  @override
  int get hashCode => polylineId.hashCode;

  @override
  String toString() {
    return 'Polyline{polylineId: $polylineId, width: $width, color: $color, '
        'visible: $visible, zIndex: $zIndex, onTap: $onTap}';
  }
}

Map<PolylineId, Polyline> _keyByPolylineId(Iterable<Polyline> polylines) {
  if (polylines == null) {
    return <PolylineId, Polyline>{};
  }
  return Map<PolylineId, Polyline>.fromEntries(polylines.map(
          (Polyline polyline) => MapEntry<PolylineId, Polyline>(polyline.polylineId, polyline)));
}

List<dynamic> _serializePolylineSet(Set<Polyline> polylines) {
  if (polylines == null) {
    return null;
  }
  return polylines.map<dynamic>((Polyline m) => m.toMap()).toList();
}

class _PolylineUpdates {
  /// Computes [_PolylineUpdates] given previous and current [Polyline]s.
  _PolylineUpdates.from(Set<Polyline> previous, Set<Polyline> current) {
    if (previous == null) {
      previous = Set<Polyline>.identity();
    }

    if (current == null) {
      current = Set<Polyline>.identity();
    }

    final Map<PolylineId, Polyline> previousPolylines = _keyByPolylineId(previous);
    final Map<PolylineId, Polyline> currentPolylines = _keyByPolylineId(current);

    final Set<PolylineId> prevPolylineIds = previousPolylines.keys.toSet();
    final Set<PolylineId> currentPolylineIds = currentPolylines.keys.toSet();

    Polyline idToCurrentPolyline(PolylineId id) {
      return currentPolylines[id];
    }

    final Set<PolylineId> _polylineIdsToRemove = prevPolylineIds.difference(currentPolylineIds);

    final Set<Polyline> _polylinesToAdd = currentPolylineIds
        .difference(prevPolylineIds)
        .map(idToCurrentPolyline)
        .toSet();

    final Set<Polyline> _polylinesToChange = currentPolylineIds
        .intersection(prevPolylineIds)
        .map(idToCurrentPolyline)
        .toSet();

    polylinesToAdd = _polylinesToAdd;
    polylineIdsToRemove = _polylineIdsToRemove;
    polylinesToChange = _polylinesToChange;
  }

  Set<Polyline> polylinesToAdd;
  Set<PolylineId> polylineIdsToRemove;
  Set<Polyline> polylinesToChange;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('polylinesToAdd', _serializePolylineSet(polylinesToAdd));
    addIfNonNull('polylinesToChange', _serializePolylineSet(polylinesToChange));
    addIfNonNull('polylineIdsToRemove',
        polylineIdsToRemove.map<dynamic>((PolylineId m) => m.value).toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final _PolylineUpdates typedOther = other;
    return setEquals(polylinesToAdd, typedOther.polylinesToAdd) &&
        setEquals(polylineIdsToRemove, typedOther.polylineIdsToRemove) &&
        setEquals(polylinesToChange, typedOther.polylinesToChange);
  }

  @override
  int get hashCode =>
      hashValues(polylinesToAdd, polylineIdsToRemove, polylinesToChange);

  @override
  String toString() {
    return '_PolylineUpdates{polylinesToAdd: $polylinesToAdd, '
        'polylineIdsToRemove: $polylineIdsToRemove, '
        'polylinesToChange: $polylinesToChange}';
  }
}