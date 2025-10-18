import 'package:flutter/material.dart';

class CreateCardView extends StatefulWidget {
  const CreateCardView({super.key});

  @override
  State<CreateCardView> createState() => _CreateCardViewState();
}

class _CreateCardViewState extends State<CreateCardView> {
  static const double k20 = 20;
  static const kPad20 = EdgeInsets.symmetric(horizontal: k20);

  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _translationCtrl = TextEditingController();
  final _transcriptionCtrl = TextEditingController();
  final _exampleCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _translationCtrl.dispose();
    _transcriptionCtrl.dispose();
    _exampleCtrl.dispose();
    super.dispose();
  }

  String? _requared(String? userImput, String message) {
    if (userImput == null || userImput.trim().isEmpty) return message;
    return null;
  }

  String? _transcription(String userImput) {
    final trimed = userImput.trim();
    if (trimed.isEmpty) return '';
    final left = trimed.startsWith('[') ? '' : '[';
    final right = trimed.endsWith(']') ? '' : ']';
    return '$left$trimed$right';
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
            child: Column(
              children: [
                Row(
                  children: [
                    // TODO тип карточки
                    Expanded(
                      child: DropdownButton(items: [], onChanged: (value) {}),
                    ),
                    // TODO колода
                    Expanded(
                      child: DropdownButton(items: [], onChanged: (value) {}),
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
                            _requared(value, 'title is required');
                            return null;
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
                            _requared(value, 'translation is required');
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _transcriptionCtrl,
                          decoration: InputDecoration(
                            labelText: '[transcription]',
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
