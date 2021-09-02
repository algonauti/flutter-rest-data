import 'package:flutter/material.dart';
import 'package:flutter_rest_data/flutter_rest_data.dart';

class ErrorPresenter {
  static void showError(BuildContext context, {required Exception error}) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          _getHumanReadableErrorDescription(error),
        ));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String _getHumanReadableErrorDescription(Exception e) {
    if (e is NoNetworkError) {
      return 'Network is not available';
    } else if (e is NetworkError) {
      return 'Error while trying to access the server';
    }

    return 'Unexpected error';
  }
}
