import 'package:flutter/material.dart';
import 'package:how_to/pages/content_create/models.dart';

class TextAdder extends StatefulWidget {
  final BodyContent bdCtn;

  const TextAdder({
    super.key,
    required this.bdCtn,
  });

  @override
  State<TextAdder> createState() => _TextAdderState();
}

class _TextAdderState extends State<TextAdder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 135,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Text'),
                const SizedBox(width: 5),
                Text("[ Order : ${widget.bdCtn.orderNo.toString()} ]"),
                const SizedBox(width: 5),
                Text("Characters ${widget.bdCtn.text.length.toString()}"),
              ],
            ),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 3,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Write down some text',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                widget.bdCtn.text = v;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
