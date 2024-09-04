import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Centers.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Get_Centers.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Trining_Type.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Trining.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // الجزء الأول: عرض أفقي لقائمة مراكز
          SliverToBoxAdapter(
            child: Container(
              height: 130.0, // ارتفاع الجزء العلوي
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  CombinedPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
