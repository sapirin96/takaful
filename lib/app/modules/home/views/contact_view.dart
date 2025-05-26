import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact us'.tr),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Image.asset('lib/assets/images/takaful-banner.png'),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text(
                '#116D, Russian Blvd, Sangkat Srah Chak , Khan Daun Penh Phnom Penh',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () async {
                canLaunchUrl(Uri(scheme: 'https', path: 'goo.gl/maps/7aqXtvyWJ4mteMEa7')).then((bool result) async {
                  final Uri launchUri = Uri(
                    scheme: 'https',
                    path: 'goo.gl/maps/7aqXtvyWJ4mteMEa7',
                  );
                  await launchUrl(launchUri);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(
                '+855 69 939 398',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () async {
                canLaunchUrl(Uri(scheme: 'tel', path: '+85569939398')).then((bool result) async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '+85569939398',
                  );
                  await launchUrl(launchUri);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: const Text(
                'info@takafulcambodia.org',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () async {
                canLaunchUrl(Uri(scheme: 'mailto', path: 'info@takafulcambodia.org')).then((bool result) async {
                  final Uri launchUri = Uri(
                    scheme: 'mailto',
                    path: 'info@takafulcambodia.org',
                  );
                  await launchUrl(launchUri);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.web),
              title: const Text(
                'https://www.takafulcambodia.org',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () async {
                canLaunchUrl(Uri(scheme: 'https', path: 'www.takafulcambodia.org')).then((bool result) async {
                  final Uri launchUri = Uri(
                    scheme: 'https',
                    path: 'www.takafulcambodia.org',
                  );
                  await launchUrl(launchUri);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
