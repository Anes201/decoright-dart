
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Material(
      color: isDark ? TColors.black : TColors.white,
      child: TabBar(
        isScrollable: true,
        tabs: tabs,
        dividerColor: TColors.primary,
        labelColor: isDark ? TColors.white : TColors.primary,
        unselectedLabelColor: TColors.darkGrey,
      ),
    );
  }

  @override
  // Todo: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
