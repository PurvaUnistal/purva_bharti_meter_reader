import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meter_reader_new/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/background_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/features/billingRequest/domain/bloc/billing_request_bloc.dart';
import 'package:meter_reader_new/features/billingRequest/domain/bloc/billing_request_event.dart';
import 'package:meter_reader_new/features/billingRequest/domain/bloc/billing_request_state.dart';
import 'package:meter_reader_new/features/billingRequest/presentation/billing_request_page.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  void initState() {
    BlocProvider.of<BillingRequestBloc>(context)
        .add(BillingRequestPageLoadingEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
        child: BlocBuilder<BillingRequestBloc, BillingRequestState>(
            builder: (context, state) {
            if (state is BillingRequestFetchDataState) {
              return _itemBuilder(dataState: state);
            } else {
              return Center(
                child: SpinLoader(),
        );
      }
    }));
  }

  _appBarWidget(){
    return AppBarWidget(
    title: "Route",
    );
  }

  _itemBuilder({required BillingRequestFetchDataState dataState}) {
    return Stack(
      children: <Widget>[
        _googleMapWidget(dataState: dataState),
        _previewPageWidget(dataState: dataState),
        _mapTypeWidget(dataState: dataState),
        _userAddControllerWidget(dataState: dataState),
      ],
    );
  }

  _googleMapWidget({required BillingRequestFetchDataState dataState}) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        dataState.mapController.complete(controller);
      },
      mapType: dataState.currentMapType,
      initialCameraPosition: CameraPosition(target: dataState.latLng, zoom: 16),
      markers: dataState.markers,
    );
  }

  _userAddControllerWidget({required BillingRequestFetchDataState dataState}) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.15,
      child: Card(
        color: AppColor.primer,
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text(dataState.userAddressController.text,
           textAlign: TextAlign.center,
           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
       ),
      ),
    );
  }

  _previewPageWidget({required BillingRequestFetchDataState dataState}) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => BillingRequestPage(),
              ),
                  (route) => false,
            );
          },
          backgroundColor: AppColor.white,
          child: Icon(Icons.arrow_back_ios_outlined, size: 30.0, color:  AppColor.primer),
        ),
      ),
    );
  }
  _mapTypeWidget({required BillingRequestFetchDataState dataState}) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            BlocProvider.of<BillingRequestBloc>(context).add(MapTypeButtonEvent());
          },
          backgroundColor: AppColor.white,
          child: Icon(Icons.map, size: 30.0, color:  AppColor.primer,),
        ),
      ),
    );
  }
}
