import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _techStack = "";
  String _projectUrl = "";
  String _projectImageUrl = "";
  bool _isSubmitting = false;

  // Cek format URL: harus http/https dan punya host
  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _submit() async {
    // 1. Validasi form
    if (!_formKey.currentState!.validate()) return;

    // 2. Pastikan sudah login
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final token = auth.token;
    if (token == null) return;

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 3. Kirim ke Django
      final created = await context
          .read<ApiClient>()
          .createProject(newProject, token: token);
      if (!mounted) return;

      // 4. 201 Created -> tampilkan AlertDialog
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Proyek berhasil ditambahkan'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Title: ${created.title}'),
                  Text('Description: ${created.description}'),
                  Text('Tech Stack: ${created.techStack}'),
                  Text('Project URL: ${created.projectUrl}'),
                  if (created.projectImageUrl.isNotEmpty)
                    Text('Image URL: ${created.projectImageUrl}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        // Token tidak valid / kadaluarsa -> logout & minta login ulang
        await auth.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi habis, silakan login ulang.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan (${e.statusCode}): ${e.message}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      hintText: hint ?? label,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration("Title"),
                  onChanged: (value) => _title = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _decoration("Description"),
                  onChanged: (value) => _description = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tech Stack ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Tech Stack",
                    hint: "Contoh: Flutter, Django, PostgreSQL",
                  ),
                  onChanged: (value) => _techStack = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tech stack tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Project URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    "Project URL",
                    hint: "https://github.com/username/repo",
                  ),
                  onChanged: (value) => _projectUrl = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Project URL tidak boleh kosong!";
                    }
                    if (!_isValidUrl(value)) {
                      return "Format URL tidak valid (harus diawali http:// atau https://)";
                    }
                    return null;
                  },
                ),
              ),

              // === Project Image URL (Optional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    "Project Image URL (Optional)",
                    hint: "https://example.com/image.png",
                  ),
                  onChanged: (value) => _projectImageUrl = value,
                  validator: (value) {
                    // Boleh kosong, tapi kalau diisi harus URL valid
                    if (value == null || value.trim().isEmpty) return null;
                    if (!_isValidUrl(value)) {
                      return "Format URL tidak valid";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}