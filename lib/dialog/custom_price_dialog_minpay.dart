import 'package:flutter/material.dart';
import 'package:staff_cleaner/component/textfield/textfield_component.dart';
import 'package:staff_cleaner/values/widget_utils.dart';

class CustomPriceDialogMinpay extends StatefulWidget {
  final String title;

  const CustomPriceDialogMinpay({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomPriceDialogMinpay> createState() => _CustomPriceDialogState();
}

class _CustomPriceDialogState extends State<CustomPriceDialogMinpay> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300.0,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Expanded(
                  child: TextfieldComponent(
                    hintText: "Nama Service",
                    controller: serviceController,
                    inputType: TextInputType.text,
                    isRequired: true,
                  ),
                ),
              ]),
              V(12),
              TextfieldComponent(
                hintText: "Harga",
                controller: hargaController,
                inputType: TextInputType.number,
                isRequired: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, {
                'Nama Service': double.parse(serviceController.text),
                'harga': double.parse(hargaController.text),
              });
            }
          },
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
