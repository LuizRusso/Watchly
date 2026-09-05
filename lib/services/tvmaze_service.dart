import 'dart:convert';
import 'package:http/http.dart' as http;

class TvmazeService {
  static const String baseUrl = 'https://api.tvmaze.com';

  Future<List<dynamic>> buscarSeries(String busca) async {
    final url = Uri.parse(
      '$baseUrl/search/shows?q=${Uri.encodeComponent(busca)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Erro ao buscar séries');
  }

Future<List<dynamic>> buscarSeriePorId(int id) async {
  final url = Uri.parse('$baseUrl/shows/$id?embed=episodes');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data['_embedded']['episodes'] ?? [];
  }

  throw Exception('Erro ao buscar episódios');
}
}