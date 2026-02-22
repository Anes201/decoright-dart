import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    Key? key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.leadingOnPressed,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.centerTitle,
  }) : super(key: key);

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
        iconTheme: IconThemeData(
          color: isDark? TColors.white: TColors.dark
        ),
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: elevation,
        centerTitle: centerTitle,
        title: title,
        leading: showBackArrow
            ? IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.keyboard_arrow_left_sharp,
            color: isDark ? TColors.light : TColors.dark,
          ),
        )
            : null,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
