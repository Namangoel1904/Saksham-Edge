import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../data/retailer_repository.dart';
import '../models/retailer.dart';
import '../utils/cached_tile_provider.dart';
import 'retailer_detail_screen.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({Key? key}) : super(key: key);

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final LatLng _mockCurrentLocation = const LatLng(18.5204, 73.8567); // Pune Mock Location
  List<Retailer> _retailers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRetailers();
  }

  Future<void> _loadRetailers() async {
    final repo = context.read<RetailerRepository>();
    final retailers = await repo.getAssignedRetailers();
    setState(() {
      _retailers = retailers;
      _isLoading = false;
    });
  }

  Color _getMarkerColor(int priorityScore) {
    if (priorityScore >= 85) return Colors.red;
    if (priorityScore >= 70) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Retailer? highestPriorityRetailer;
    if (_retailers.isNotEmpty) {
      highestPriorityRetailer = _retailers.reduce(
        (curr, next) => curr.priorityScore > next.priorityScore ? curr : next,
      );
    }

    final polylinePoints = <LatLng>[_mockCurrentLocation];
    if (highestPriorityRetailer != null) {
      polylinePoints.add(LatLng(highestPriorityRetailer.lat, highestPriorityRetailer.lng));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saksham Edge - Dynamic Route'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _mockCurrentLocation,
          initialZoom: 7.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.syngenta.sakshamedge',
            tileProvider: CachedTileProvider(),
          ),
          PolylineLayer(
            polylines: [
              if (highestPriorityRetailer != null)
                Polyline(
                  points: polylinePoints,
                  color: Colors.blueAccent,
                  strokeWidth: 4.0,
                  pattern: const StrokePattern.dashed(segments: [10, 10]),
                ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _mockCurrentLocation,
                width: 40,
                height: 40,
                child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
              ),
              ..._retailers.map((retailer) {
                return Marker(
                  point: LatLng(retailer.lat, retailer.lng),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RetailerDetailScreen(retailer: retailer),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: _getMarkerColor(retailer.priorityScore),
                      size: 40,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
