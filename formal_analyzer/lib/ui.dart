import 'package:flutter/material.dart';

abstract class UI {
  static Widget layout(List<Widget> leftColumn, List<Widget> rightColumn) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: leftColumn),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: rightColumn),
          ),
        )
      ],
    );
  }

  static Widget codeInput(String code, void Function(String code) analyze) {
    TextEditingController codeInputController = TextEditingController();
    codeInputController.text = code;
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 5),
                  child: const Text("Source code:",
                      style: TextStyle(fontSize: 16)),
                ),
                TextField(
                  maxLines: 10,
                  controller: codeInputController,
                  keyboardType: TextInputType.multiline,
                  style:
                      const TextStyle(fontFamily: "Consolas"),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            )),
        Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: () => analyze(codeInputController.text),
              child: const Text("Analyze")),
        )
      ],
    );
  }

  static Widget outputField(String title, String text, int lines) {
    TextEditingController prettyCodeController = TextEditingController();
    prettyCodeController.text = text;
    return Container(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            TextField(
              readOnly: true,
              maxLines: lines,
              controller: prettyCodeController,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontFamily: "Consolas"),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2),
                ),
              ),
            ),
          ],
        ));
  }
}
