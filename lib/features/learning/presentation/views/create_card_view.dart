import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateCardView extends StatefulWidget {
  const CreateCardView({super.key});

  @override
  State<CreateCardView> createState() => _CreateCardViewState();
}

class _CreateCardViewState extends State<CreateCardView> {
  static const double k20 = 20;
  static const double k12 = 12;
  static const kPad20 = EdgeInsets.symmetric(horizontal: k20);

  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _translationCtrl = TextEditingController();
  final _transcriptionCtrl = TextEditingController();
  final _exampleCtrl = TextEditingController();

  //TODO чтобы кастомные типы юзер мог добавлять? возможно
  final List<String> _types = const ['study', 'language'];
  //TODO как то их задавать не здесь и чтобы от юзера хависели и от его колод
  final List<String> _decks = const ['default', 'italian', 'flutter'];

  String? _selectedType;
  String? _selectedDeck;

  @override
  void initState() {
    super.initState();
    _selectedType = _types.first;
    _selectedDeck = _decks.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _translationCtrl.dispose();
    _transcriptionCtrl.dispose();
    _exampleCtrl.dispose();
    super.dispose();
  }

  String? _required(String? userInput, String message) {
    if (userInput == null || userInput.trim().isEmpty) return message;
    return null;
  }

  String _transcription(String userInput) {
    final trimmed = userInput.trim();
    if (trimmed.isEmpty) return '';
    final left = trimmed.startsWith('[') ? '' : '[';
    final right = trimmed.endsWith(']') ? '' : ']';
    return '$left$trimmed$right';
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (!isValid) return;

    // _formKey.currentState!.save(); // TODO сделать локальное хранилище на устройстве а в файербазе только при подписке

    // final repo = ref.read(); TODO создать репо

    final data = {
      'type': _selectedType,
      'deckId': _selectedDeck,
      'title': _titleCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim().isEmpty
          ? null
          : _descriptionCtrl.text.trim(),
      'translation': _translationCtrl.text.trim(),
      'transcription': () {
        final t = _transcriptionCtrl.text.trim();
        if (t.isEmpty) return null;
        return _transcription(t);
      }(),
      'example': _exampleCtrl.text.trim().isEmpty
          ? null
          : _exampleCtrl.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('decks')
          .doc(_selectedDeck)
          .collection('cards')
          .add(data);
      _formKey.currentState?.reset();
      _titleCtrl.clear();
      _descriptionCtrl.clear();
      _translationCtrl.clear();
      _transcriptionCtrl.clear();
      _exampleCtrl.clear();
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.code}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: cs.surface,
      body: Padding(
        padding: kPad20,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            // TODO тип карточки
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'type*',
                                ),
                                initialValue: _selectedType,
                                items: _types
                                    .map(
                                      (t) => DropdownMenuItem<String>(
                                        value: t,
                                        child: Text(t),
                                      ),
                                    )
                                    .toList(),
                                validator: (v) =>
                                    v == null ? 'choose a type' : null,
                                onChanged: _types.isEmpty
                                    ? null
                                    : (String? v) =>
                                          setState(() => _selectedType = v),
                              ),
                            ),
                            // TODO колода
                            const SizedBox(width: k12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'deck*',
                                ),
                                initialValue: _selectedDeck,
                                items: _decks
                                    .map(
                                      (d) => DropdownMenuItem<String>(
                                        value: d,
                                        child: Text(d),
                                      ),
                                    )
                                    .toList(),
                                validator: (v) =>
                                    v == null ? 'choose a deck' : null,
                                onChanged: _decks.isEmpty
                                    ? null
                                    : (String? v) =>
                                          setState(() => _selectedDeck = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: k20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(k20),
                          child: Column(
                            children: [
                              const Text('front side'),
                              TextFormField(
                                controller: _titleCtrl,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'title*',
                                  counterText: '',
                                ),
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                maxLength: 60,

                                validator: (value) {
                                  return _required(value, 'title is required');
                                },
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                              TextFormField(
                                controller: _descriptionCtrl,
                                decoration: InputDecoration(
                                  labelText: 'description',
                                  hintText: 'brief context',
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                maxLength: 180,
                                maxLines: 3,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: k20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(k20),
                          child: Column(
                            children: [
                              const Text('back side'),
                              TextFormField(
                                controller: _translationCtrl,
                                decoration: InputDecoration(
                                  labelText: 'translation*',
                                  counterText: '',
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                maxLength: 120,
                                validator: (value) {
                                  return _required(
                                    value,
                                    'translation is required',
                                  );
                                },
                              ),
                              TextFormField(
                                controller: _transcriptionCtrl,
                                decoration: InputDecoration(
                                  labelText: 'transcription',
                                  hintText: '[ˈsæmpl̩]',
                                  counterText: '',
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                maxLength: 80,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                              TextFormField(
                                controller: _exampleCtrl,
                                decoration: InputDecoration(
                                  labelText: 'example',
                                  hintText: 'short sentence with the term',
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.done,
                                maxLines: 4,
                                maxLength: 180,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Submit'),
              ),
            ),
            SizedBox(height: k12),
          ],
        ),
      ),
    );
  }
}
