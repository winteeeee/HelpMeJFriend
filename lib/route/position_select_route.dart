import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widget/dialog.dart';

class PositionSelectRoute extends StatefulWidget {
  final LatLng pos;
  final Function setState;
  const PositionSelectRoute({super.key, required this.pos, required this.setState});

  @override
  State<StatefulWidget> createState() => _PositionSelectRoute();
}

class _PositionSelectRoute extends State<PositionSelectRoute> {
  late GoogleMapController googleMapController;

  void _onMapCreated(controller) {
    googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: widget.pos, zoom: 18
                  ),
                  myLocationEnabled: true,
                  onLongPress: (pos) => {
                    DialogFactory.showAlertDialog(context, "위치가 선택되었습니다!", 2),
                      widget.setState(pos),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}