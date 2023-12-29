library flutter_gemini_bot;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini_bot/components/cards/chat_item_card.dart';
import 'package:flutter_gemini_bot/models/chat_model.dart';
import 'package:flutter_gemini_bot/services/gemini_ai_api.dart';
import 'package:flutter_gemini_bot/utils/constants.dart';
import 'package:flutter_gemini_bot/utils/helper_widgets.dart';

class FlutterGeminiChat extends StatefulWidget {
  FlutterGeminiChat(
      {super.key,
      required this.chatContext,
      required this.chatList,
      required this.apiKey});

  @override
  _FlutterGeminiChatState createState() =>
      _FlutterGeminiChatState(chatContext: chatContext);
  final String chatContext;
  final List<ChatModel> chatList;
  final String apiKey;
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class _FlutterGeminiChatState extends State<FlutterGeminiChat> {
  List<Map<String, String>> messages = [];

  final String chatContext;
  TextEditingController questionController = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  _FlutterGeminiChatState({required this.chatContext});
  @override
  void initState() {
    super.initState();
    setState(() {
      messages.add({"text": chatContext});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.chatList.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Icon(Icons.chat),
                  ),
                  Text("Hover text")
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.chatList.length,
                itemBuilder: (context, index) => ChatItemCard(
                  chatItem: widget.chatList[index],
                  onTap: () {
                    // show options to copy or delete
                    customDialog(
                        context: context,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                // copy to clipboard
                                Clipboard.setData(ClipboardData(
                                    text: widget.chatList[index].message));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: primaryColor,
                                    duration: Duration(milliseconds: 400),
                                    content: Text('Copied to Clipboard'),
                                  ),
                                );
                              },
                              leading: const Icon(Icons.copy),
                              title: const Text("Copy"),
                            ),
                            ListTile(
                              onTap: () {
                                // delete
                                setState(() {
                                  widget.chatList.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete"),
                            ),
                            // add to textfield
                            ListTile(
                              onTap: () {
                                setState(() {
                                  questionController.text =
                                      widget.chatList[index].message;
                                  questionController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                              questionController.text.length));
                                });
                                Navigator.pop(context);
                              },
                              leading: const Icon(Icons.add),
                              title: const Text("Edit"),
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ),
      bottomSheet: texFieldBottomWidget(),
    );
  }

  Widget texFieldBottomWidget() {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(
          left: appPadding, right: appPadding, top: appPadding + 8),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Posez votre question...',
          suffixIcon: questionController.text.isEmpty
              ? InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: secondaryColor),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    var question = questionController.text;
                    setState(() {
                      widget.chatList.add(ChatModel(
                          chat: 0,
                          message: questionController.text,
                          time:
                              "${DateTime.now().hour}:${DateTime.now().second}"));

                      setState(() {
                        widget.chatList.add(ChatModel(
                            chatType: ChatType.loading,
                            chat: 1,
                            message: "",
                            time: ""));
                      });

                      // remove focus from textfield
                      FocusScope.of(context).unfocus();
                      try {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      } catch (e) {
                        print(
                            "**************************************************************");
                        print(e);
                      }
                      messages.add({
                        "text": chatContext + "\n" + question,
                      });
                      questionController.text = "";
                    });
                    var (responseString, response) =
                        await GeminiApi.geminiChatApi(
                            messages: messages, apiKey: widget.apiKey);
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent +
                              MediaQuery.of(context).size.height,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                      if (response.statusCode == 200) {
                        widget.chatList.removeLast();
                        widget.chatList.add(ChatModel(
                            chat: 1,
                            message: responseString,
                            time:
                                "${DateTime.now().hour}:${DateTime.now().second}"));
                      } else {
                        widget.chatList.removeLast();
                        widget.chatList.add(ChatModel(
                            chat: 0,
                            chatType: ChatType.error,
                            message:
                                "une erreur est survenue veuillez réessayer",
                            time:
                                "${DateTime.now().hour}:${DateTime.now().second}"));
                      }
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: secondaryColor),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        controller: questionController,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
