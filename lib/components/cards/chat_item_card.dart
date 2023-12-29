import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini_bot/models/chat_model.dart';
import 'package:flutter_gemini_bot/utils/constants.dart';
import 'package:flutter_gemini_bot/utils/helper_widgets.dart';

class ChatItemCard extends StatefulWidget {
  final ChatModel chatItem;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;


  const ChatItemCard({super.key,
    this.onTap,
    this.onLongPress,
    required this.chatItem,
  });

  @override
  State<ChatItemCard> createState() => _ChatItemCardState();
}

class _ChatItemCardState extends State<ChatItemCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: widget.chatItem.chat == 0
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.chatItem.chat == 1)
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.reddit_rounded,
                  color: primaryColor,
                ),
                iconSize: 25,
              ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 0, right: 10, top: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.chatItem.chatType == ChatType.error
                      ? Colors.red.withOpacity(0.5)
                      : widget.chatItem.chat == 0
                          ? secondaryColor.withOpacity(0.5)
                          : primaryColor.withOpacity(0.1),
                  borderRadius: widget.chatItem.chatType == ChatType.error
                      ? const BorderRadius.all(Radius.circular(30))
                      : widget.chatItem.chat == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(10),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(10),
                            ),
                ),
                child: Column(
                  crossAxisAlignment: widget.chatItem.chatType == ChatType.error
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.chatItem.chatType == ChatType.loading)
                      SizedBox(height: 50, width: 50, child: loadingWidget()),
                    if (widget.chatItem.chatType != ChatType.loading)
                      RichText(
                          text: formatText(
                        '${widget.chatItem.message}',
                      )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  TextSpan formatText(String text) {
    RegExp regex = RegExp(r'\*\*(.*?)\*\*');
    List<TextSpan> spans = [];

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // Autres propriétés de style si nécessaire
          ),
        ));
        return '';
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(text: text));
        return '';
      },
    );
    return TextSpan(children: spans);
  }
}

// Identifies the children of a _ListTileElement.
enum _ListTileSlot {
  nom,
  description,
  rating,
  cookTime,
  thumbnailUrl,
}

Iterable<_ListTileSlot> get slots => _ListTileSlot.values;

@override
bool hitTestSelf(Offset position) => true;
