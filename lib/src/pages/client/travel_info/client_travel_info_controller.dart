
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:give_structure/src/api/environment.dart';
import 'package:give_structure/src/models/directions.dart';
import 'package:give_structure/src/providers/google_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientTravelInfoController {
    BuildContext context;

    GoogleProvider _googleProvider;

    Function refresh;
    GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
    Completer<GoogleMapController> _mapController = Completer();

    CameraPosition initialPosition = CameraPosition(
        target: LatLng(-25.45115884604181, -57.43336174636765), zoom: 14.0);

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

    String from;
    String to;
    LatLng fromLatLng;
    LatLng toLatLng;

    Set<Polyline> polylines = {};
    List<LatLng> points = [];

    BitmapDescriptor fromMarker;
    BitmapDescriptor toMarker;

    Direction _directions;

    String min;
    String km;

    Future init(BuildContext context, Function refresh) async {
      this.context = context;
      this.refresh = refresh;
      Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      from = arguments['from'];
      to = arguments['to'];
      fromLatLng = arguments['fromLatLng'];
      toLatLng = arguments['toLatLng'];

      
      animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);

      _googleProvider = new GoogleProvider();

      fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
      toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');
      getGoogleMapsDirections(fromLatLng, toLatLng);
    }

    void getGoogleMapsDirections(LatLng from, LatLng to) async {
      _directions = await _googleProvider.getGoogleMapsDirections(
          from.latitude,
          from.longitude,
          to.latitude,
          to.longitude
      );

      min = _directions.duration.text;
      km = _directions.distance.text;
      refresh();
    }

    Future<void> setPolylines() async {
      PointLatLng pointFromLatLng = PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
      PointLatLng pointToLatLng = PointLatLng(toLatLng.latitude, toLatLng.longitude);
      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
          Environment.API_KEY_MAPS,
          pointFromLatLng,
          pointToLatLng
      );
      for (PointLatLng point in result.points){
        points.add(LatLng(point.latitude, point.longitude));
      }
      Polyline polyline = Polyline(
        polylineId: PolylineId('poli'),
        color: Colors.amber,
        points: points,
        width: 6
      );
      polylines.add(polyline);
      addMarker('from', fromLatLng.latitude, fromLatLng.longitude, 'Recoger aquí', '', fromMarker);
      addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);
      refresh();
    }

    void onMapCreated(GoogleMapController controller) async {
      controller.setMapStyle(
          '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
      _mapController.complete(controller);
      await setPolylines();
    }

    Future animateCameraToPosition(double latitude, double longitude) async {
      GoogleMapController controller = await _mapController.future;
      if (controller != null) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0,
          zoom: 15,
          target: LatLng(latitude, longitude),
        )));
      }
    }

    Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor bitmapDescriptor =
      await BitmapDescriptor.fromAssetImage(configuration, path);
      return bitmapDescriptor;
    }

    void addMarker(String markerId, double lat, double lng, String title,
        String content, BitmapDescriptor iconMarker) {
      MarkerId id = MarkerId(markerId);
      Marker marker = Marker(
          markerId: id,
          icon: iconMarker,
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: title, snippet: content),
      );
      markers[id] = marker;
    }
}