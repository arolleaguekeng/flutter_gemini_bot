library flutter_gemini_bot;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini_bot/components/cards/chat_item_card.dart';
import 'package:flutter_gemini_bot/models/chat_model.dart';
import 'package:flutter_gemini_bot/services/gemini_ai_api.dart';
import 'package:flutter_gemini_bot/utils/constants.dart';
import 'package:flutter_gemini_bot/utils/helper_widgets.dart';

class FlutterGeminiChat extends StatefulWidget {
  const FlutterGeminiChat({super.key, required this.chatContext});
  
  @override
  _FlutterGeminiChatState createState() =>
      _FlutterGeminiChatState(chatContext: chatContext);
  final String chatContext;
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class _FlutterGeminiChatState extends State<FlutterGeminiChat> {
  List<Map<String, String>> messages = [];

  final String chatContext;
  TextEditingController questionController = TextEditingController();

  List<ChatModel> chatList = [];
  ScrollController _scrollController = new ScrollController();

  var initialPromet = "";

  _FlutterGeminiChatState({required this.chatContext});
  @override
  void initState() {
    setState(() {
      initialPromet =
      "Tu es un assistant virtuel spécialisé dans l'apprentissage du code de la route et de la conduite. Pour une expérience optimale, réponds uniquement aux questions liées à l'auto-école et au chapitre actuel de la formation. Si la question ne concerne pas l'auto-école ou s'écarte du sujet en cours, fais de ton mieux pour comprendre le contexte et propose une réponse pertinente. En cas de doute, demande des clarifications pour garantir une assistance précise. Sois attentif aux termes associés à l'auto-école, tels que les panneaux de signalisation, les règles de conduite, etc. Si la question est ambiguë, n'hésite pas à demander des précisions pour offrir la meilleure aide possible : '(${chatContext})', excuse-toi gentiment en expliquant que tu ne peux pas répondre à ce type de question. Invite l'utilisateur à poser des questions en rapport avec l'auto-école";
      messages.add({"text": initialPromet});
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: chatList.isEmpty
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
          itemCount: chatList.length,
          itemBuilder: (context, index) => ChatItemCard(
            isListening: chatList[index].chat == 1 &&
                chatList[index].chatType != ChatType.loading
                ? true
                : false,
            chatItem: chatList[index],
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
                              text: chatList[index].message));
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
                            chatList.removeAt(index);
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
                                chatList[index].message;
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
            onTap: () {
            },
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
                chatList.add(ChatModel(
                    chat: 0,
                    message: questionController.text,
                    time:
                    "${DateTime.now().hour}:${DateTime.now().second}"));

                setState(() {
                  chatList.add(ChatModel(
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
                  "text": initialPromet + "\n" + question,
                });
                questionController.text = "";
              });
              var (responseString, response) =
              await GeminiApi.geminiChatApi(messages);
              setState(() {
                FocusScope.of(context).unfocus();
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent +
                        MediaQuery.of(context).size.height,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
                if (response.statusCode == 200) {
                  chatList.removeLast();
                  chatList.add(ChatModel(
                      chat: 1,
                      message: responseString,
                      time:
                      "${DateTime.now().hour}:${DateTime.now().second}"));
                } else {
                  chatList.removeLast();
                  chatList.add(ChatModel(
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
