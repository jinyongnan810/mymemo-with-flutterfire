enum LottieAnimation {
  loading(name: 'loading');

  final String name;
  const LottieAnimation({required this.name});
}

extension GetFullPath on LottieAnimation {
  String fullPath() => 'assets/animations/$name.json';
}
