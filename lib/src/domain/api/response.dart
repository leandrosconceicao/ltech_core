import 'dart:convert';

class ApiResponse<T> {
  Map<String, String>? headers;

  String description;

  bool result;

  num? statusCode;

  String? tecnicalDescription;

  T? data;

  ApiResponse({
    required this.description,
    required this.result,
    this.tecnicalDescription,
    this.statusCode,
    this.data,
    this.headers,
    this.rawBody,
  });

  bool get hasTecnical => tecnicalDescription != null;

  ApiResponse.result({
    required this.data,
    this.description = "",
    this.result = true,
    this.statusCode = 200,
  });

  ApiResponse.success({
    this.description = "",
    this.tecnicalDescription,
    this.result = true,
    this.statusCode = 200,
  });

  ApiResponse.fromJson(
    Map<String, dynamic> json,
    int this.statusCode, {
    T? Function(dynamic)? parser,
  }) : description = json['message'] ?? "",
       tecnicalDescription = json['tecnical'],
       result = json['statusProcess'] ?? false;

  ApiResponse.timeout()
    : result = false,
      statusCode = 504,
      description = "Tempo de requisição excedido";

  ApiResponse.unknow({String? errorDescription, String? stackTrace})
    : result = false,
      statusCode = 500,
      description = errorDescription ?? "Ocorreu um erro desconhecido",
      tecnicalDescription = stackTrace;

  ApiResponse.badRequest({String? errorDescription})
    : result = false,
      statusCode = 400,
      description = errorDescription ?? "Houve um problema com a solicitação";

  ApiResponse.notFound({String? message})
    : result = false,
      statusCode = 404,
      description =
          message ?? "Busca não localizou dados ou nenhum dado foi retornado";

  ApiResponse.unauthorizedAccess({String? message})
    : result = false,
      statusCode = 401,
      description = message ?? "Acesso não permitido";

  ApiResponse.connError()
    : result = false,
      statusCode = 502,
      description = "Ocorreu um problema de conexão";

  ApiResponse.socketError()
    : result = false,
      statusCode = 503,
      description = "Não foi possível se conectar com o servidor";

  ApiResponse.jsonProblem({Object? error, Object? stk})
    : result = false,
      statusCode = 500,
      description =
          "Ocorreu um problema ao preparar os dados:\n${error.toString()}",
      tecnicalDescription = stk.toString();

  static ApiResponse fromEventSource<T>(
    String data, {
    required T Function(Map<String, dynamic> json) parser,
  }) {
    try {
      final rawData = jsonDecode(data);
      if (rawData! is Map<String, dynamic>) {
        return ApiResponse.jsonProblem(error: "Json inválido", stk: data);
      }
      if ((rawData as Map<String, dynamic>).isEmpty) {
        return ApiResponse.jsonProblem(error: "Json inválido", stk: data);
      }
      final json = rawData["response"];
      return ApiResponse<T>.fromJson(json, 200, parser: (data) => parser(data));
    } catch (err, stk) {
      return ApiResponse.jsonProblem(error: err, stk: stk);
    }
  }

  dynamic rawBody;
}
