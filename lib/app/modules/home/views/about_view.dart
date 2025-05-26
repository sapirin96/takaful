import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'.tr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Image.asset('lib/assets/images/about-banner.png'),
            const SizedBox(height: 20),
            Text(
              'ប្រវត្តិរបស់អង្គភាព',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'ចុះបញ្ជីទទួលស្គាល់ដោយក្រសួងមហាផ្ទៃតាមរយៈលិខិតលេខ ២៦០ស.ជ.ណ ចុះថ្ងៃទី២០ ខែធ្នូ ឆ្នាំ ២០២២ និងដឹកនាំដំណើរការដោយ ឯកឧត្តមឧកញ៉ា ដាតុបណ្ឌិត អូស្មាន ហាស្សាន់ ទេសរដ្ឋមន្រ្តីទទួលបន្ទុកកិច្ចការងារឥស្លាមកម្ពុជា។',
              style: Get.textTheme.titleMedium,
            ),
            Text(
              'ទស្សនៈវិស័យ',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'CATA ចង់ឃើញសហគមន៍ឥស្លាមនៅកម្ពុជា មានសមត្ថភាពខ្ពស់ ទាំងចំណេះដឹង ការអភិវឌ្ឍន៍លើគ្រប់ វិស័យ រស់នៅប្រកបដោយសេចក្តីថ្លៃថ្នូរ និងជីវភាពរស់នៅកាន់តែប្រសើរ។',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              'បេសកកម្ម',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'សហការជាមួយថ្នាក់ដឹកនាំគ្រប់លំដាប់ថ្នាក់ក្នុងសហគមន៍ឥស្លាមកម្ពុជា ដើម្បីផ្សព្វផ្សាយកម្មវិធី Takaful ឱ្យមានប្រសិទ្ធភាពខ្ពស់ និងផ្តល់ផលប្រយោជន៍ទៅវិញទៅមក, ជម្រុញ និងលើកកម្ពស់ការអភិវឌ្ឍន៍លើចំណេះដឹង, ជំនាញវិជ្ជាជីវៈ និងឱកាសការងារសម្រាប់យុវជនឥស្លាមកម្ពុជា។',
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
