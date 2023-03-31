import 'package:flutter/material.dart';
import 'package:how_to/pages/content_details.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final Function()? afterScreen;

  const ContentCard({
    super.key,
    required this.content,
    this.afterScreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          ContentDetails.routeName,
          arguments: ContentDetailsArgs(contentID: content.id),
        ).then((value) {
          if (afterScreen != null) afterScreen!();
        });
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: Image.network(
                    fit: BoxFit.cover,
                    "${Constants.domainHttp}${content.imageUrl}",
                    errorBuilder: (_, __, ___) {
                      return const Text("No Image");
                    },
                  ),
                ),
              ),
              Text(
                content.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                content.categoryStr.toUpperCase(),
              ),
              Text(
                "By ${content.userName}",
              ),
              Text(
                Utils.timeAgo(content.updatedAt),
              ),
              Row(
                children: [
                  const Icon(Icons.remove_red_eye_sharp),
                  const SizedBox(width: 5),
                  Text(
                    content.viewCount.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
