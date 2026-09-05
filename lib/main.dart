import 'package:flutter/material.dart';

import 'services/tvmaze_service.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final TextEditingController _searchController = TextEditingController();
List<dynamic> _resultados = [];
bool _carregando = false;

Future<void> _buscarSeries() async {
  if (_searchController.text.trim().isEmpty) return;

  setState(() {
    _carregando = true;
  });

  try {
    final resultados = await TvmazeService().buscarSeries(
      _searchController.text.trim(),
    );

    setState(() {
      _resultados = resultados;
      _carregando = false;
    });
  } catch (e) {
    setState(() {
      _carregando = false;
    });

    debugPrint('Erro ao buscar séries: $e');
  }
}

Future<void> _abrirEpisodios(int id, String nome) async {
  try {
    final episodios = await TvmazeService().buscarSeriePorId(id);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpisodiosPage(
          nome: nome,
          episodios: episodios,
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao buscar episódios: $e'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Meu App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _buscarSeries,
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar filme ou série...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _buscarSeries,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_carregando)
            const Center(
              child: CircularProgressIndicator(),
            ),

       if (!_carregando && _resultados.isNotEmpty)
  ..._resultados.map(
    (resultado) {
      final show = resultado['show'];

      return Card(
        child: ListTile(
          title: Text(
            show['name'] ?? 'Sem nome',
          ),
          subtitle: Text(
            show['premiered'] ?? 'Data desconhecida',
          ),
          trailing: const Icon(
            Icons.arrow_forward,
          ),
          onTap: () {
           final rawId = show['id'];

if (rawId is int) {
  _abrirEpisodios(
    rawId,
    show['name'] ?? 'Sem nome',
  );
} else {
  debugPrint('ID inesperado: $rawId');
  debugPrint('Tipo do ID: ${rawId.runtimeType}');
}
          },
        ),
      );
    },
  ),
          const SizedBox(height: 20),

            const Text(
              'Continuar assistindo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Conteúdo em andamento
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF30234A),
                    Color(0xFF17151F),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Stranger Things',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Temporada 2 • Episódio 4',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.72,
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    '72% assistido',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text('Netflix'),
                        ],
                      ),

                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Continuar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Minha biblioteca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CategoryCard(
                    icon: Icons.movie_outlined,
                    title: 'Filmes',
                    count: '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CategoryCard(
                    icon: Icons.tv_outlined,
                    title: 'Séries',
                    count: '0',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CategoryCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Documentários',
                    count: '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CategoryCard(
                    icon: Icons.star_outline,
                    title: 'Avaliações',
                    count: '0',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddContentPage(), 
                  ),
                 );
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Adicionar filme ou série',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Avaliações',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
class EpisodiosPage extends StatefulWidget {
  final String nome;
  final List<dynamic> episodios;

  const EpisodiosPage({
    super.key,
    required this.nome,
    required this.episodios,
  });

  @override
  State<EpisodiosPage> createState() => _EpisodiosPageState();
}

class _EpisodiosPageState extends State<EpisodiosPage> {
  final Set<int> _assistidos = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
      ),
      body: ListView.builder(
        itemCount: widget.episodios.length,
        itemBuilder: (context, index) {
          final episodio = widget.episodios[index];
          final assistido = _assistidos.contains(index);

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${episodio['number'] ?? '?'}',
                ),
              ),
              title: Text(
                episodio['name'] ?? 'Episódio sem nome',
              ),
              subtitle: Text(
                'Temporada ${episodio['season'] ?? '?'}',
              ),
              trailing: Checkbox(
                value: assistido,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _assistidos.add(index);
                    } else {
                      _assistidos.remove(index);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}



class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF19191F),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            count,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class AddContentPage extends StatelessWidget {
  const AddContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar conteúdo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O que você quer adicionar?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                labelText: 'Nome do filme ou série',
                hintText: 'Ex: Stranger Things',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Tipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.movie),
                    label: const Text('Filme'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.tv),
                    label: const Text('Série'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Adicionar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}