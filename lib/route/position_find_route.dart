import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_me_j_friend/persistence/entity/task.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';

class PositionFindRoute extends StatefulWidget {
  final List<Task> tasks;
  const PositionFindRoute({super.key, required this.tasks});

  @override
  State<StatefulWidget> createState() => _PositionFindState();
}

class _PositionFindState extends State<PositionFindRoute> {
  var positionRepository = PositionRepository();
  late GoogleMapController googleMapController;
  late List<LatLng> posList = [];

  void _onMapCreated(controller) {
    googleMapController = controller;
  }

  @override
  void initState() async {
    super.initState();
    for (Task t in widget.tasks) {
      var pos = await positionRepository.findById(t.positionId);
      posList.add(LatLng(pos.latitude, pos.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO 길찾기
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
                      target: posList[0], zoom: 11.0
                    //TODO 현재 위치로
                  ),
                  // TODO markers: ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}