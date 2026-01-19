import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDrawer extends StatelessWidget {
  final Function(int) onNavTap;

  const MobileDrawer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Center(
              child: Text(
                "<SouravKK />",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context); // Close drawer
              onNavTap(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("About"),
            onTap: () {
              Navigator.pop(context);
              onNavTap(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text("Skills"),
            onTap: () {
              Navigator.pop(context);
              onNavTap(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text("Experience"),
            onTap: () {
              Navigator.pop(context);
              onNavTap(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text("Projects"),
            onTap: () {
              Navigator.pop(context);
              onNavTap(4);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text("Contact"),
            onTap: () {
              Navigator.pop(context);
              onNavTap(5);
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Resume"),
            onTap: () async {
              Navigator.pop(context);
              final Uri url = Uri.parse(AppConstants.cvUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
