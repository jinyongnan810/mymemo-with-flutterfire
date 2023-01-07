typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String string);

class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  LoadingScreenController({required this.close, required this.update});
}
