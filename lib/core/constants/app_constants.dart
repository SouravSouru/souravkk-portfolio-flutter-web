class AppConstants {
  static const String name = "Yoush KK";
  static const String role = "Mobile App Developer";
  static const String summary =
      "Specialized in crafting premium mobile experiences with Flutter. "
      "Focused on building pixel-perfect, performant Android and iOS apps with Clean Architecture. "
      "Also experienced in bringing mobile-quality UX to Web and Desktop platforms.";

  static const String cvUrl = "#"; // Placeholder
  static const String email =
      "contact@youshkk.com"; // Placeholder based on name
  static const String phone = "+1234567890"; // Placeholder
  static const String githubUrl = "https://github.com/youshkk";
  static const String linkedinUrl = "https://linkedin.com/in/youshkk";

  static const List<String> primarySkills = [
    "Flutter",
    "Dart",
    "Clean Architecture",
    "Bloc",
    "Riverpod",
    "Firebase",
    "REST APIs",
    "Android",
    "iOS",
    "Web",
    "Windows",
  ];

  static const List<ExperienceItem> experience = [
    ExperienceItem(
      company: "Airo Global Software Inc",
      role: "Senior Flutter Developer",
      period: "2024 - Present", // Assuming reverse chronological
      description:
          "Leading the mobile development team, architectural planning, and code reviews.",
    ),
    ExperienceItem(
      company: "Futura Technologies",
      role: "Flutter Developer",
      period: "2022 - 2024",
      description:
          "Developed and maintained multiple cross-platform applications for diverse clients.",
    ),
    ExperienceItem(
      company: "Digital Pvt. Ltd",
      role: "Junior Flutter Developer",
      period: "2020 - 2022",
      description:
          "Started journey with Flutter, contributed to UI implementation and bug fixes.",
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: "Royal Swiss Auto Services",
      description: "A premium auto service booking and management application.",
      techStack: ["Flutter", "Bloc", "Firebase"],
      link: "#",
    ),
    ProjectItem(
      title: "Any Rentals",
      description: "Rental marketplace for equipment and properties.",
      techStack: ["Flutter", "Riverpod", "REST API"],
      link: "#",
    ),
    ProjectItem(
      title: "MIJSOC Dubai",
      description: "Community management app for MIJSOC.",
      techStack: ["Flutter", "Firebase", "Notifications"],
      link: "#",
    ),
    ProjectItem(
      title: "STGJSC Al Ain",
      description: "Sports club management and event booking.",
      techStack: ["Flutter", "Provider", "Maps"],
      link: "#",
    ),
    ProjectItem(
      title: "EWFS, WHT, CleanKaro",
      description: "Suite of service-based applications.",
      techStack: ["Flutter", "GetIt", "Dio"],
      link: "#",
    ),
  ];
}

class ExperienceItem {
  final String company;
  final String role;
  final String period;
  final String description;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
  });
}

class ProjectItem {
  final String title;
  final String description;
  final List<String> techStack;
  final String link;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.techStack,
    required this.link,
  });
}
