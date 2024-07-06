import 'package:flutter/material.dart';
import 'package:tp3_ai_chatboot/reset.dart';
import 'RuleEngine.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool showAnimation = false;

  void resetChat() {
    setState(() {
      messages.clear();
      ruleEngine.reset();
      messages.add(_createBotMessage(ruleEngine.getQuestion('start')));
      showAnimation = false; 
    });
  }
  List<Widget> messages = [];
  RuleEngine ruleEngine = RuleEngine();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add(_createBotMessage(ruleEngine.getQuestion(ruleEngine.currentRuleKey)));
  }

void _handleResponse(String response, {bool fromButton = false}) {
  setState(() {
    String logicResponse = response.toLowerCase(); //   for logic processing
    String displayResponse = response; //   for display

    if (!fromButton) {
      logicResponse = ruleEngine.analyzeText(response);  
    }

    messages.add(_createUserMessage(displayResponse));

    String nextStep = ruleEngine.getNextStep(ruleEngine.currentRuleKey, logicResponse);

    if (nextStep != 'end') {
      ruleEngine.currentRuleKey = nextStep;
      messages.add(_createBotMessage(ruleEngine.getQuestion(nextStep)));
    } else {
      messages.add(_createBotMessage(ruleEngine.getConclusion()));
    }

    textController.clear();
  });
}

Widget _createUserMessage(String message) {
  return Align(
    alignment: Alignment.centerRight,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
       
        Flexible(  // Allows the container to shrink if there is not enough space
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.only(left: 90, right: 0, bottom: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message, 
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(right: 10 ,left: 5),
          child: Image.asset('assets/man.png', width: 40, height: 40),
        ),
        
      ],
    ),
  );
}

Widget _createBotMessage(String message) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset('assets/chatbot.png', width: 40, height: 40),
        ),
        Flexible(
          child: Container(
                        margin: EdgeInsets.only(left: 5, right: 90, bottom: 10, top: 10),

            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
Widget build(BuildContext context) {
   final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

  return Scaffold(
    appBar: AppBar(
      title: Text('Weather ChatBot'),
      actions: [
        IconButton(
          icon: Icon(Icons.restart_alt),
          onPressed: () {
            setState(() {
              showAnimation = true;  // Start showing the animation
            });
          }),
      ],
    ),
    resizeToAvoidBottomInset: false, // This will prevent the Scaffold from resizing when the keyboard opens.
    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Close the keyboard when tapping outside the TextField.
      child: showAnimation ? FullScreenLottie(onEnd: resetChat) : Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) => messages[messages.length - 1 - index],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding), // Apply padding directly.
            child: buildInputField(),
          ),
        ],
      ),
    ),
  );
}

Widget buildInputField() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: textController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              hintText: 'Type your message here...',
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    _handleResponse(textController.text);
                  }
                },
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            onSubmitted: (text) {
              if (text.isNotEmpty) {
                _handleResponse(text);
              }
            },
          ),
        ),
        SizedBox(height: 10),
        buildResponseButtons(), // Replace old buttons with new modern buttons
      ],
    ),
  );
}

 
 Widget buildButton(String label, String response, Color buttonColor) {
  return ElevatedButton(
    onPressed: () => _handleResponse(response, fromButton: true),
    style: ElevatedButton.styleFrom(
      primary: buttonColor, // Button color
      onPrimary: Colors.white, // Text color
      elevation: 2, // Shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding inside the button
    ),
    child: Text(label, style: TextStyle(fontSize: 16)),
  );
}

Row buildResponseButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildButton('Yes', 'yes', Colors.blue),  
      buildButton('No', 'no', Colors.red),  
    ],
  );
}

}

