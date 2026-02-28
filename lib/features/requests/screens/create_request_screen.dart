import 'package:decoright/features/requests/controllers/request_controller.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import 'package:decoright/l10n/app_localizations.dart';

class CreateRequestScreen extends StatelessWidget {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestController>();
    final isDark = THelperFunctions.isDarkMode(context);

    final i18n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.light,
      appBar: AppBar(
        title: Text(i18n.requestAService),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// 1. Service & Space Selection Card
            _buildSectionCard(
              context,
              title: i18n.projectBasics,
              isDark: isDark,
              child: Column(
                children: [
                  _buildDropdown(
                    label: i18n.serviceType,
                    value: controller.selectedServiceTypeId,
                    items: controller.serviceTypes,
                    icon: Iconsax.category,
                    hint: i18n.selectServiceType,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  _buildDropdown(
                    label: i18n.spaceType,
                    value: controller.selectedSpaceTypeId,
                    items: controller.spaceTypes,
                    icon: Iconsax.house,
                    hint: i18n.selectSpaceType,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 2. Dimensions & Location Card
            _buildSectionCard(
              context,
              title: i18n.locationAndDimensions,
              isDark: isDark,
              child: Column(
                children: [
                   _buildTextField(
                    label: i18n.location,
                    controller: controller.locationController,
                    hint: i18n.enterLocation,
                    icon: Iconsax.location,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: i18n.width,
                          controller: controller.widthController,
                          hint: '0.0',
                          icon: Iconsax.maximize,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                        child: _buildTextField(
                          label: i18n.height,
                          controller: controller.heightController,
                          hint: '0.0',
                          icon: Iconsax.maximize,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 3. Details & Duration Card
            _buildSectionCard(
              context,
              title: i18n.requestDetails,
              isDark: isDark,
              child: Column(
                children: [
                  _buildTextField(
                    label: i18n.descriptionRequirements,
                    controller: controller.descriptionController,
                    hint: i18n.describeRequirements,
                    maxLines: 4,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  _buildTextField(
                    label: i18n.requestedDuration,
                    controller: controller.durationController,
                    hint: i18n.optionalDays,
                    icon: Iconsax.clock,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 4. Attachments Card
            _buildSectionCard(
              context,
              title: i18n.attachments,
              isDark: isDark,
              trailing: IconButton(
                onPressed: controller.pickFiles,
                icon: const Icon(Iconsax.add_square, color: TColors.primary),
              ),
              child: Obx(() {
                if (controller.selectedFiles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                      child: Text(
                        i18n.noFilesAttached,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.selectedFiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (context, index) {
                    final file = controller.selectedFiles[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: isDark ? TColors.darkerGrey : TColors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? TColors.darkGrey : TColors.grey),
                      ),
                      child: ListTile(
                        leading: const Icon(Iconsax.document, color: TColors.primary),
                        title: Text(
                          file.path.split('/').last,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.red, size: 20),
                          onPressed: () => controller.removeFile(file),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.createRequest(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: TColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(i18n.submitRequest, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child, required bool isDark, Widget? trailing}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? TColors.darkGrey : TColors.grey.withValues(alpha: 0.3)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxnString value,
    required List<Map<String, dynamic>> items,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            isExpanded: true,
            value: value.value,
            items: items
                .map((item) {
                  final locale = Get.locale?.languageCode ?? 'en';
                  final displayName = item['display_name_$locale'] ?? item['display_name_en'] ?? item['name'];
                  return DropdownMenuItem(
                    value: item['id'] as String,
                    child: Text(
                      displayName.toString().replaceAll('_', ' '),
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                })
                .toList(),
            onChanged: (val) => value.value = val,
          ),
        ),
      ],
    );
  }
}
