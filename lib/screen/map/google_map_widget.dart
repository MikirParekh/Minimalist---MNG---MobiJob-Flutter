import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final String latLngString;
  final String title;

  const MapSample({super.key, required this.latLngString,required this.title});
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};


  late LatLng _markerPosition;

  @override
  void initState() {
    super.initState();
    debugPrint("Map called");
    _markerPosition = _parseLatLng(widget.latLngString);
    _addMarker();
  }

  LatLng _parseLatLng(String latLng) {
    final parts = latLng.split(',');
    final lat = double.parse(parts[0].trim());
    final lng = double.parse(parts[1].trim());
    return LatLng(lat, lng);
  }


  void _addMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('marker_1'),
        position: _markerPosition,
        infoWindow: InfoWindow(
          title: widget.title ?? "marker",
        ),
      ),
    );
    //setState(() {}); // Trigger a rebuild to display the marker
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SizedBox(
        height: 300,
        width: 300,
        child: GoogleMap(
          onMapCreated: (controller) {
            _controller = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _markerPosition,
            zoom: 11.0,
          ),
          markers: _markers,
        ),
      ),
    );
  }
}
