import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menampilkan tanggal yang dipilih lewat showDatePicker().
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _institution = "";
  String _level = "S1"; // default
  String _major = "";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;
  String _gpa = "";
  String _activities = "";

  static const int _maxNameLength = 100;
  static const int _maxActivitiesLength = 500;

  final List<String> _levels = ['SMA/SMK', 'D3', 'D4', 'S1', 'S2', 'S3'];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Mengubah DateTime menjadi format dd/mm/yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Membuka date picker untuk tanggal mulai atau tanggal selesai.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 10),
      helpText: isStart ? 'Pilih Tanggal Mulai' : 'Pilih Tanggal Selesai',
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  // Validator teks wajib: tidak boleh kosong/hanya spasi dan ada batas panjang.
  String? _validateRequiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName tidak boleh kosong!";
    }
    if (value.trim().length > _maxNameLength) {
      return "$fieldName maksimal $_maxNameLength karakter!";
    }
    return null;
  }

  // IPK wajib diisi angka 0.00 - 4.00, atau "-" jika tidak ingin dicantumkan.
  String? _validateGpa(String? value) {
    final gpa = value?.trim() ?? "";
    if (gpa.isEmpty) {
      return 'IPK tidak boleh kosong! Isi "-" jika tidak ingin dicantumkan';
    }
    if (gpa == "-") return null;
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(gpa)) {
      return 'IPK harus berupa angka (contoh: 3.75) atau "-"';
    }
    final number = double.parse(gpa.replaceAll(',', '.'));
    if (number < 0 || number > 4) {
      return "IPK harus di antara 0.00 dan 4.00!";
    }
    return null;
  }

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  void _showSummaryDialog() {
    final period =
        '${_formatDate(_startDate!)} - ${_isOngoing ? "Sekarang" : _formatDate(_endDate!)}';
    final activities = _activities.trim().isEmpty ? "-" : _activities.trim();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil disimpan'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_institution.trim()}'),
                Text('Jenjang: $_level'),
                Text('Jurusan/Program Studi: ${_major.trim()}'),
                Text('Periode: $period'),
                Text('IPK: ${_gpa.trim()}'),
                Text('Kegiatan & Prestasi: $activities'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pendidikan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView agar semua input dan tombol Simpan tetap bisa
        // dijangkau pada layar sempit atau saat papan ketik tampil.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === Nama Institusi ===
              TextFormField(
                decoration: _decoration(
                  "Nama Institusi",
                  hint: "Contoh: Universitas Indonesia",
                ),
                onChanged: (String value) {
                  setState(() {
                    _institution = value;
                  });
                },
                validator: (value) =>
                    _validateRequiredText(value, "Nama institusi"),
              ),
              const SizedBox(height: 16),

              // === Jenjang ===
              DropdownButtonFormField<String>(
                decoration: _decoration("Jenjang"),
                initialValue: _level,
                items: _levels
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _level = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // === Jurusan / Program Studi ===
              TextFormField(
                decoration: _decoration(
                  "Jurusan/Program Studi",
                  hint: "Contoh: Ilmu Komputer",
                ),
                onChanged: (String value) {
                  setState(() {
                    _major = value;
                  });
                },
                validator: (value) =>
                    _validateRequiredText(value, "Jurusan/Program studi"),
              ),
              const SizedBox(height: 16),

              // === Tanggal Mulai ===
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: _decoration(
                  "Tanggal Mulai",
                  hint: "dd/mm/yyyy",
                  suffix: const Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(isStart: true),
                validator: (_) {
                  if (_startDate == null) {
                    return "Tanggal mulai harus diisi!";
                  }
                  return null;
                },
              ),

              // === Masih Berlangsung ===
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Masih berlangsung"),
                value: _isOngoing,
                onChanged: (bool? value) {
                  setState(() {
                    _isOngoing = value ?? false;
                    if (_isOngoing) {
                      _endDate = null;
                      _endDateController.clear();
                    }
                  });
                },
              ),

              // === Tanggal Selesai (disembunyikan jika masih berlangsung) ===
              if (!_isOngoing) ...[
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Selesai",
                    hint: "dd/mm/yyyy",
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (_) {
                    if (_endDate == null) {
                      return "Tanggal selesai harus diisi!";
                    }
                    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // === IPK ===
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: _decoration(
                  "IPK",
                  hint: 'Contoh: 3.75, atau "-" jika tidak dicantumkan',
                ),
                onChanged: (String value) {
                  setState(() {
                    _gpa = value;
                  });
                },
                validator: _validateGpa,
              ),
              const SizedBox(height: 16),

              // === Kegiatan & Prestasi ===
              TextFormField(
                maxLines: 5,
                maxLength: _maxActivitiesLength,
                decoration: _decoration(
                  "Kegiatan & Prestasi (opsional)",
                  hint:
                      "Contoh: Juara 1 Lomba Competitive Programming, "
                      "Ketua BEM, Asisten Dosen",
                ),
                onChanged: (String value) {
                  setState(() {
                    _activities = value;
                  });
                },
                validator: (String? value) {
                  if (value != null &&
                      value.trim().length > _maxActivitiesLength) {
                    return "Kegiatan & prestasi maksimal "
                        "$_maxActivitiesLength karakter!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // === Tombol Simpan ===
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showSummaryDialog();
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
