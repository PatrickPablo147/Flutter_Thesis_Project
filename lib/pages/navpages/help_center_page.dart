import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/pages/navpages/schedule_page.dart';

import '../../ui/theme/theme.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())),
            child: const Icon(LineAwesomeIcons.angle_left)
        ),
        title: Center(child: Text('Help', style: textStyle.copyWith(fontSize: 18),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Something goes",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 2
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'WRONG',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        height: 0.9,
                                        letterSpacing: -2
                                    )
                                ),
                              ),
                              Text('?',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                  )
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 100, width: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(image: AssetImage("assets/images/report.png"), fit: BoxFit.contain,)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(thickness: 0.5, color: Colors.black,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Feedback', style: subTitleStyle),
                    const Gap(3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Let us know the problem.',
                            hintStyle: textStyle.copyWith(color: Colors.grey)
                        ),
                        maxLines: 10,
                        controller: messageController,
                      ),
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: 'Submitted',
                          gravity: ToastGravity.TOP,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black54
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      },
                      child: Container(
                        height: 50,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        child: Center(child: Text('SUBMIT', style: textStyle.copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
