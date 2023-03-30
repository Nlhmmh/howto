import 'dart:convert';
import 'dart:developer';

import 'package:how_to/pages/content_create/models.dart';

class HTMLBuilder {
  static String build({
    required String title,
    required String category,
    required BodyContent mainImg,
    required List<BodyContent> bdCtnList,
  }) {
    String confirmHTML = "";

    confirmHTML += '''
          <h1>$title</h1>
        ''';

    final imgBytes = mainImg.image!.readAsBytesSync();
    confirmHTML += '''
            <div>
              <img style="object-fit:cover" src="data:image/png;base64,${base64Encode(imgBytes)}"></img>
            </div>
          ''';

    bdCtnList.asMap().forEach((i, bc) {
      if (bc.mode == BodyContentMode.text) {
        // final tmpText = bc.text.replaceAll("\n", "<br/>");
        confirmHTML += "<p>${bc.text}</p>";
      }

      if (bc.mode == BodyContentMode.image && bc.image != null) {
        final imgBytes = bc.image!.readAsBytesSync();
        confirmHTML += '''
            <div>
              <img style="object-fit:cover" src="data:image/png;base64,${base64Encode(imgBytes)}"></img>
            </div>
          ''';
      }
    });

    log(confirmHTML);

    return confirmHTML;
  }
}
