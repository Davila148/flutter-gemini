import 'package:flutter/material.dart';
import 'package:flutter_gemini_app/generate_content_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String prompt = '¿Que opinas de Flutter y su crecimiento en Colombia?';
  GenerateContentProvider? generateContentProvider;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> answers = [];
  List<String> questions = [];

  @override
  void initState() {
    super.initState();
    generateContentProvider = GenerateContentProvider.of(context);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Text(
          'Gemini ✦!',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FutureBuilder(
              future: generateContentProvider!.obtenerRespuestaGemini(prompt),
              builder: (context, respuestaAsync) {
                if (respuestaAsync.connectionState == ConnectionState.done) {
                  // print(respuestaAsync.data);
                  questions.add(prompt);
                  answers.add(respuestaAsync.data!);
                  Future.delayed(Duration.zero, () {
                    // Desplazamos el ListView al final
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(microseconds: 1),
                      curve: Curves.easeOut,
                    );
                  });
                  return ListView.builder(
                    itemCount: answers.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors
                                  .grey[700], // Color de fondo de la "nube"
                            ),
                            child: Text(
                              questions[index],
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors
                                  .grey[900], // Color de fondo de la "nube"
                            ),
                            child: Text(
                              answers[index],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const LinearProgressIndicator(),
                      Text(
                        'Pensando...',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(
          bottom: 30.0,
          left: 20.0,
          right: 20.0,
          top: 10.0,
        ),
        color: Colors.grey[800],
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                child: TextFormField(
                  controller: textEditingController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: null,
                  enableSuggestions: true,
                  onFieldSubmitted: (newValue) => _sendQuery(),
                ),
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => _sendQuery(),
              icon: const Icon(
                color: Colors.deepPurple,
                Icons.send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendQuery() {
    setState(() {
      prompt = textEditingController.text.trim();
      textEditingController.clear();
    });
  }
}
