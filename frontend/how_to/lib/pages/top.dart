import 'package:flutter/material.dart';
import 'package:how_to/providers/content_provider.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:how_to/providers/utils.dart';
import 'package:provider/provider.dart';

class TopPage extends StatefulWidget {
  static const routeName = "/top";
  static const routeIndex = 0;

  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  LoginData _loginData = LoginData();
  List<Content> _contentList = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      if (!mounted) return;
      final contentList =
          await Provider.of<ContentProvider>(context, listen: false)
              .fetchContent();
      _contentList = contentList;
      _loginData = loginData;
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _contentList.length,
            itemBuilder: (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              // -------------------------------- Content Card
              child: Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: const Center(
                          child: Text(
                            "No Image",
                          ),
                        ),
                      ),
                      Text(
                        _contentList[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _contentList[index].category.toUpperCase(),
                      ),
                      Text(
                        "By ${_contentList[index].userName}",
                      ),
                      Text(
                        Utils.timeAgo(_contentList[index].updatedAt),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_sharp),
                          const SizedBox(width: 5),
                          Text(
                            _contentList[index].viewCount.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
