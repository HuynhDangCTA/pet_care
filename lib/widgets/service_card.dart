import 'package:flutter/material.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final Function(ServiceModel)? onPick;
  const ServiceCard({super.key, required this.service, this.onPick});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPick!(service);
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: size.width * 0.3,
                  height: 160,
                  child: Image.network(
                    service.image!,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: '${service.name}', color: MyColors.primaryColor, isBold: true,),
                    AppText(text: '${service.decription ?? ''}', size: 14, color: MyColors.textColor,),
                    ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: service.options?.keys.length,
                        itemBuilder: (context, index) {
                          String? key = service.options?.keys.toList()[index];
                          int value = service.options?[key];
                          return Row(
                            children: [
                              AppText(text: '$key'),
                              const SizedBox(width: 10,),
                              AppText(text: '${NumberUtil.formatCurrency(value)}')
                            ],
                          );
                        },)
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
