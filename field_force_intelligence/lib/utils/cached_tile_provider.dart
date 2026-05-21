import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedTileProvider extends TileProvider {
  CachedTileProvider();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return _CachedTileImageProvider(getTileUrl(coordinates, options));
  }
}

class _CachedTileImageProvider extends ImageProvider<_CachedTileImageProvider> {
  final String url;

  _CachedTileImageProvider(this.url);

  @override
  Future<_CachedTileImageProvider> obtainKey(ImageConfiguration configuration) {
    return Future.value(this);
  }

  @override
  ImageStreamCompleter loadImage(_CachedTileImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<_CachedTileImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(_CachedTileImageProvider key, dynamic decode) async {
    try {
      final fileInfo = await DefaultCacheManager().downloadFile(key.url);
      final bytes = await fileInfo.file.readAsBytes();
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return (decode as ImageDecoderCallback)(buffer);
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _CachedTileImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
