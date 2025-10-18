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
  final List<String> _types = const ['language', 'study'];
  //TODO как то их задавать не здесь и чтобы от юзера хависели и от его колод
  final List<String> _decks = const ['default', 'italian', 'flutter'];

  String? _selectedType;
  String? _selectedDeck;

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

  String? _transcription(String userInput) {
    final trimmed = userInput.trim();
    if (trimmed.isEmpty) return '';
    final left = trimmed.startsWith('[') ? '' : '[';
    final right = trimmed.endsWith(']') ? '' : ']';
    return '$left$trimmed$right';
  }

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(k20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Row(
                  children: [
                    // TODO тип карточки
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'type*'),
                        initialValue:
                            (_selectedType != null &&
                                _types.contains(_selectedType))
                            ? _selectedType
                            : null,
                        items: _types
                            .map(
                              (t) => DropdownMenuItem<String>(
                                value: t,
                                child: Text(t),
                              ),
                            )
                            .toList(),
                        validator: (v) => v == null ? 'choose a type' : null,
                        onChanged: _types.isEmpty
                            ? null
                            : (String? v) => setState(() => _selectedType = v),
                      ),
                    ),
                    // TODO колода
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(labelText: 'deck*'),
                        initialValue:
                            (_selectedDeck != null &&
                                _decks.contains(_selectedDeck))
                            ? _selectedDeck
                            : null,
                        items: _decks
                            .map(
                              (d) => DropdownMenuItem<String>(
                                value: d,
                                child: Text(d),
                              ),
                            )
                            .toList(),
                        validator: (v) => v == null ? 'choose a deck' : null,
                        onChanged: _decks.isEmpty
                            ? null
                            : (String? v) => setState(() => _selectedDeck = v),
                      ),
                    ),
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(k20),
                    child: Column(
                      children: [
                        Text('front side'),
                        TextFormField(
                          controller: _titleCtrl,
                          decoration: InputDecoration(labelText: 'title*'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          maxLength: 60,
                          validator: (value) {
                            _required(value, 'title is required');
                            return;
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
                          textCapitalization: TextCapitalization.sentences,
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
                SizedBox(height: k20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(k20),
                    child: Column(
                      children: [
                        Text('back side'),
                        TextFormField(
                          controller: _translationCtrl,
                          decoration: InputDecoration(
                            labelText: 'translation*',
                          ),
                          autocorrect: true,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          maxLength: 120,
                          validator: (value) {
                            _required(value, 'translation is required');
                            return;
                          },
                        ),
                        TextFormField(
                          controller: _transcriptionCtrl,
                          decoration: InputDecoration(
                            labelText: 'transcription',
                            hintText: '[ˈsæmpl̩]',
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
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          maxLines: 4,
                          maxLength: 180,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: k20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
