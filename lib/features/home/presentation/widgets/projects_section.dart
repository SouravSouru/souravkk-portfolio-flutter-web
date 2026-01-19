import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/entrance_fader.dart';
import '../../../../core/widgets/hover_scale_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.isMobile(context) ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EntranceFader(
                offset: const Offset(0, 20),
                child: Text(
                  "Featured Apps",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (isDesktop)
                EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(20, 0),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("See All"),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 2 : 1,
              childAspectRatio: isDesktop
                  ? 1.4
                  : 0.8, // Taller for mobile to fit phone
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
            ),
            itemCount: AppConstants.projects.length,
            itemBuilder: (context, index) {
              final project = AppConstants.projects[index];
              return EntranceFader(
                delay: Duration(milliseconds: 100 + (index * 100)),
                offset: const Offset(0, 50),
                child: HoverScaleCard(
                  onTap: () => _showProjectDetails(context, project),
                  child: _AppProjectCard(project: project),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppProjectCard extends StatelessWidget {
  final ProjectItem project;

  const _AppProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      elevation: 0, // Elevation handled by HoverScaleCard or minimal here
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _ProjectPhoneMockup(
                    color: theme.primaryColor,
                    iconUrl: project.iconUrl,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'project_icon_${project.title}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: project.iconUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              project.iconUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.rocket_launch,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                            ),
                          )
                        : const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.7,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => _showProjectDetails(context, project),
                        child: Text(
                          "Read More",
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (project.androidLink != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _StoreBadge(
                          icon: FontAwesomeIcons.android,
                          url: project.androidLink!,
                        ),
                      ),
                    if (project.iosLink != null)
                      _StoreBadge(
                        icon: FontAwesomeIcons.apple,
                        url: project.iosLink!,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: project.techStack
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 0,
                //     ),
                //     minimumSize: const Size(0, 36),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                //   child: const Text("View"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  final IconData icon;
  final String url;
  const _StoreBadge({required this.icon, required this.url});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

class _ProjectPhoneMockup extends StatelessWidget {
  final Color color;
  final String? iconUrl;
  const _ProjectPhoneMockup({required this.color, this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 10,
            decoration: const BoxDecoration(color: Colors.black12),
          ),

          Expanded(
            child: Container(
              color: color.withOpacity(0.1),
              child: Center(
                child: iconUrl != null
                    ? Image.asset(
                        iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.apps,
                          color: color.withOpacity(0.5),
                          size: 40,
                        ),
                      )
                    : Icon(Icons.apps, color: color.withOpacity(0.5), size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showProjectDetails(BuildContext context, ProjectItem project) {
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Project Details',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: ResponsiveLayout.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.9
                : 500,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Hero Icon
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'project_icon_${project.title}',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: project.iconUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    project.iconUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.rocket_launch,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (project.techStack.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                project.techStack.take(3).join(" • "),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          project.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Technologies",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.techStack
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 32),
                        if (project.androidLink != null ||
                            project.iosLink != null)
                          Row(
                            children: [
                              if (project.androidLink != null)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => launchUrl(
                                      Uri.parse(project.androidLink!),
                                    ),
                                    icon: const Icon(
                                      FontAwesomeIcons.googlePlay,
                                      size: 16,
                                    ),
                                    label: const Text("Play Store"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              if (project.androidLink != null &&
                                  project.iosLink != null)
                                const SizedBox(width: 16),
                              if (project.iosLink != null)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        launchUrl(Uri.parse(project.iosLink!)),
                                    icon: const Icon(
                                      FontAwesomeIcons.appStore,
                                      size: 16,
                                    ),
                                    label: const Text("App Store"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
