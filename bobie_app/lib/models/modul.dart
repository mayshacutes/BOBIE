class Level {
  final int number;
  final String title;
  final String description;
  bool isUnlocked;
  bool isCompleted;
  int stars;

  Level({
    required this.number,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.stars = 0,
  });

  Level copyWith({
    int? number, String? title, String? description,
    bool? isUnlocked, bool? isCompleted, int? stars,
  }) {
    return Level(
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      stars: stars ?? this.stars,
    );
  }
}

final List<List<LevelData>> sectionLevels = [
  [
    LevelData('Halo, Tubuhku!', 'Kenali anggota tubuh dengan mengetuk dan mencocokkan'),
    LevelData('Semua Bagian Punya Fungsi', 'Cocokkan organ tubuh dengan fungsinya'),
    LevelData('Tubuhku Berharga', 'Pilih kegiatan baik dan buruk untuk tubuh'),
    LevelData('Area Pribadi', 'Kenali bagian tubuh yang bersifat pribadi'),
    LevelData('Siapa yang Boleh Membantu?', 'Sortir siapa yang boleh membantu'),
    LevelData('Sentuhan Aman & Tidak Aman', 'Belajar membedakan sentuhan lewat cerita'),
    LevelData('Sentuhan Tidak Aman', 'Kenali contoh sentuhan tidak aman'),
    LevelData('Berani Berkata Tidak', 'Latih keberanian menolak dengan suara'),
    LevelData('Meminta Bantuan', 'Pilih orang tepercaya untuk dimintai bantuan'),
    LevelData('Selalu Waspada', 'Sortir situasi aman dan berbahaya'),
  ],
  [
    LevelData('Mandi Itu Menyenangkan', 'Belajar urutan mandi yang benar'),
    LevelData('Jangan Lupa Cuci Tangan', 'Langkah mencuci tangan yang bersih'),
    LevelData('Pakai Baju Bersih', 'Pilih pakaian yang layak dan bersih'),
    LevelData('Istirahat Itu Penting', 'Bandingkan efek tidur cukup vs kurang'),
    LevelData('Setelah Buang Air', 'Urutkan langkah membersihkan diri'),
    LevelData('Ganti Pakaian Dalam', 'Keputusan tepat setelah basah atau berkeringat'),
    LevelData('Kalau Terasa Tidak Nyaman', 'Ceritakan rasa tidak nyaman ke orang tua'),
    LevelData('Siapa yang Boleh Membantu', 'Sortir siapa yang boleh bantu kebersihan'),
    LevelData('Tubuhku Milikku', 'Jaga kebersihan area pribadi secara mandiri'),
    LevelData('Misi Tubuh Bersih', 'Pilih barang kebersihan yang wajib dibawa'),
  ],
  [
    LevelData('Semua Orang Bertumbuh', 'Drag makanan untuk melihat tahap pertumbuhan'),
    LevelData('Tubuhku Mulai Berubah', 'Cocokkan ukuran dengan tahap usia'),
    LevelData('Perasaan Juga Berubah', 'Pilih ekspresi yang sesuai dengan cerita'),
    LevelData('Perawatan Ekstra', 'Pilih barang perawatan tubuh saat pubertas'),
    LevelData('Halo Pubertas!', 'Pelajari perubahan fisik saat pubertas'),
    LevelData('Lanjutan Pubertas', 'Urutkan langkah perawatan saat pubertas'),
    LevelData('Higienitas Saat Puber', 'Sortir kebiasaan higienis saat pubertas'),
    LevelData('Info Valid vs Aneh', 'Pilih sumber informasi tepercaya'),
    LevelData('Body Positivity', 'Tap kalimat positif tentang tubuhmu'),
    LevelData('Aku Bangga pada Diriku', 'Rekam afirmasi positif tentang diri sendiri'),
  ],
  [
    LevelData('Perasaan Aman & Tidak', 'Latih gut feeling terhadap situasi sekitar'),
    LevelData('Sentuhan Kontekstual', 'Sortir sentuhan wajar vs berbahaya'),
    LevelData('Rahasia Baik & Buruk', 'Bedakan rahasia yang aman dan berbahaya'),
    LevelData('Berani Tolak (Roleplay)', 'Latih keberanian menolak lewat skenario'),
    LevelData('Pergi Menjauh', 'Pilih tindakan benar saat merasa terancam'),
    LevelData('Cerita ke Orang Dewasa', 'Reaksi cepat memilih orang tepercaya'),
    LevelData('Jangan Mudah Percaya', 'Sortir hadiah tulus vs hadiah mencurigakan'),
    LevelData('Aman di Dunia Digital', 'Tangkal pesan berbahaya di HP'),
    LevelData('Privasi Digitalku', 'Sortir info yang boleh dan tidak boleh dikirim'),
    LevelData('Siap Melindungi Diri', 'Quiz recap seluruh materi perlindungan diri'),
  ],
];

class LevelData {
  final String title;
  final String description;
  const LevelData(this.title, this.description);
}

List<Level> generateLevels(int sectionIndex, int startUnlocked) {
  final data = sectionLevels[sectionIndex];
  return List.generate(10, (i) {
    final n = i + 1;
    return Level(
      number: n, title: data[i].title, description: data[i].description,
      isUnlocked: n <= startUnlocked, isCompleted: n < startUnlocked,
      stars: n < startUnlocked ? 3 : 0,
    );
  });
}

class Modul {
  final String id, title, subtitle, imageAsset;
  final bool isLocked, isCompleted;
  final List<Materi> materiList;
  final List<Quiz> quizList;
  final List<Level> levels;
  final int sectionIndex;

  Modul({
    required this.id, required this.title, required this.subtitle,
    required this.imageAsset, this.isLocked = true, this.isCompleted = false,
    required this.materiList, required this.quizList,
    this.sectionIndex = 0, List<Level>? levels,
  }) : levels = levels ?? generateLevels(sectionIndex, isLocked ? 0 : 1);

  Modul copyWith({
    String? id, String? title, String? subtitle, String? imageAsset,
    bool? isLocked, bool? isCompleted,
    List<Materi>? materiList, List<Quiz>? quizList,
    List<Level>? levels, int? sectionIndex,
  }) {
    return Modul(
      id: id ?? this.id, title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle, imageAsset: imageAsset ?? this.imageAsset,
      isLocked: isLocked ?? this.isLocked, isCompleted: isCompleted ?? this.isCompleted,
      materiList: materiList ?? this.materiList, quizList: quizList ?? this.quizList,
      levels: levels ?? this.levels, sectionIndex: sectionIndex ?? this.sectionIndex,
    );
  }
}

class Materi {
  final String title, content, imageAsset, emoji;
  Materi({required this.title, required this.content, this.imageAsset = 'assets/images/materi_placeholder.png', this.emoji = '\u{2022}'});
}

class Quiz {
  final String question;
  final List<String> options;
  final int correctIndex;
  Quiz({required this.question, required this.options, required this.correctIndex});
}

final List<Modul> dummyModulList = [
  Modul(id: '1', title: 'Aku dan Tubuhku', subtitle: 'Mengenal anggota tubuh dan fungsinya', imageAsset: 'assets/images/island_1.png', isLocked: false, isCompleted: false, sectionIndex: 0,
    materiList: [
      Materi(title: 'Area Pribadi', content: 'Area pribadi adalah bagian tubuh yang tidak boleh disentuh atau dilihat oleh orang lain, kecuali orang tua atau dokter saat keperluan medis.', emoji: '\u{1FA71}'),
      Materi(title: 'Sentuhan Aman', content: 'Sentuhan aman adalah sentuhan yang membuat kita merasa nyaman. Sentuhan tidak aman adalah sentuhan yang membuat kita merasa takut, sakit, atau tidak nyaman.', emoji: '\u{1F91D}'),
      Materi(title: 'Perlindungan Diri', content: 'Perlindungan diri adalah kemampuan untuk menjaga keselamatan diri sendiri, termasuk berani berkata tidak dan mencari bantuan.', emoji: '\u{1F6E1}\u{FE0F}'),
    ],
    quizList: [
      Quiz(question: 'Apa yang dimaksud dengan area pribadi?', options: ['Area bermain', 'Bagian tubuh yang tidak boleh disentuh orang lain', 'Ruang tamu', 'Halaman sekolah'], correctIndex: 1),
      Quiz(question: 'Siapa yang boleh menyentuh area pribadi?', options: ['Teman sekelas', 'Tetangga', 'Orang tua atau dokter saat keperluan medis', 'Guru'], correctIndex: 2),
      Quiz(question: 'Apa yang harus dilakukan jika ada sentuhan tidak nyaman?', options: ['Diam saja', 'Berkata TIDAK dan mencari bantuan', 'Tersenyum', 'Pura-pura tidak tahu'], correctIndex: 1),
    ],
  ),
  Modul(id: '2', title: 'Tubuhku Bersih Tubuhku Sehat', subtitle: 'Belajar menjaga kebersihan diri', imageAsset: 'assets/images/island_2.png', isLocked: true, isCompleted: false, sectionIndex: 1,
    materiList: [
      Materi(title: 'Hidup Sehat', content: 'Hidup sehat dimulai dari kebiasaan sehari-hari. Makan makanan bergizi, minum air putih cukup, istirahat cukup, dan olahraga teratur.', emoji: '\u{1F33F}'),
      Materi(title: 'Perawatan Tubuh', content: 'Merawat tubuh meliputi mandi dua kali sehari, menggosok gigi, keramas, memotong kuku, dan memakai pakaian bersih.', emoji: '\u{1F9FC}'),
      Materi(title: 'Tubuh Nyaman', content: 'Tubuh yang nyaman adalah tubuh yang bersih, sehat, dan terawat. Jaga selalu kebersihan dan kesehatan tubuhmu!', emoji: '\u{1F499}'),
    ],
    quizList: [
      Quiz(question: 'Berapa kali sebaiknya mandi dalam sehari?', options: ['Satu kali', 'Dua kali', 'Tiga kali', 'Empat kali'], correctIndex: 1),
      Quiz(question: 'Apa yang termasuk makanan bergizi?', options: ['Keripik dan permen', 'Sayur dan buah', 'Mi instan', 'Minuman bersoda'], correctIndex: 1),
      Quiz(question: 'Kapan waktu yang tepat mencuci tangan?', options: ['Setelah bangun tidur saja', 'Sebelum makan dan setelah ke toilet', 'Saat tangan terlihat kotor', 'Seminggu sekali'], correctIndex: 1),
    ],
  ),
  Modul(id: '3', title: 'Aku Bertumbuh', subtitle: 'Memahami perubahan saat bertumbuh', imageAsset: 'assets/images/island_3.png', isLocked: true, isCompleted: false, sectionIndex: 2,
    materiList: [
      Materi(title: 'Masa Pubertas', content: 'Masa pubertas adalah masa ketika tubuh anak-anak mulai berubah menjadi tubuh dewasa. Ini adalah proses alami.', emoji: '\u{1F338}'),
      Materi(title: 'Kebersihan Pubertas', content: 'Saat pubertas, menjaga kebersihan tubuh semakin penting. Keringat dan perubahan hormon membuat tubuh perlu dibersihkan lebih sering.', emoji: '\u{1F6BF}'),
      Materi(title: 'Percaya Diri', content: 'Perubahan saat pubertas adalah wajar. Tetaplah percaya diri, jaga kebersihan, dan jangan ragu bertanya pada orang tua atau guru.', emoji: '\u{2728}'),
    ],
    quizList: [
      Quiz(question: 'Apa yang dimaksud dengan masa pubertas?', options: ['Masa berhenti tumbuh', 'Masa peralihan anak-anak ke dewasa', 'Masa tua', 'Masa sakit'], correctIndex: 1),
      Quiz(question: 'Apa yang perlu dilakukan lebih sering saat pubertas?', options: ['Tidur lebih lama', 'Menjaga kebersihan tubuh', 'Makan lebih banyak', 'Bermain lebih sering'], correctIndex: 1),
      Quiz(question: 'Sikap tepat terhadap perubahan tubuh saat pubertas?', options: ['Malu', 'Percaya diri dan bertanya jika perlu', 'Marah', 'Acuh'], correctIndex: 1),
    ],
  ),
  Modul(id: '4', title: 'Aku Bisa Melindungi Diriku', subtitle: 'Belajar menjaga diri dari hal berbahaya', imageAsset: 'assets/images/island_4.png', isLocked: true, isCompleted: false, sectionIndex: 3,
    materiList: [
      Materi(title: 'Rahasia Baik & Buruk', content: 'Rahasia baik membuat kita senang. Rahasia buruk membuat kita takut. Rahasia buruk harus diceritakan ke orang tua atau guru.', emoji: '\u{1F910}'),
      Materi(title: 'Berani Menolak', content: 'Kita berhak menolak ajakan yang membuat tidak nyaman. Belajar berkata TIDAK dengan tegas adalah keterampilan penting.', emoji: '\u{1F645}'),
      Materi(title: 'Aman di Digital', content: 'Jangan bagikan data pribadi di internet. Jika ada yang membuat tidak nyaman online, blokir dan laporkan ke orang tua.', emoji: '\u{1F4F1}'),
    ],
    quizList: [
      Quiz(question: 'Apa yang dimaksud rahasia buruk?', options: ['Kejutan ulang tahun', 'Rahasia yang membuat takut', 'Rencana liburan', 'Hadiah spesial'], correctIndex: 1),
      Quiz(question: 'Apa yang harus dilakukan jika ada rahasia buruk?', options: ['Menyimpan sendiri', 'Cerita ke orang tua/guru', 'Menulis di buku', 'Melupakan'], correctIndex: 1),
      Quiz(question: 'Info apa yang TIDAK boleh dibagikan di internet?', options: ['Hobi', 'Alamat rumah', 'Film favorit', 'Makanan kesukaan'], correctIndex: 1),
    ],
  ),
];
