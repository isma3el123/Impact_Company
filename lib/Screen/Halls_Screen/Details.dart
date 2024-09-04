import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/WhatsApp_Scrren/Whatsapp.dart';
import 'package:flutter_application_16/Service/Service_Halls/Get_Halls_ByIdCenters.dart';

class DetailsPage extends StatefulWidget {
  final dynamic centerId;
  final String phoneNumber;

  const DetailsPage(
      {required this.centerId, required this.phoneNumber, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int selectindex = 0;
  late Future<List<HallsModel>> hallsFuture;
  bool _isImageVisible = false;
  bool _isContainerVisible = false;

  @override
  void initState() {
    super.initState();
    hallsFuture = ServiceGetHalls().fetchHalls(widget.centerId);

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        _isImageVisible = true;
        _isContainerVisible = true;
      });
    });
  }

  void _navigateToCentersPage() {
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => CombinedPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<HallsModel>>(
        future: hallsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load halls'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<HallsModel> halls = snapshot.data!;
            HallsModel selectedHall = halls[selectindex];

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  top:
                      _isImageVisible ? 0 : -MediaQuery.of(context).size.height,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _isImageVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: double.maxFinite,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(30)),
                        image: DecorationImage(
                          image: selectedHall.imgLink != null &&
                                  selectedHall.imgLink!.isNotEmpty
                              ? NetworkImage(selectedHall.imgLink!)
                              : AssetImage('images/5.png'), // صورة "غير متوفرة"
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  top: _isContainerVisible
                      ? 330
                      : MediaQuery.of(context).size.height,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _isContainerVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      height: 580,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(60),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedHall.hallName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Text(
                                    "سعة القاعة",
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    selectedHall.listDetails!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "عدد القاعات الموجودة في المركز",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      children:
                                          List.generate(halls.length, (index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectindex = index;
                                              selectedHall = halls[selectindex];
                                              _isImageVisible = false;
                                              _isContainerVisible = false;
                                            });

                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              setState(() {
                                                _isImageVisible = true;
                                                _isContainerVisible = true;
                                              });
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: selectindex == index
                                                  ? Color(0xff9d7b23)
                                                  : const Color.fromARGB(
                                                      255, 0, 0, 0),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectindex == index
                                                    ? Colors.white
                                                    : Colors.grey[600]!,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  color: selectindex == index
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WhatsAppScreen(
                                              phoneNumber: widget.phoneNumber),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff0c2d86),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 200,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "احجز القاعة",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _navigateToCentersPage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff0c2d86),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 200,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "رجوع  ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No halls available'));
          }
        },
      ),
    );
  }
}
