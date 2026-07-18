class ProjectModel {
  final int id;
  final String name;
  final String district;
  final String authority;
  final String contractor;
  final double budget;
  final double length;
  final int progress;
  final String status;
  final String startDate;
  final String endDate;
  final List<String> materials;

  ProjectModel({
    required this.id,
    required this.name,
    required this.district,
    required this.authority,
    required this.contractor,
    required this.budget,
    required this.length,
    required this.progress,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.materials,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      district: json["district"],
      authority: json["authority"],
      contractor: json["contractor"],
      budget: (json["budget"] as num).toDouble(),
      length: (json["length"] as num).toDouble(),
      progress: json["progress"],
      status: json["status"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      materials: List<String>.from(json["materials"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "district": district,
      "authority": authority,
      "contractor": contractor,
      "budget": budget,
      "length": length,
      "progress": progress,
      "status": status,
      "startDate": startDate,
      "endDate": endDate,
      "materials": materials,
    };
  }
}