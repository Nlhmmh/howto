import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:how_to/providers/api/content_ctrls.dart';
import 'package:how_to/providers/api/user_ctrls.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class ContentDetailsArgs {
  String contentID = "";
  ContentDetailsArgs({required this.contentID});
}

class ContentDetails extends StatefulWidget {
  static const routeName = "/content/details";

  const ContentDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  String _contentID = "";
  Content _content = Content();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)!.settings.arguments as ContentDetailsArgs;
      _contentID = args.contentID;

      await _getContent();
    });
  }

  Future<void> _getContent() async {
    final content = await ContentCtrls.get((errResp) {
      if (!mounted) return;
      Utils.checkErrorResp(context, errResp);
    }, contentID: _contentID);
    _content = content;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_content.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------- Image
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.7,
                child: Center(
                  child: Image.network(
                    fit: BoxFit.cover,
                    "${Constants.domainHttp}${_content.imageUrl}",
                    errorBuilder: (_, __, ___) {
                      return const Text("No Image");
                    },
                  ),
                ),
              ),

              // --------------- Category
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _content.categoryStr.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // --------------- User
                      Text("By ${_content.userName}"),
                      // --------------- UpdatedAt
                      Text(Utils.timeAgo(_content.updatedAt)),
                      // --------------- ViewCount
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_sharp),
                          const SizedBox(width: 5),
                          Text(_content.viewCount.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final errResp = await UserCtrls.favCreate({
                        "contentID": _content.id,
                      });
                      if (errResp.code != 0) {
                        if (!mounted) return;
                        Utils.checkErrorResp(context, errResp);
                        return;
                      }
                      await _getContent();
                    },
                    icon: Icon(
                      _content.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 30,
                      color: _content.isFavourite ? Colors.red : Colors.black,
                    ),
                  )
                ],
              ),

              // --------------- HTML BODY
              if (_content.contentHTML.isNotEmpty)
                Html(
                  data: _content.contentHTML[0].html,
                  style: {
                    "p": Style(whiteSpace: WhiteSpace.PRE),
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
