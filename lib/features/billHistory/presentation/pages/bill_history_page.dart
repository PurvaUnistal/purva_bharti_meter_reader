import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meter_reader_new/Utils/common_widgets/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/background_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';
import 'package:meter_reader_new/features/billHistory/domain/bloc/bill_history_bloc.dart';
import 'package:meter_reader_new/features/billHistory/presentation/widget/CustomTextEmailField.dart';
import 'package:meter_reader_new/features/billHistory/presentation/widget/bill_history_box_widget.dart';

class BillHistoryPage extends StatefulWidget {
  const BillHistoryPage({Key? key}) : super(key: key);

  @override
  State<BillHistoryPage> createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {

   @override
  void initState() {
     BlocProvider.of<BillHistoryBloc>(context).add(
         BillHistoryPageLoadEvent(context: context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "Bill History",
          boolLeading: true,),
      body: BackgroundWidget(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomTextEmailField(
                onChanged: (value) {
                  context.read<BillHistoryBloc>().add(
                      BillHistorySearchKeywordEvent(searchKeyword: value));
                },
                enabled: true,
                keyboardType: TextInputType.number,
                validate: false,
                hintText: "BP Number/Meter Number",
                filledColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<BillHistoryBloc, BillHistoryState>(
                builder: (context, state) {
                  if (state is BillHistoryPageLoadState) {
                    return Center(
                      child: SpinKitCubeGrid(color: EnvironmentConfig.of(context)?.primaryTheme, size: 50),
                    );
                  } else if (state is BillHistoryEmptyState) {
                    return const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  } else if (state is FetchBillHistoryDataState) {
                    return _listBuilder(dataState: state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listBuilder({required FetchBillHistoryDataState dataState}){
    String schema = AppConfig.instanceInit()!.loginData.user!.schema.toString();
    String userId = AppConfig.instanceInit()!.loginData.user!.id.toString();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataState.billHistoryList.length,
        itemBuilder: (context, index) {
        return BillHistoryBoxWidget(
            billHistoryData: dataState.billHistoryList[index],
             userId: userId.toString(),
            schema: schema.toString()
        );
    });
  }
}
