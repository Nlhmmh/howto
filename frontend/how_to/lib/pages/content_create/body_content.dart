import 'package:flutter/material.dart';
import 'package:how_to/pages/widgets.dart';

class BdCtnWidget extends StatelessWidget {
  final Widget body;
  final Function() onDelTap;

  const BdCtnWidget({
    Key? key,
    required this.body,
    required this.onDelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: body),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(),
          ),
          child: iconTextButton(
            text: "Remove Widget",
            icon: Icons.delete,
            iconSize: 25,
            textSize: 12,
            onTap: onDelTap,
          ),
        ),
      ],
    );
  }
}
