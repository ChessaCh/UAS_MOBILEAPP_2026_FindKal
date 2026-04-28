import 'package:image_picker/image_picker.dart';

class UnggahanModel {
  final List<XFile> images;
  final int rating;
  final String namaTempat;
  final String alamat;
  final String ulasan;
  final String budget;

  const UnggahanModel({
    required this.images,
    required this.rating,
    required this.namaTempat,
    required this.alamat,
    required this.ulasan,
    required this.budget,
  });

  /// Returns true when all required fields are filled
  bool get isValid =>
      images.isNotEmpty &&
      rating > 0 &&
      namaTempat.trim().isNotEmpty &&
      alamat.trim().isNotEmpty &&
      ulasan.trim().isNotEmpty &&
      budget.isNotEmpty;

  /// Serialise to a plain map (for API / storage use)
  Map<String, dynamic> toMap() {
    return {
      'imagePaths': images.map((f) => f.path).toList(),
      'rating': rating,
      'namaTempat': namaTempat.trim(),
      'alamat': alamat.trim(),
      'ulasan': ulasan.trim(),
      'budget': budget,
    };
  }

  @override
  String toString() {
    return 'UnggahanModel('
        'images: ${images.length}, '
        'rating: $rating, '
        'namaTempat: $namaTempat, '
        'alamat: $alamat, '
        'ulasan: $ulasan, '
        'budget: $budget)';
  }
}
