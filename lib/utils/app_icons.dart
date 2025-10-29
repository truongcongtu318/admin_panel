// filepath: c:\Users\tu\StudioProjects\admin_panel\admin_panel\lib\utils\app_icons.dart

import 'package:flutter/cupertino.dart';

/// iOS Cupertino Icons cho toàn app
class AppIcons {
  // Auth & User
  static const IconData person = CupertinoIcons.person_fill;
  static const IconData personCircle = CupertinoIcons.person_crop_circle_fill;
  static const IconData email = CupertinoIcons.mail_solid;
  static const IconData lock = CupertinoIcons.lock_fill;
  static const IconData lockOpen = CupertinoIcons.lock_open;

  // Actions
  static const IconData add = CupertinoIcons.add;
  static const IconData addCircle = CupertinoIcons.add_circled_solid;
  static const IconData edit = CupertinoIcons.pencil;
  static const IconData delete = CupertinoIcons.trash_fill;
  static const IconData check = CupertinoIcons.check_mark;
  static const IconData close = CupertinoIcons.xmark;
  static const IconData checkCircle = CupertinoIcons.check_mark_circled_solid;

  // Navigation
  static const IconData back = CupertinoIcons.back;
  static const IconData forward = CupertinoIcons.forward;
  static const IconData arrowLeft = CupertinoIcons.arrow_left;
  static const IconData arrowRight = CupertinoIcons.arrow_right;
  static const IconData chevronLeft = CupertinoIcons.chevron_left;
  static const IconData chevronRight = CupertinoIcons.chevron_right;

  // Common
  static const IconData search = CupertinoIcons.search;
  static const IconData refresh = CupertinoIcons.refresh;
  static const IconData settings = CupertinoIcons.settings_solid;
  static const IconData logout = CupertinoIcons.square_arrow_right;
  static const IconData menu = CupertinoIcons.line_horizontal_3;
  static const IconData more = CupertinoIcons.ellipsis;
  static const IconData moreVertical = CupertinoIcons.ellipsis_vertical;

  // Media
  static const IconData image = CupertinoIcons.photo_fill;
  static const IconData camera = CupertinoIcons.camera_fill;
  static const IconData photoLibrary = CupertinoIcons.photo_on_rectangle;

  // Status
  static const IconData info = CupertinoIcons.info_circle_fill;
  static const IconData warning = CupertinoIcons.exclamationmark_triangle_fill;
  static const IconData error = CupertinoIcons.xmark_circle_fill;
  static const IconData success = CupertinoIcons.checkmark_circle_fill;

  // Admin Panel Specific
  static const IconData adminPanel = CupertinoIcons.person_2_square_stack;
  static const IconData dashboard = CupertinoIcons.square_grid_2x2_fill;
  static const IconData users = CupertinoIcons.person_3_fill;
  static const IconData fingerprint = CupertinoIcons.hand_raised_fill;

  // Empty States
  static const IconData searchOff = CupertinoIcons.search_circle;
  static const IconData peopleOutline = CupertinoIcons.person_2;
}
