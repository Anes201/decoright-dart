import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../controllers/support_controller.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportController());
    final l10n = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;

    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingFAQs.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.faqs.isEmpty) {
          return const Center(child: Text('No FAQs available at the moment.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          itemCount: controller.faqs.length,
          itemBuilder: (context, index) {
            final faq = controller.faqs[index];
            
            // Multi-language support
            String question = faq['question_en'] ?? '';
            String answer = faq['answer_en'] ?? '';

            if (languageCode == 'ar') {
              question = faq['question_ar'] ?? question;
              answer = faq['answer_ar'] ?? answer;
            } else if (languageCode == 'fr') {
              question = faq['question_fr'] ?? question;
              answer = faq['answer_fr'] ?? answer;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
              elevation: 0,
              color: isDark ? TColors.darkGrey : TColors.lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? TColors.darkerGrey : Colors.grey.withOpacity(0.2)),
              ),
              child: ExpansionTile(
                title: Text(
                  question,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.light : TColors.dark,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      answer,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
