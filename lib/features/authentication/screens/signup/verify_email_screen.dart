import 'dart:async';
import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/utils/constants/image_strings.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;
  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.otpController.clear();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                width: THelperFunctions.screenWidth() * 0.6,
                image: const AssetImage(TImages.deliveredEmailIllustration),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Title & Subtitle
              Text(
                'Verify Your Email',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text(
                'Check your inbox (and spam folder) for the 6-digit code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// OTP Field
              TextFormField(
                controller: controller.otpController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '6-Digit Code',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(letterSpacing: 8, fontSize: 24, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  if (value.length == 6) {
                    controller.verifyEmailOTP(widget.email);
                  }
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.verifyEmailOTP(widget.email),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Verify'),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _secondsRemaining > 0 
                      ? null 
                      : () {
                          controller.resendEmailOTP(widget.email);
                          startTimer();
                        },
                  child: Text(
                    _secondsRemaining > 0 
                      ? 'Resend code in ${_secondsRemaining}s' 
                      : 'Resend code'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
