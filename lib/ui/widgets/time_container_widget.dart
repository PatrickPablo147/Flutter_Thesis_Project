import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';

class TimeContainerWidget extends StatelessWidget {
  const TimeContainerWidget({Key? key,
    required this.titleText,
    required this.valueText,
    required this.onTap}) : super(key: key);

  final String titleText;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText, style: subTitleStyle),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: InkWell(
                onTap: onTap ,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(valueText, style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),),
                      ),
                      const Gap(12),
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.access_time_rounded, color: Colors.grey, size: 27,),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
