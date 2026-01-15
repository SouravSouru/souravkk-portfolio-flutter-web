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
                  onTap: () {},
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: project.iconUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
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
                        .take(3)
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("View"),
                ),
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
                    ? Image.network(
                        iconUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
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
