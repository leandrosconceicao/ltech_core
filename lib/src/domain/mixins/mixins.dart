import 'package:ltech_core/src/domain/extensions/extensions.dart';

mixin FormValidators {

  String? notAllowedEmptyText(String? txt) {
    if (!(txt?.hasContent ?? false)) {
      return "Obrigatório";
    }
    return null;
  }

  String? passwordConfirmation(String newPass, String confirmationPass) {
    if (newPass.isEmpty) {
      return "Obrigatório";
    }
    if (newPass != confirmationPass) {
      return "Senhas não são iguais.";
    }
    return null;
  }

  String? onlyLettersAndNumbers(String? text) {
    if (!text!.hasContent) {
      return "Obrigatório";
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text)) {
      return "Inválido";
    }
    return null;
  }

  String? validaInputCep(String? text) {
    if (!text!.hasContent) {
      return "Obrigatório";
    }
    if (text.length < 9) {
      return "Inválido";
    }
    return null;
  }
}