import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../pay_unit_sdk.dart';

//production link
var baseUrlSandBox = "https://payunit-sandbox.sevengps.net";
var baseUrl = "https://payunit-core.sevengps.net";

makeToast(msg, context, greenLight) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 15,
      backgroundColor: greenLight,
      textColor: Colors.white,
      fontSize: 16.0);
}

getRandomId() {
  //initialize the Date of the day
  var now = DateTime.now();
  var rng = Random();
  //specify the format of the date
  var formatter = DateFormat('yyyyMMddHmsms');
  String formattedDate = "${formatter.format(now)}${rng.nextInt(100000)}";
  return formattedDate;
}

Widget errorConnexion() {
  return const Padding(
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.signal_wifi_off,
          color: Colors.red,
          size: 40,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Hummmm ... Something when wrong , turn on your internet connexion or look the quality of your internet connexion",
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Widget paymentComponent(
  bool displayError,
  context,
  transactionAmount,
  formKey,
  autoValidate,
  phoneController,
  xApiKey,
  transactionId,
  transactionCallBackUrl,
  providerShortTag,
  merchandPassword,
  merchandUserName,
  actionAfterProccess,
  Function isvalidPhoneState,
  String sandbox,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30),
    child: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          "${getOcy().format((int.parse(transactionAmount)))} XAF",
          style: TextStyle(
              color: Colors.green, fontSize: MediaQuery.of(context).size.width * 0.080, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          "Enter your phone number",
          style: TextStyle(
              color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Form(
          key: formKey,
          autovalidateMode: autoValidate,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.020),
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.phoneFlip,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
                validator: (String? arg) {
                  if (arg!.isEmpty) {
                    return 'Enter a phone number';
                  } else if (arg.length < 9) {
                    return 'The phone number must be 9 digits , example: 6562090** ';
                  } else if (arg.length > 9) {
                    return 'The phone number must be 9 digits , example: 6562090** ';
                  } else
                    return null;
                },
              ),
              const SizedBox(height: 20),
              AnimButton(
                color: Colors.orange,
                pressEvent: () {
                  /// verifier si les champs sont vide .
                  if (formKey.currentState.validate()) {
                    // If all data are correct then save data to out variables
                    formKey.currentState.save();
                    AwesomeDialog(
                            dismissOnBackKeyPress: false,
                            dismissOnTouchOutside: false,
                            context: context,
                            dialogType: DialogType.noHeader,
                            animType: AnimType.bottomSlide,
                            title: "Confirm",
                            desc: 'Do you confirm this payment',
                            btnOkColor: Colors.green,
                            btnOkText: "Confirm",
                            btnOkIcon: Icons.check,
                            btnOkOnPress: () {
                              //set the stream to true if the payment is running
                              // set the stream to false to visible this part of the code
                              payUnitStream.paymentSink.add(true);
                              ApiService api = ApiService();
                              api.makePayment(
                                X_API_KEY: xApiKey,
                                transactionAmount: transactionAmount,
                                transactionId: transactionId,
                                transactionCallBackUrl: transactionCallBackUrl,
                                phoneNumber: phoneController.text,
                                provider_short_tag: providerShortTag,
                                merchandPassword: merchandPassword,
                                merchandUserName: merchandUserName,
                                context: context,
                                actionAfterProccess: actionAfterProccess,
                                sandbox: sandbox,
                                userName: '',
                                currency: null,
                              );
                            },
                            btnCancelOnPress: () {},
                            btnCancelColor: Colors.red,
                            btnCancelIcon: Icons.cancel,
                            btnCancelText: 'Cancel')
                        .show();
                  } else {
                    //If all data are not valid then start auto validation.
                    isvalidPhoneState();
                  }
                },
                text: 'Make Payment',
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Visibility(
          visible: displayError,
          child: const Text(
            "Hummm something didn't work, please retry ",
            style: TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}

void closeAndToastPaymentAreMake(context) {
  Navigator.of(context).pop();
  makeToast("Your transaction has been initiated", context, Colors.blue);
}
