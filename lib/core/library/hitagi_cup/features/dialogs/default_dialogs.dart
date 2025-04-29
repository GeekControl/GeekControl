enum FastDescription {
  error,
  inProgress,
  unavailable,
  success,
  warning,
}

extension FastDescriptionExtension on FastDescription {
  String get message {
    switch (this) {
      case FastDescription.error:
        return 'Ocorreu um erro. Por favor, tente novamente mais tarde.';
      case FastDescription.unavailable:
        return 'Esta função está temporariamente indisponível.';
      case FastDescription.success:
        return 'Operação concluída com sucesso.';
      case FastDescription.warning:
        return 'Atenção! Esta operação pode causar problemas.';
      case FastDescription.inProgress:
        return 'Ainda estamos trabalhando nesta funcionalidade, novidades em breve!.';
    }
  }
}

enum FastText {
  error,
  unavailable,
  success,
  warning,
}

extension FastTextExtension on FastText {
  String get title {
    switch (this) {
      case FastText.error:
        return 'Erro';
      case FastText.unavailable:
        return 'Indisponível';
      case FastText.success:
        return 'Sucesso';
      case FastText.warning:
        return 'Aviso';
      }
  }
}
