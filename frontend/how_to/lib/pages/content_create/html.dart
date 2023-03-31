import 'dart:convert';
import 'dart:developer';

import 'package:how_to/pages/content_create/models.dart';
import 'package:how_to/providers/constants.dart';

abstract class HTMLBuilder {
  static String build({
    required String title,
    required String category,
    required BodyContent mainImg,
    required List<BodyContent> bdCtnList,
  }) {
    String confirmHTML = '''
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

    // log(confirmHTML);

    return confirmHTML;
  }

  static String buildFinal({
    required String title,
    required String category,
    required List<BodyContent> bdCtnList,
  }) {
    String confirmHTML = "";

    bdCtnList.asMap().forEach((i, bc) {
      if (bc.mode == BodyContentMode.text) {
        confirmHTML += '''
          <p>${bc.text}</p>
        ''';
      }
      if (bc.mode == BodyContentMode.image) {
        confirmHTML += '''
          <div>
            <img style="object-fit:cover" height=100 src="${Constants.domainHttp}${bc.imagePath}"></img>
          </div>
        ''';
      }
    });

    // log(confirmHTML);

    return confirmHTML;
  }
}
