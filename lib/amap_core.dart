library amap_core;

export 'src/web/amap.dart' if (dart.library.js) 'src/web/amap_web.dart';
export 'src/web/loader.dart' if (dart.library.js) 'src/web/loader_web.dart';

part 'src/poi_result/index.dart';
part 'src/poi_item/index.dart';
part 'src/lat_lng/index.dart';
part 'src/input_tip/index.dart';
part 'src/location/index.dart';
part 'src/re_geocode/index.dart';
part 'src/location_poi/index.dart';
