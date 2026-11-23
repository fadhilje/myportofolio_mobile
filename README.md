# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Tugas 7
## Pertanyaan Relatif
### 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!
Di Flutter, hampir semuanya adalah widget: teks, tombol, jarak (padding), tata letak, bahkan aplikasinya sendiri. Widget-widget ini tidak berdiri sendiri, tapi saling dibungkus satu sama lain sehingga membentuk struktur seperti pohon. Struktur inilah yang disebut **widget tree**. Puncaknya adalah widget root, lalu bercabang ke widget-widget di dalamnya sampai ke widget paling ujung seperti `Text` atau `Icon`.
 
Hubungan antarwidget di dalam pohon ini disebut **parent-child**. Widget yang membungkus disebut *parent*, dan widget yang dibungkus disebut *child*. Parent menentukan ruang dan batasan ukuran yang boleh dipakai child-nya, lalu child menentukan ukurannya sendiri di dalam batasan itu. Kalau widget hanya bisa punya satu anak, kita pakai properti `child` (contohnya `Padding`, `Center`, `Container`). Kalau bisa punya banyak anak, kita pakai `children` (contohnya `Column`, `Row`, `GridView`).
 
Gambaran widget tree di proyek ini kurang lebih seperti ini:
 
```
MaterialApp
└── MyHomePage
    └── Scaffold
        ├── AppBar
        │   └── Text
        └── SingleChildScrollView
            └── Padding
                └── Column
                    ├── Row
                    │   ├── InfoCard (NPM)
                    │   ├── InfoCard (Name)
                    │   └── InfoCard (Class)
                    ├── SizedBox
                    └── Center
                        └── Column
                            ├── Padding → Text
                            └── GridView
                                └── ItemCard (x5)
```
 
Jadi `Column` yang paling atas adalah parent dari `Row`, `SizedBox`, dan `Center`. Di sisi lain, `Row` adalah child dari `Column` tadi, sekaligus parent dari tiga `InfoCard`. Satu widget bisa jadi parent dan child sekaligus, tergantung dilihat dari sisi mana.

### 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!
**Di `main.dart`:**
 
- `MyApp`: widget root buatan sendiri (`StatelessWidget`) yang tugasnya membangun `MaterialApp`.
- `MaterialApp`: pembungkus utama aplikasi. Di sinilah tema, judul, dan halaman awal (`home`) diatur.
**Di `menu.dart`:**
 
- `MyHomePage`: halaman utama aplikasi, tempat semua tampilan disusun.
- `Scaffold`: kerangka dasar sebuah halaman. Dia menyediakan tempat untuk `AppBar`, isi halaman (`body`), dan juga tempat `SnackBar` muncul.
- `AppBar`: bar di bagian atas yang berisi judul "MyPortfolio".
- `Text`: untuk menampilkan tulisan, mulai dari judul, NPM, nama, kelas, sampai nama tombol.
- `SingleChildScrollView`: supaya halaman bisa di-scroll. Tanpa ini, kalau isinya lebih tinggi dari layar akan muncul error *bottom overflow*.
- `Padding`: memberi jarak kosong di sekeliling widget.
- `Column`: menyusun widget secara vertikal, dari atas ke bawah.
- `Row`: menyusun widget secara horizontal. Di sini dipakai untuk menjajarkan tiga `InfoCard`.
- `SizedBox`: kotak kosong dengan ukuran tertentu, dipakai sebagai spasi antarbagian.
- `Center`: menaruh widget di tengah.
- `GridView.count`: menampilkan item dalam bentuk kisi dengan jumlah kolom tetap. Di sini ada 3 kolom untuk tombol-tombol menu.
- `InfoCard`: widget buatan sendiri untuk menampilkan satu informasi profil (judul dan isinya).
- `Card`: kartu dengan sedikit bayangan, dipakai sebagai dasar tampilan `InfoCard`.
- `Container`: kotak serbaguna yang dipakai untuk mengatur lebar dan padding di dalam kartu.
- `ItemCard`: widget buatan sendiri untuk satu tombol menu, lengkap dengan ikon, teks, dan warna.
- `Material`: permukaan bergaya Material Design. Dipakai untuk memberi warna latar dan sudut membulat pada tombol.
- `InkWell`: membuat sebuah area bisa ditekan (`onTap`) dan memberi efek percikan saat disentuh.
- `Icon`: menampilkan ikon pada tiap tombol.
- `SnackBar`: pesan singkat yang muncul di bawah layar setelah tombol ditekan. Cara memunculkannya lewat `ScaffoldMessenger`.

### 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!
`MaterialApp` adalah widget yang menyiapkan fondasi aplikasi dengan gaya **Material Design**. Beberapa hal yang diurus olehnya:
 
- **Tema (`theme`)**: warna dan gaya seluruh aplikasi diatur sekali di sini. Di proyek ini kita memakai `ColorScheme.fromSeed` dengan warna dasar indigo.
- **Halaman awal (`home`)**: menentukan halaman pertama yang tampil, yaitu `MyHomePage`.
- **Navigasi**: menyediakan `Navigator` untuk pindah antarhalaman.
- **Judul aplikasi (`title`)**: nama aplikasi yang dikenali oleh sistem.
- **Layanan pendukung**: seperti `MediaQuery` dan `ScaffoldMessenger`, yang dibutuhkan widget lain di bawahnya.
Alasan `MaterialApp` biasanya ditaruh paling atas adalah karena widget-widget Material seperti `Scaffold`, `AppBar`, dan `SnackBar` bergantung pada hal-hal yang disediakan olehnya, terutama tema dan layanan di atas. Kalau ditaruh di puncak, semua halaman otomatis memakai tema yang sama, jadi tampilannya konsisten dan kita tidak perlu mengatur ulang di setiap halaman.

### 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?
Perbedaan paling mendasar ada di **state**, yaitu data yang bisa berubah selama aplikasi berjalan.
 
`StatelessWidget` tidak menyimpan state. Tampilannya hanya ditentukan oleh data yang diberikan lewat constructor, jadi kalau datanya sama, hasilnya selalu sama. Cukup satu class dengan method `build()`.
 
`StatefulWidget` menyimpan state yang bisa berubah. Ketika state berubah (lewat `setState()`), Flutter membangun ulang tampilannya. Strukturnya terdiri dari dua class: widget-nya dan class `State`-nya.
 
**Kapan pakai `StatelessWidget`?** Saat tampilan tidak perlu berubah dengan sendirinya. Di proyek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` semuanya stateless karena data NPM, nama, kelas, dan daftar tombolnya tetap.
 
**Kapan pakai `StatefulWidget`?** Saat tampilan perlu berubah karena interaksi atau data baru. Contohnya counter yang angkanya bertambah, checkbox yang dicentang, isian form, atau data yang baru dimuat dari internet.

### 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?
`BuildContext` menunjukkan **posisi sebuah widget di dalam widget tree**. Lewat `context` ini, sebuah widget bisa "bertanya ke atas" untuk mengambil informasi dari widget induknya, seperti tema, ukuran layar, atau `ScaffoldMessenger`.
 
Itulah kenapa dia penting: tanpa `BuildContext`, widget tidak punya cara untuk tahu apa yang ada di sekitarnya di dalam tree.
 
Di method `build(BuildContext context)`, kita memakainya dengan pola `Something.of(context)`, yang artinya "cari `Something` terdekat di atas widget ini". Contoh di proyek ini:
 
```dart
// Mengambil warna utama dari tema yang diatur di MaterialApp
backgroundColor: Theme.of(context).colorScheme.primary,
 
// Mengambil lebar layar untuk menentukan lebar InfoCard
width: MediaQuery.of(context).size.width / 3.5,
 
// Mengambil ScaffoldMessenger terdekat untuk menampilkan SnackBar
ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")));
```

### 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?
**Hot reload** memasukkan perubahan kode terbaru ke aplikasi yang sedang jalan, tanpa mengulang dari awal. Yang paling enak, **state tetap tersimpan**. Misalnya kita sedang ada di halaman tertentu atau angka counter sudah 10, semuanya tetap sama setelah reload. Prosesnya sangat cepat, dan di terminal dipicu dengan tombol `r`.
 
**Hot restart** menjalankan ulang aplikasi dari awal (`main()` dipanggil lagi), jadi **semua state kembali ke kondisi awal**. Lebih lambat dari hot reload, tapi masih jauh lebih cepat daripada menjalankan ulang total. Di terminal dipicu dengan `R` (huruf besar).
 
**Kapan hot reload saja tidak cukup?**
 
Perlu **hot restart** kalau kita mengubah hal-hal yang cuma dijalankan sekali di awal, misalnya:
 
- isi `main()`,
- nilai awal variabel global atau `static`,
- isi `initState()`,
- struktur class, seperti mengubah `StatelessWidget` jadi `StatefulWidget`.
Perlu **full restart** (stop, lalu `flutter run` lagi) kalau kita mengubah hal-hal di luar kode Dart biasa, misalnya:
 
- menambah atau mengubah dependency di `pubspec.yaml`,
- menambah asset atau font,
- mengubah kode native atau konfigurasi platform, seperti `AndroidManifest.xml`.
Kalau tampilan terasa tidak sesuai dengan kode terbaru setelah hot reload, coba hot restart dulu sebelum mencari masalah di tempat lain.

## AI Disclosure
Di tugas Kali ini saya tidak menggunakan GenAI apapun. Di tugas ini, saya hanya berpedoman pada tutorial yang telah di sediakan.

# Tugas 8
## Pertanyaan Relatif
### 1. Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.

Navigator mengelola halaman seperti stack. `push()` menaruh halaman baru di atas halaman saat ini sehingga halaman sebelumnya masih bisa dikembalikan dengan back. `pushReplacement()` mengganti halaman saat ini dengan halaman baru, sehingga halaman lama dihapus dari stack dan tidak bisa dikembalikan. `pop()` membuang halaman paling atas dan kembali ke halaman sebelumnya, sama seperti tombol back.

Formulir dari kartu aksi dibuka dengan `Navigator.push()` yang dipicu di onTap kartu saat `item.name == "Tambah Proyek"`. Halaman form ditumpuk di atas Home dan Home tidak dibuang, jadi pengguna masih bisa kembali dengan tombol back (`pop()`). Pada drawer, opsi Home memanggil `Navigator.pushReplacement()` ke MyHomePage, sehingga halaman yang sedang tampil diganti dengan halaman utama dan dihapus dari stack. Dengan begitu pengguna kembali ke Home tanpa menumpuk halaman setiap berpindah lewat drawer.

### 2. Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.

`Scaffold` berfungsi sebagai kerangka dasar halaman dengan slot yang tetap: `AppBar` di bagian atas untuk judul halaman, `Drawer` di sisi kiri untuk menu navigasi, dan body untuk isi halaman. Karena setiap halaman (Home, form Proyek, form Pendidikan) memakai susunan yang sama dan hanya mengganti isi body, posisi judul, tombol menu, dan navigasinya selalu konsisten. LeftDrawer juga dibuat sebagai widget terpisah sehingga cukup ditulis sekali dan dipakai ulang di semua halaman, jadi pengguna tidak perlu belajar ulang tata letak setiap berpindah halaman.

Contoh penggunaan warna tema portofolio: warna indigo yang didefinisikan sebagai `seedColor` di `main.dart` dipakai pada `AppBar` halaman Home (lewat `Theme.of(context).colorScheme.primary`) dan juga pada `AppBar` serta tombol Simpan di halaman form Proyek (`Colors.indigo`). Dengan begitu identitas visual aplikasi tetap seragam di lebih dari satu halaman.

### 3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.
Formulir disusun secara vertikal menggunakan `Column` karena urutan baca dari atas ke bawah terasa natural bagi pengguna. Setiap field punya label yang jelas sehingga pengguna lebih mudah memahami data apa yang harus diisi dan tidak mudah bingung. Setiap field dibungkus `Padding` agar ada jarak antar field dan jarak dari tepi layar, sehingga tampilan tidak menempel, lebih mudah dibaca, dan lebih mudah disentuh.

Seluruh isi form dibungkus `SingleChildScrollView` karena ruang layar terbatas, terutama saat keyboard muncul dan area tampilan menyusut. Dengan widget ini, konten tetap bisa digeser sehingga semua field dan tombol Simpan tetap terjangkau. Tanpa `SingleChildScrollView`, field di bagian bawah bisa tertutup keyboard sehingga pengguna tidak bisa melihat apa yang diketik, dan Flutter dapat menampilkan error overflow karena konten lebih tinggi dari ruang yang tersedia. Jadi `Padding` mengatur kelegaan tata letak, sedangkan `SingleChildScrollView` memastikan seluruh konten tetap dapat dijangkau di layar kecil.

### 4. Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.
`GlobalKey<FormState>` dipasang pada widget Form sebagai penghubung, sehingga tombol Simpan yang berada di luar field dapat mengakses state form melalui `_formKey`.`currentState` dan memanggil `validate()`. `validator` adalah fungsi pada setiap field yang memeriksa isi input dan mengembalikan `null` jika valid atau teks pesan error jika tidak valid. Saat tombol Simpan ditekan, `validate()` menjalankan semua `validator`, menampilkan pesan `error` pada field yang gagal, dan mengembalikan `true` hanya jika semua field lolos. Karena itu dialog sukses hanya muncul jika `validate()` bernilai `true`.

Contoh nilai yang ditolak adalah Nama Proyek yang dikosongkan atau hanya berisi spasi (" "), karena validator memeriksa isi dengan `trim()` sehingga muncul pesan "Nama proyek tidak boleh kosong".

Memilih jenis input atau papan ketik saja belum cukup karena keyboard hanya mempermudah pengguna mengetik jenis data tertentu, misalnya keyboard angka, tetapi tidak membatasi isi yang diterima. Keyboard tidak dapat memaksa field wajib diisi, tidak dapat memeriksa apakah nilainya masuk akal (misalnya IPK 9.5), dan tidak dapat mencegah input dari paste atau keyboard fisik. `Validator` yang benar-benar menolak data yang tidak sesuai sebelum data diproses.

## AI Disclosure
Dalam pengerjaan tugas ini, saya menggunakan Claude (free plan) sebagai alat bantu saya untuk membantu saya men debug kode saya yg terjadi error, lalu brainstorming dan menjelaskan konsep terkait pertanyaan dan membantu saya dalam merapikan susunan kalimat jawaban saya, pemahaman akhir, pengecekan terhadap kode saya sendiri, dan keputusan isi jawaban tetap saya lakukan sendiri. Berikut adalah link claude yg saya gunakan:
`https://claude.ai/share/e56aedc0-a1a4-402d-90f9-7dcd306970b8`