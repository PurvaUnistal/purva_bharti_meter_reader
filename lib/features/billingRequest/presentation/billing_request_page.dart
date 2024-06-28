import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader/Utils/common_widgets/Loader/CircleLoader.dart';
import 'package:meter_reader/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:meter_reader/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:meter_reader/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader/Utils/common_widgets/app_bar_widget.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';
import 'package:meter_reader/Utils/common_widgets/app_string.dart';
import 'package:meter_reader/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader/Utils/common_widgets/image_pop_widget.dart';
import 'package:meter_reader/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:meter_reader/Utils/common_widgets/styles_widget.dart';
import 'package:meter_reader/Utils/common_widgets/text_form_widget.dart';
import 'package:meter_reader/features/billHistory/presentation/pages/bill_history_page.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_bloc.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_event.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_state.dart';
import 'package:meter_reader/Utils/common_widgets/image_widget.dart';
import 'package:meter_reader/Utils/common_widgets/logout_widget.dart';
import 'package:meter_reader/features/billingRequest/presentation/widgets/meter_number_widget.dart';

class BillingRequestPage extends StatefulWidget {
  const BillingRequestPage({super.key});

  @override
  State<BillingRequestPage> createState() => _BillingRequestPageState();
}

class _BillingRequestPageState extends State<BillingRequestPage> {

  @override
  void initState() {
    BlocProvider.of<BillingRequestBloc>(context).add(BillingRequestPageLoadingEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBarWidget(
            title: RoutesName.meterReader,
            boolLeading: false,
            actions: [
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'History'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: BlocBuilder<BillingRequestBloc, BillingRequestState>(builder: (context, state) {
            if (state is BillingRequestFetchDataState) {
              return _itemBuilder(dataState: state);
            } else {
              return const Center(
                child: SpinLoader(),
              );
            }
          })),
    );
  }

  Widget _itemBuilder({required BillingRequestFetchDataState dataState}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${AppString.release}: ${AppString.reDate}",style: Styles.rel,),
            Text("${AppString.scheme}: ${dataState.scheme}, ${AppString.userName}: ${dataState.userName}",style: Styles.rel,),
          ],
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              child: Column(
                children: [
                  _searchTextField(dataState: dataState),
                  _verticalSpace(),
                  Row(
                    children: [
                      Flexible(
                          flex: 10,
                          child: _nameController(dataState: dataState)),
                      Flexible(
                        flex: 2,
                          child: _hideShowBtn(dataState: dataState)),
                    ],
                  ),
                  _verticalSpace(),
                  _visibleAddDetails(dataState: dataState),
                  _meterNumberController(dataState: dataState),
                  _verticalSpace(),
                  _bpNumberController(dataState: dataState),
                  _verticalSpace(),
                  _mobileNumberController(dataState: dataState),
                  _verticalSpace(),
                  _preReadingController(dataState: dataState),
                  _verticalSpace(),
                  _meterText(),
                  _meterNumber(dataState: dataState),
                  _verticalSpace(),
                  _meterImage(dataState: dataState),
                  _verticalSpace(),
                  _button(dataState: dataState),
                  _verticalSpace(),
                  _verticalSpace(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchTextField({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      maxLength: 20,
      enabled: true,
      autofocus: true,
      label: AppString.bpNumberSync,
      hintText: AppString.bpNumberSync,
      controller: dataState.bpNumberController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      suffixIcon: IconButton(
        icon: dataState.isSyncLoader == false
            ? Icon(Icons.search_rounded, color: AppColor.primer)
            : CircleLoaderWidget(),
        onPressed: () {
          BlocProvider.of<BillingRequestBloc>(context).add(SyncSearchBPNumberEvent(
            context: context,
          ));
        },
      ),

    );
  }

  Widget _nameController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.name,
      label: AppString.name,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.custNameController,
    );
  }
  Widget _hideShowBtn({required BillingRequestFetchDataState dataState}){
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
       style: ButtonStyle(
           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
               RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20.0),
                   side: BorderSide(color: AppColor.primer)
               )
           )
       ),
        icon: Icon(
          dataState.isHideShowDetails ? Icons.arrow_drop_down_outlined : Icons.arrow_drop_up_outlined,
          color: Colors.green.shade800,
        ),
        onPressed: () {
          BlocProvider.of<BillingRequestBloc>(context).add(BillingHideShowEvent(
              isHideShow: dataState.isHideShowDetails == true ? false : true));
        },
      ),
    );
  }
  Widget _visibleAddDetails({required BillingRequestFetchDataState dataState}){
    return Visibility(
      visible: dataState.isHideShowDetails,
        child: Column(
      children: [
        _buildNameController(dataState: dataState),
        _verticalSpace(),
        _streetNameController(dataState: dataState),
        _verticalSpace(),
        _townController(dataState: dataState),
        _verticalSpace(),
        _districtController(dataState: dataState),
        _verticalSpace(),
        _pinCodeController(dataState: dataState),
        _verticalSpace(),
      ],
    )
    );
  }
  Widget _buildNameController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.buildName,
      label: AppString.buildName,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.buildingNoController,
    );
  }

  Widget _colonyNameController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.colonyName,
      label: AppString.colonyName,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.colonyController,
    );
  }

  Widget _streetNameController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.streetName,
      label: AppString.streetName,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.streetNameController,
    );
  }
  Widget _townController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.town,
      label: AppString.town,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.townController,
    );
  }
  Widget _districtController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.district,
      label: AppString.district,
      enabled: false,
      inputType: TextInputType.text,
      controller: dataState.districtController,
    );
  }
  Widget _pinCodeController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.pinCode,
      label: AppString.pinCode,
      enabled: false,
      inputType: TextInputType.number,
      controller: dataState.pinCodeController,
    );
  }

  Widget _meterNumberController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.meterNumber,
      label: AppString.meterNumber,
      enabled: false,
      inputType: TextInputType.number,
      controller: dataState.meterNumberController,
    );
  }


  Widget _bpNumberController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.bpNumber,
      label: AppString.bpNumber,
      enabled: false,
      inputType: TextInputType.number,
      controller: dataState.bpNumberController,
    );
  }
  Widget _mobileNumberController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: AppString.mobileNumber,
      label: AppString.mobileNumber,
      enabled: false,
      inputType: TextInputType.number,
      controller: dataState.mobileNumberController,
    );
  }
  Widget _preReadingController({required BillingRequestFetchDataState dataState}) {
    return TextFieldWidget(
      hintText: dataState.listOfBPNumber.isEmpty
          ? AppString.preReading1
          : dataState.listOfBPNumber[0].replaceStatus == 1
          ? AppString.preReading2
          : AppString.preReading1,
      label: dataState.listOfBPNumber.isEmpty
          ? AppString.preReading1
          : dataState.listOfBPNumber[0].replaceStatus == 1
          ? AppString.preReading2
          : AppString.preReading1,
      enabled: false,
      inputType: TextInputType.number,
      controller: dataState.previousReadingController,
    );
  }

  Widget _meterText(){
    return Container(
      alignment: Alignment.centerLeft,
      child: Text("Meter Reading : ", style: Styles.labels
      ),
    );
  }

  Widget _meterNumber({required BillingRequestFetchDataState dataState}){
    return  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          MeterNumber(
            controller: dataState.meterRead1Controller,
            focusNode: dataState.meterRead1Node,
            autoFocus: dataState.meterReadCon1,
            enabled: dataState.meterReadCon1,
            textInputAction:TextInputAction.done,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange1Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead2Controller,
            focusNode: dataState.meterRead2Node,
            autoFocus: dataState.meterReadCon2,
            enabled: dataState.meterReadCon2,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange2Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead3Controller,
            focusNode: dataState.meterRead3Node,
            autoFocus: dataState.meterReadCon3,
            enabled: dataState.meterReadCon3,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange3Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead4Controller,
            focusNode: dataState.meterRead4Node,
            autoFocus: dataState.meterReadCon4,
            enabled: dataState.meterReadCon4,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange4Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead5Controller,
            focusNode: dataState.meterRead5Node,
            autoFocus: dataState.meterReadCon5,
            enabled: dataState.meterReadCon5,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange5Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead6Controller,
            focusNode: dataState.meterRead6Node,
            autoFocus: dataState.meterReadCon6,
            enabled: dataState.meterReadCon6,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange6Event(
                context: context,
              ));
            },),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead7Controller,
            focusNode: dataState.meterRead7Node,
            autoFocus: dataState.meterReadCon7,
            enabled: dataState.meterReadCon7,
            textInputAction:TextInputAction.previous,
            color: Colors.grey,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange7Event(
                context: context,
              ));
            },
          ),
          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead8Controller,
            focusNode: dataState.meterRead8Node,
            autoFocus: dataState.meterReadCon8,
            enabled: dataState.meterReadCon8,
            textInputAction:TextInputAction.previous,
            color: Colors.red,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange8Event(
                context: context,
              ));
            },
          ),

          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead9Controller,
            focusNode: dataState.meterRead9Node,
            autoFocus: dataState.meterReadCon9,
            enabled: dataState.meterReadCon9,
            textInputAction:TextInputAction.previous,
            color: Colors.red,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange9Event(
                context: context,
              ));
            },
          ),

          SizedBox(
            width: 2.0,
          ),
          MeterNumber(
            controller: dataState.meterRead10Controller,
            focusNode: dataState.meterRead10Node,
            enabled: true,
            autoFocus: true,
            textInputAction:TextInputAction.previous,
            color: Colors.red,
            onChanged: (val) {
              BlocProvider.of<BillingRequestBloc>(context).add(OnChange10Event(
                context: context,
              ));
            },
          ),

        ],
      ),
    );
  }


  Widget _meterImage({required BillingRequestFetchDataState dataState}){
    return ImageWidget(
      star: AppString.star,
      title: AppString.photo,
      imgFile: dataState.meterFile,
      onPressed: (){
        showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return ImagePopWidget(
                onTapCamera: () async {
                  Navigator.of(context).pop();
                  BlocProvider.of<BillingRequestBloc>(context).add(
                      SelectMeterCameraEvent(context: context));
                },
                onTapGallery: () async {
                  Navigator.of(context).pop();
                  BlocProvider.of<BillingRequestBloc>(context).add(
                      SelectMeterGalleryEvent(context: context));
                },
              );
            });
      },
    );
  }


  Widget _button({required BillingRequestFetchDataState dataState}) {
    return dataState.isBtnLoader == false
        ? ButtonWidget(
        text: AppString.preview,
        onPressed: () {
          BlocProvider.of<BillingRequestBloc>(context)
              .add(BillingRequestPreviewEvent(context: context));
        })
        : DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "Do you want to exit the App?",
            okButtonText: "Exit",
            onPressed: () =>  Navigator.of(context).pop(true)
        ))
    ) ?? false;
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        showModalBottomSheet(
            context: context,
            builder: (context) => const LogoutWidget());
        break;
      case 'History':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BillHistoryPage()));
        break;
    }
  }
}
