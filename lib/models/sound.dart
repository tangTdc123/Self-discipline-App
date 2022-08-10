class Sound {
  String soundKey;
  String soundName;
  String soundPath;

  Sound(
      {required this.soundKey,
      required this.soundName,
      required this.soundPath});

  Sound clone() {
    return Sound(
        soundKey: this.soundKey,
        soundName: this.soundName,
        soundPath: this.soundPath);
  }
}
