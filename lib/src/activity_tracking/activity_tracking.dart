import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ActivityTracking extends StatefulWidget {
  const ActivityTracking({super.key});

  static const routeName = '/activity-tracking';

  @override
  State<ActivityTracking> createState() => _ActivityTrackingState();
}

class _ActivityTrackingState extends State<ActivityTracking> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Location _locationController = Location();

  static const LatLng _posAlex = LatLng(52.521986, 13.414079);
  static const CameraPosition _kAlex =
      CameraPosition(target: _posAlex, zoom: 14);

  static const LatLng _posBunker = LatLng(52.528117, 13.436824);
  static const CameraPosition _kBunker =
      CameraPosition(target: _posBunker, zoom: 14);

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  LatLng? _currentPos = null;
  bool _isTracking = false;
  bool _isCameraLocked = true;
  List<LatLng> _trackedPositions = [];
  Map<PolylineId, Polyline> _polylinesById = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocationUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('first lvl pets')),
      body: Stack(children: [
        _currentPos == null
            ? Container(
                child: Text('Loading...'),
              )
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kAlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  Marker(
                      markerId: MarkerId('currentPos'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentPos!)
                },
                polylines: Set<Polyline>.of(_polylinesById.values),
              ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.purpleAccent)),
                      onPressed: () {
                        //TODO setState?
                        _trackedPositions = [];
                        _isTracking = true;
                      },
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow),
                          Text('Start'),
                        ],
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.purpleAccent)),
                      onPressed: () {
                        //_isTracking = false;
                        var totalDistance = 0.0;
                        for (var i = 0; i < _trackedPositions.length - 1; i++) {
                          totalDistance += calculateDistance(
                              _trackedPositions[i].latitude,
                              _trackedPositions[i].longitude,
                              _trackedPositions[i + 1].latitude,
                              _trackedPositions[i + 1].longitude);
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Distance in KM: ' +
                                  totalDistance.toString()),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.stop),
                          Text('Stop'),
                        ],
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.purpleAccent)),
                      onPressed: () {
                        _isCameraLocked = !_isCameraLocked;
                      },
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow),
                          Text('(Un)Lock Cam'),
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 75,
              )
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    final camPos = CameraPosition(target: pos, zoom: 18);
    await controller.animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  Future<void> _getLocationUpdates() async {
    var serviceEnabled = await _locationController.serviceEnabled();

    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    var permissionStatus = await _locationController.hasPermission();
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      permissionStatus = await _locationController.requestPermission();
    }
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      return;
    }

    _locationController.onLocationChanged.listen((locationData) {
      if (locationData.longitude != null && locationData.latitude != null) {
        setState(() {
          _currentPos = LatLng(locationData.latitude!, locationData.longitude!);
          if (_isTracking) {
            _trackedPositions.add(_currentPos!);
            _createPolyline(_trackedPositions);
          }
          if (_isCameraLocked) {
            _cameraToPosition(_currentPos!);
          }
          print(_currentPos.toString());
        });
      }
    });
  }

  void _createPolyline(List<LatLng> points) {
    const id = PolylineId('main route');
    final polyline = Polyline(
        polylineId: id,
        color: Colors.purpleAccent,
        points: points,
        width: 8,
        geodesic: true,
        jointType: JointType.round);
    _polylinesById[id] = polyline;
  }

  // this or package: https://stackoverflow.com/questions/60503089/how-to-calculate-distance-between-two-location-on-flutterresult-should-be-mete
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Future<List<LatLng>> _getPolylinePoints() async {
  //   final polylinePoints = PolylinePoints();
  //   final polylineResult = await polylinePoints.getRouteBetweenCoordinates(
  //       Constants.GOOGLE_MAPS_API_KEY,
  //       PointLatLng(_posBunker.latitude, _posBunker.longitude),
  //       PointLatLng(_posAlex.latitude, _posAlex.longitude),
  //       travelMode: TravelMode.walking);
  // }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
