class AppConstants {
  static const String name = "Sourav K K";
  static const String role = "Mobile App Developer";
  static const String summary =
      "Specialized in crafting premium mobile experiences with Flutter. "
      "Focused on building pixel-perfect, performant Android and iOS apps with Clean Architecture. "
      "Also experienced in bringing mobile-quality UX to Web and Desktop platforms.";

  static const String aboutDescription =
      "Flutter Developer with 4+ years of hands-on experience in building scalable, responsive mobile "
      "applications, with additional experience in web and desktop platforms. Proficient in state "
      "management using Bloc, Riverpod, Provider, and GetX to manage complex application states.\n\n"
      "Experienced in developing Flutter desktop applications (Windows) from scratch to production, "
      "including build generation and installer creation. Skilled in REST API integration, third-party "
      "packages, and backend services using Firebase and Google Cloud Platform, including "
      "authentication, Firestore, Realtime Database, and SQL databases.\n\n"
      "Experienced in integrating payment gateways such as Razorpay, PayTabs, and Telr. Strong focus "
      "on clean architecture, performance optimization, and delivering high-quality user experiences.";

  static const String cvUrl = "#"; // Placeholder
  static const String email =
      "souravkk2021@gmail.com"; // Placeholder based on name
  static const String phone = "+91 8921477978"; // Placeholder
  static const String githubUrl = "https://github.com/SouravSouru";
  static const String linkedinUrl = "https://www.linkedin.com/in/sourav-kk/";

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
      company: "Viewy Digital Pvt.Ltd",
      role: "Senior Flutter Developer",
      period: "2023 - Present",
      description:
          "Led end-to-end development, maintenance, and deployment of multiple applications across mobile, web, and desktop platforms.\n\n"
          "• Developed a Flutter-based desktop application for a Laundry POS system, supporting billing, order management, and service workflows.\n"
          "• Developed QuickAMC, an AMC (Annual Maintenance Contract) service application, along with church management applications.\n"
          "• Delivered and maintained applications including AnyRental and Swiss Auto, supporting business and operational workflows.\n"
          "• Implemented Clean Architecture and MVVM to improve scalability and maintainability.\n"
          "• Utilized Bloc, Riverpod, Provider, and GetX for efficient state management.\n"
          "• Integrated REST APIs, Firebase Authentication, and real-time databases.\n"
          "• Implemented payment gateway integrations and optimized application performance.\n"
          "• Followed Agile methodologies to ensure timely and high-quality releases.",
    ),
    ExperienceItem(
      company: "Futura Labs Technologies",
      role: "Flutter Developer",
      period: "2022 - 2023",
      description:
          "Worked on mobile and web application development using Flutter and Dart.\n"
          "• Recognized as Best Performer of the Month for outstanding contribution.\n"
          "• Created RESTful APIs in Dart using the Shelf framework.\n"
          "• Utilized Firebase for user authentication, data storage, and Cloud Functions.\n"
          "• Performed API integration with backend services.\n"
          "• Mentored interns, guiding them on best practices and clean coding standards.",
    ),
    ExperienceItem(
      company: "Airo Global Software Inc",
      role: "Junior Flutter Developer",
      period: "2020 - 2022",
      description:
          "Developed and maintained mobile applications using Flutter and Dart programming language.\n"
          "• Implemented REST API integrations and third-party libraries.\n"
          "• Collaborated with designers to implement user interface designs.\n"
          "• Updated existing apps, fixed bugs and added new features.",
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: "Royal Swiss Auto Services",
      description:
          "Royal Swiss Auto is an easy-to-use app that acts as a bridge between the customers and the service provider to provide hassle-free vehicle maintenance for customers across the UAE. Many luxury car owners would feel this application makes the service or repair appointment easier by just clicking at the one end.",
      techStack: ["Flutter", "Bloc", "Firebase"],
      link: "#",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.royalswissapp.swiss&hl=en_IN",
      iosLink:
          "https://apps.apple.com/vn/app/royal-swiss-auto-services/id6479524737",
      iconUrl:
          "https://play-lh.googleusercontent.com/xwo2uCcq8h_lidVM5HEIicDhsuv3W1PYzFBIStu84_9XpO7AkNFM3lzypLm_r_iWxhjK=w240-h480",
    ),
    ProjectItem(
      title: "Any Rentals",
      description:
          "ANY RENTALS - The ultimate rental marketplace app. Find and book vehicles, planes, event equipment, and more—all in one place. Thousands of listings, best prices, fast search. Your rental solution made simple",
      techStack: ["Flutter", "Riverpod", "REST API"],
      link: "#",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.viewydigital.any_rentals&hl=en_IN",
      iconUrl:
          "https://play-lh.googleusercontent.com/j5-nq3En-aFPwSwMboB4_vUvxVhFAShQlUOtXOdOCd78L9BwyhQ6D7bRjUO4fTUBCFE=w1024-h1024",
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
  final String? androidLink;
  final String? iosLink;
  final String? iconUrl;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.techStack,
    required this.link,
    this.androidLink,
    this.iosLink,
    this.iconUrl,
  });
}
