class Modul {
  final String id;
  final String title;
  final String subtitle;
  final String imageAsset;
  final bool isLocked;
  final bool isCompleted;
  final List<Materi> materiList;
  final List<Quiz> quizList;

  Modul({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    this.isLocked = true,
    this.isCompleted = false,
    required this.materiList,
    required this.quizList,
  });

  Modul copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageAsset,
    bool? isLocked,
    bool? isCompleted,
    List<Materi>? materiList,
    List<Quiz>? quizList,
  }) {
    return Modul(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageAsset: imageAsset ?? this.imageAsset,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      materiList: materiList ?? this.materiList,
      quizList: quizList ?? this.quizList,
    );
  }
}

class Materi {
  final String title;
  final String content;
  final String imageAsset;

  Materi({
    required this.title,
    required this.content,
    this.imageAsset = 'assets/images/materi_placeholder.png',
  });
}

class Quiz {
  final String question;
  final List<String> options;
  final int correctIndex;

  Quiz({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

final List<Modul> dummyModulList = [
  Modul(
    id: '1',
    title: 'Aku dan Tubuhku',
    subtitle: 'Mengenal anggota tubuh dan fungsinya',
    imageAsset: 'assets/images/island_1.png',
    isLocked: false,
    isCompleted: false,
    materiList: [
      Materi(
        title: 'Anggota Tubuhku',
        content:
            'Tubuh kita terdiri dari berbagai anggota tubuh yang memiliki fungsi masing-masing. Kepala untuk berpikir, mata untuk melihat, telinga untuk mendengar, hidung untuk mencium, mulut untuk berbicara dan makan. Tangan untuk memegang dan kaki untuk berjalan. Setiap anggota tubuh kita sangat berharga dan harus dijaga kesehatannya.',
      ),
      Materi(
        title: 'Merawat Tubuhku',
        content:
            'Merawat tubuh sangat penting agar kita tetap sehat. Mandi dua kali sehari, menggosok gigi setelah makan, keramas secara teratur, memotong kuku, dan mencuci tangan sebelum makan adalah cara merawat tubuh. Tubuh yang bersih membuat kita percaya diri dan terhindar dari penyakit.',
      ),
    ],
    quizList: [
      Quiz(
        question: 'Apa fungsi dari mata?',
        options: ['Untuk mendengar', 'Untuk melihat', 'Untuk mencium', 'Untuk berbicara'],
        correctIndex: 1,
      ),
      Quiz(
        question: 'Berapa kali sebaiknya kita mandi dalam sehari?',
        options: ['Satu kali', 'Dua kali', 'Tiga kali', 'Empat kali'],
        correctIndex: 1,
      ),
      Quiz(
        question: 'Bagian tubuh yang digunakan untuk memegang adalah...',
        options: ['Kaki', 'Kepala', 'Tangan', 'Hidung'],
        correctIndex: 2,
      ),
    ],
  ),
  Modul(
    id: '2',
    title: 'Tubuhku Bersih Tubuhku Sehat',
    subtitle: 'Belajar menjaga kebersihan diri',
    imageAsset: 'assets/images/island_2.png',
    isLocked: true,
    isCompleted: false,
    materiList: [],
    quizList: [],
  ),
  Modul(
    id: '3',
    title: 'Aku Bertumbuh',
    subtitle: 'Memahami perubahan saat bertumbuh',
    imageAsset: 'assets/images/island_3.png',
    isLocked: true,
    isCompleted: false,
    materiList: [],
    quizList: [],
  ),
  Modul(
    id: '4',
    title: 'Aku Bisa Melindungi Diriku',
    subtitle: 'Belajar menjaga diri dari hal berbahaya',
    imageAsset: 'assets/images/island_4.png',
    isLocked: true,
    isCompleted: false,
    materiList: [],
    quizList: [],
  ),
];
