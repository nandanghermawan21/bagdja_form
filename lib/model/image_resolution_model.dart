class ImageResolutionModel {
  final String? code; //": "hight",
  final String? name; //": "HIGHT"

  ImageResolutionModel({
    this.code,
    this.name,
  });

  static ImageResolutionModel fromJson(Map<String, dynamic> json) {
    return ImageResolutionModel(
      code: json["code"] as String?,
      name: json["name"] as String?,
    );
  }

  Map<String, dynamic> toJsom() {
    return {
      "code": code,
      "name": name,
    };
  }

  static Future<List<ImageResolutionModel>> resolutions() {
    return Future.value().then((value) {
      return [
        ImageResolutionModel(
          code: ResolutionPresetEnum.hight,
          name: "High",
        ),
        ImageResolutionModel(
          code: ResolutionPresetEnum.medium,
          name: "Medium",
        ),
        ImageResolutionModel(
          code: ResolutionPresetEnum.low,
          name: "Low",
        ),
        ImageResolutionModel(
          code: ResolutionPresetEnum.veryhight,
          name: "Very High",
        ),
      ];
    });
  }
}

class ResolutionPresetEnum {
  static const String low = "low";
  static const String medium = "medium";
  static const String hight = "high";
  static const String veryhight = "veryhigh";
  static const String max = "max";
}
