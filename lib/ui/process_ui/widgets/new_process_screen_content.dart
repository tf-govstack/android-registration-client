import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:registration_client/model/field.dart';
import 'package:registration_client/model/screen.dart';
import 'package:registration_client/provider/global_provider.dart';
import 'package:registration_client/ui/process_ui/widgets/age_date_control.dart';
import 'package:registration_client/ui/process_ui/widgets/checkbox_control.dart';
import 'package:registration_client/ui/process_ui/widgets/dropdown_control.dart';
import 'package:registration_client/ui/process_ui/widgets/html_box_control.dart';
import 'package:registration_client/ui/process_ui/widgets/custom_label.dart';
import 'package:registration_client/ui/process_ui/widgets/custom_preferred_lang_button.dart';
import 'package:registration_client/ui/process_ui/widgets/textbox_control.dart';

import 'radio_button_control.dart';

class NewProcessScreenContent extends StatefulWidget {
  const NewProcessScreenContent(
      {super.key, required this.context, required this.screen});
  final BuildContext context;
  final Screen screen;

  @override
  State<NewProcessScreenContent> createState() =>
      _NewProcessScreenContentState();
}

class _NewProcessScreenContentState extends State<NewProcessScreenContent> {
  Map<String, dynamic> formValues = {};
  Widget widgetType(Field e) {
    RegExp regexPattern = RegExp(r'^.*$');

    if (e.validators!.isNotEmpty) {
      final validation = e.validators?.first?.validator;
      if (validation != null) {
        regexPattern = RegExp(validation);
      }
    }

    if (e.controlType == "checkbox") {
      return CustomCheckbox(field: e);
    }
    if (e.controlType == "html") {
      return CustomHtmlBox(field: e);
    }
    if (e.controlType == "button") {
      if (e.subType == "preferredLang") {
        return CustomPreferredLangButton(field: e);
      }
      if (e.subType == "gender" || e.subType == "residenceStatus") {
        Map<String, List<String>> values = {
          'gender': ["Female", "Male", "Others"],
          'residenceStatus': ["Permanent", "Temporary"],
        };
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabel(feild: e),
                RadioFormField(
                  onChanged: (value) => formValues[e.label!["eng"]!] = value,
                  values: values[e.subType] ?? [],
                ),
              ],
            ),
          ),
        );
      }
      return Text("${e.controlType}");
    }
    if (e.controlType == "textbox") {
      List<String> choosenLang = context.read<GlobalProvider>().chosenLang;
      List<String> singleTextBox = [
        "Phone",
        "Email",
        "introducerName",
        "RID",
        "UIN",
        "none"
      ];
      if (singleTextBox.contains(e.subType)) {
        choosenLang = ["English"];
      }

      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(feild: e),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: choosenLang.map((code) {
                  String newCode =
                      context.read<GlobalProvider>().langToCode(code);
                  return CustomTextBox(
                      onChanged: (value) =>
                          formValues[e.label![newCode]!] = value,
                      label: e.label![newCode]!.toString(),
                      lang: newCode,
                      validation: regexPattern);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
    if (e.controlType == "dropdown") {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(feild: e),
              const SizedBox(
                height: 10,
              ),
              CustomDropDown(
                onChanged: (value) => formValues[e.label!["eng"]!] = value,
              ),
            ],
          ),
        ),
      );
    }
    if (e.controlType == "ageDate") {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(feild: e),
              const SizedBox(
                height: 10,
              ),
              AgeDate(
                onChanged: (value) => formValues[e.label!["eng"]!] = value,
                validation: regexPattern,
              ),
            ],
          ),
        ),
      );
    }

    return Text("${e.controlType}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.screen.fields!.map((e) {
          if (e!.inputRequired == true) {
            return widgetType(e);
          }
          return Container();
        }).toList(),
      ],
    );
  }
}
