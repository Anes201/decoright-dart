import 'package:decoright/features/requests/controllers/request_controller.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateRequestScreen extends StatelessWidget {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestController>();
    
    // Reset form state on new entry (optional, depends on UX pref)
    // controller.selectedServiceTypeId.value = null;
    // controller.descriptionController.clear();
    // controller.selectedFiles.clear();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Service Type Dropdown
            Text('Service Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.category),
                  hintText: 'Select Service Type',
                ),
                isExpanded: true,
                value: controller.selectedServiceTypeId.value,
                items: controller.serviceTypes
                    .map((service) => DropdownMenuItem(
                          value: service['id'] as String,
                          child: Text(
                            service['name'].toString().replaceAll('_', ' '),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (value) => controller.selectedServiceTypeId.value = value,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Space Type Dropdown
            Text('Space Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.house),
                  hintText: 'Select Space Type',
                ),
                isExpanded: true,
                value: controller.selectedSpaceTypeId.value,
                items: controller.spaceTypes
                    .map((space) => DropdownMenuItem(
                          value: space['id'] as String,
                          child: Text(
                            space['name'].toString().replaceAll('_', ' '),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (value) => controller.selectedSpaceTypeId.value = value,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Location
            Text('Location', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            TextFormField(
              controller: controller.locationController,
              decoration: const InputDecoration(
                hintText: 'Enter project location...',
                prefixIcon: Icon(Iconsax.location),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Area
            Text('Total Area (sqm)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            TextFormField(
              controller: controller.areaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter area in square meters',
                prefixIcon: Icon(Iconsax.maximize),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Description
            Text('Description / Special Requirements', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your requirements...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Duration (Optional)
            Text('Requested Duration (Days)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            TextFormField(
              controller: controller.durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Optional: estimated days',
                prefixIcon: Icon(Iconsax.clock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Attachments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Attachments (Optional)', style: Theme.of(context).textTheme.titleMedium)),
                TextButton.icon(
                  onPressed: controller.pickFiles,
                  icon: const Icon(Iconsax.document_upload),
                  label: const Text('Add Files'),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            
            // Selected Files List
            Obx(
              () => controller.selectedFiles.isEmpty
                  ? const Center(
                      child: Text(
                        'No files attached',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.selectedFiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                      itemBuilder: (context, index) {
                        final file = controller.selectedFiles[index];
                        return ListTile(
                          leading: const Icon(Iconsax.document),
                          title: Text(
                            file.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('${(file.lengthSync() / 1024).toStringAsFixed(1)} KB'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => controller.removeFile(file),
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    )
            ),
            
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.createRequest(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Submit Service Request'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
