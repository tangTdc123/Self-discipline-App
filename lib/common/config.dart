import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:quit_product/models/exercise.dart';
import 'package:quit_product/models/illustrations.dart';
import 'package:quit_product/models/sound.dart';
import 'package:quit_product/models/target.dart';

final Color textBlackColor = Color.fromARGB(69,80,97,1);
final Color textGreyColor = Color.fromARGB(151,158,168,1);
final Color commonGreenColor = Color.fromRGBO(195, 211,83,1);



final List<Illustrations> spalshIllustrations = [
  Illustrations(
      asset: 'assets/illustrations/splash/junk_food.svg',),
  Illustrations(
      asset: 'assets/illustrations/splash/mental-well-being.svg',)
];
final List<Target> defaultTargets = [
  Target()
    ..name = 'quit_milktea'.tr
    ..description = 'start_healthy_lifestyle'.tr.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(240, 199, 73, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_smoking".tr
    ..description = 'start_healthy_lifestyle'.tr.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(237, 135, 52, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 19, minute: 00),
    ],
  Target()
    ..name = "quit_soap_opera".tr
    ..description = 'start_healthy_lifestyle'.tr.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(211, 88, 70, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 19, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_friedchicken".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(229, 108, 104, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_cola".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(71, 150, 206, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_drinking".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(196, 225, 104, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 12, minute: 00),
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_chips".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(200, 141, 215, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_hamburger".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(89, 184, 167, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_snacks".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(108, 131, 182, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_icecream".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(208, 162, 140, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  Target()
    ..name = "quit_spicy".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(85, 170, 105, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_crayfish".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(211, 88, 70, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_friedseries".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(71, 97, 142, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_barbecue".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(133, 206, 188, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  Target()
    ..name = "quit_masturbation".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(112, 206, 233, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
      TimeOfDay(hour: 23, minute: 00),
    ],
  Target()
    ..name = "quit_sugar".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(171, 222, 76, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 17, minute: 30),
    ],
  Target()
    ..name = "quit_carbohydrate".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(207, 87, 155, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 7, minute: 30),
      TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 17, minute: 30),
    ],
  Target()
    ..name = "quit_coffee".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(240, 199, 73, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 13, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
    ],
  Target()
    ..name = "quit_sex".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(237, 135, 52, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 20, minute: 30),
      TimeOfDay(hour: 22, minute: 30),
      TimeOfDay(hour: 23, minute: 30),
    ],
];

final List<int> defaultTargetDays = [7, 15, 30, 60, 100];

final List<Color> colors = [
  Color.fromRGBO(240, 199, 73, 1),
  Color.fromRGBO(237, 135, 52, 1),
  Color.fromRGBO(229, 108, 104, 1),
  Color.fromRGBO(71, 150, 206, 1),
  Color.fromRGBO(196, 225, 104, 1),
  Color.fromRGBO(200, 141, 215, 1),
  Color.fromRGBO(89, 184, 167, 1),
  Color.fromRGBO(108, 131, 182, 1),
  Color.fromRGBO(208, 162, 140, 1),
  Color.fromRGBO(85, 170, 105, 1),
  Color.fromRGBO(211, 88, 70, 1),
  Color.fromRGBO(71, 97, 142, 1),
  Color.fromRGBO(133, 206, 188, 1),
  Color.fromRGBO(112, 206, 233, 1),
  Color.fromRGBO(171, 222, 76, 1),
  Color.fromRGBO(207, 87, 155, 1),
];

List<Sound> notificationSounds = [
  Sound(
      soundKey: 'lg',
      soundName: 'sound_lg'.tr,
      soundPath: 'assets/sounds/lg.m4a'),
  Sound(
      soundKey: 'pikachu',
      soundName: 'sound_pikachu'.tr,
      soundPath: 'assets/sounds/pikachu.m4a'),
  Sound(
      soundKey: 'ringtones',
      soundName: 'sound_ringtones'.tr,
      soundPath: 'assets/sounds/ringtones.m4a'),
  Sound(
      soundKey: 'samsung',
      soundName: 'sound_samsung'.tr,
      soundPath: 'assets/sounds/samsung.m4a'),
  Sound(
      soundKey: 'slow_spring_board',
      soundName: 'sound_spring'.tr,
      soundPath: 'assets/sounds/slow_spring_board.m4a'),
];
List<Exercise> exercises = [
  // Exercise("assets/animations/exercise/22917-pushup.json"),
  Exercise("assets/animations/exercise/DinhDesigner/cobras.json",
      name: 'exercise_cobras'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_cobras_effect'.tr,
      actions: [
        'exercise_cobras_action_1'.tr,
        'exercise_cobras_action_2'.tr,
        'exercise_cobras_action_3'.tr,
      ],
      breaths: [
        'exercise_cobras_breath_1'.tr
      ],
      targets: [
        'exercise_cobras_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/frog-press.json",
      name: 'exercise_frog_press'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_frog_effect'.tr,
      actions: [
        'exercise_frog_press_action_1'.tr,
        'exercise_frog_press_action_2'.tr,
        'exercise_frog_press_action_3'.tr,
      ],
      breaths: [
        'exercise_frog_press_breath_1'.tr,
        'exercise_frog_press_breath_2'.tr
      ],
      targets: [
        'exercise_frog_press_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/inchworm.json",
      name: 'exercise_inchworm'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_inchworm_effect'.tr,
      actions: [
        'exercise_inchworm_action_1'.tr,
        'exercise_inchworm_action_2'.tr,
        'exercise_inchworm_action_3'.tr,
        'exercise_inchworm_action_4'.tr,
      ],
      breaths: [
        'exercise_inchworm_breath_1'.tr
      ],
      targets: [
        'exercise_inchworm_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/jumping-jack.json",
      name: 'exercise_jumping-jack'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_jumping-jack_effect'.tr,
      actions: [
        'exercise_jumping-jack_action_1'.tr,
        'exercise_jumping-jack_action_2'.tr,
        'exercise_jumping-jack_action_3'.tr,
        'exercise_jumping-jack_action_4'.tr,
      ],
      breaths: [
        'exercise_jumping-jack_breath_1'.tr
      ],
      targets: [
        'exercise_jumping-jack_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/jumping-squats.json",
      name: 'exercise_jumping-squats'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_jumping-squats_effect'.tr,
      actions: [
        'exercise_jumping-squats_action_1'.tr,
        'exercise_jumping-squats_action_2'.tr,
        'exercise_jumping-squats_action_3'.tr,
        'exercise_jumping-squats_action_4'.tr,
        'exercise_jumping-squats_action_5'.tr,
      ],
      breaths: [
        'exercise_jumping-squats_breath_1'.tr
      ],
      targets: [
        'exercise_jumping-squats_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/lunge.json",
      name: 'exercise_lunge'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_lunge_effect'.tr,
      actions: [
        'exercise_lunge_action_1'.tr,
        'exercise_lunge_action_2'.tr,
        'exercise_lunge_action_3'.tr,
      ],
      breaths: [
        'exercise_lunge_breath_1'.tr
      ],
      targets: [
        'exercise_lunge_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/punches.json",
      name: 'exercise_punches'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_punches_effect'.tr,
      actions: [
        'exercise_punches_action_1',
        'exercise_punches_action_2',
        'exercise_punches_action_3'
      ],
      breaths: [
        'exercise_punches_breath_1'.tr
      ],
      targets: [
        'exercise_punches_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/reverse-crunches.json",
      name: 'exercise_reverse-crunches'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_reverse-crunches_effect'.tr,
      actions: [
        'exercise_reverse-crunches_action_1'.tr,
        'exercise_reverse-crunches_action_2'.tr,
        'exercise_reverse-crunches_action_3'.tr,
        'exercise_reverse-crunches_action_4'.tr,
        'exercise_reverse-crunches_action_5'.tr,
      ],
      breaths: [
        'exercise_reverse-crunches_breath_1'.tr
      ],
      targets: [
        'exercise_reverse-crunches_target'.tr
      ]),
  // Exercise("assets/animations/exercise/DinhDesigner/seated-abs-circle.json",
  //     name: "眼镜蛇式",
  //     effect: "扩展胸部，增强脊柱",
  //     actions: [
  //       "俯卧在地面上，脸朝下，下巴贴地",
  //       "伸直双腿，双脚靠拢，膝盖绷直，脚趾指向后",
  //       "手肘弯曲，手掌放在胸部两侧，紧贴地面"
  //     ],
  //     breaths: [
  //       "自然呼吸"
  //     ],
  //     errors: [
  //       "错误：耸肩及肩胛骨受力",
  //       "解决：双手掌多向前放一些，肩膀远离双耳，也可将手肘落于垫面"
  //     ],
  //     targets: [
  //       "这个体式能让胸部得到完全扩展，脊柱得以充分的锻炼。对于脊柱受过损伤者尤有改善功效"
  //     ]),
  Exercise("assets/animations/exercise/DinhDesigner/seated-abs-circles.json",
      name: 'exercise_seated-abs-circles'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_seated-abs-circles_effect'.tr,
      actions: [
        'exercise_seated-abs-circles_action_1'.tr,
        'exercise_seated-abs-circles_action_2'.tr,
        'exercise_seated-abs-circles_action_3'.tr,
        'exercise_seated-abs-circles_action_4'.tr,
      ],
      breaths: [
        'exercise_seated-abs-circles_breath_1'.tr
      ],
      targets: [
        'exercise_seated-abs-circles_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/shoulder-stretch.json",
      name: 'exercise_shoulder-stretch'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_shoulder-stretch_effect'.tr,
      actions: [
        'exercise_shoulder-stretch_action_1'.tr,
        'exercise_shoulder-stretch_action_2'.tr,
        'exercise_shoulder-stretch_action_3'.tr,
        'exercise_shoulder-stretch_action_4'.tr,
      ],
      breaths: [
        'exercise_shoulder-stretch_breath_1'.tr
      ],
      targets: [
        'exercise_shoulder-stretch_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/squat-kick.json",
      name: 'exercise_squat-kick'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_squat-kick_effect'.tr,
      actions: [
        'exercise_squat-kick_action_1'.tr,
        'exercise_squat-kick_action_2'.tr,
        'exercise_squat-kick_action_3'.tr,
        'exercise_squat-kick_action_4'.tr,
      ],
      breaths: [
        'exercise_squat-kick_breath_1'.tr
      ],
      targets: [
        'exercise_squat-kick_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/staggered-push-ups.json",
      name: 'exercise_staggered-push-ups'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_staggered-push-ups_effect'.tr,
      actions: [
        'exercise_staggered-push-ups_action_1'.tr,
        'exercise_staggered-push-ups_action_2'.tr,
        'exercise_staggered-push-ups_action_3'.tr,
        'exercise_staggered-push-ups_action_4'.tr,
      ],
      breaths: [
        'exercise_staggered-push-ups_breath_1'.tr
      ],
      targets: [
        'exercise_staggered-push-ups_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/step-up-on-chair.json",
      name: 'exercise_step-up-on-chair'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_step-up-on-chair_effect'.tr,
      actions: [
        'exercise_step-up-on-chair_action_1',
        'exercise_step-up-on-chair_action_2',
        'exercise_step-up-on-chair_action_3',
        'exercise_step-up-on-chair_action_4',
        'exercise_step-up-on-chair_action_5',
      ],
      breaths: [
        'exercise_step-up-on-chair_breath_1'.tr
      ],
      targets: [
        'exercise_step-up-on-chair_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/t-plank-excercise.json",
      name: 'exercise_t-plank'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_t-plank_effect'.tr,
      actions: [
        'exercise_t-plank_action_1'.tr,
        'exercise_t-plank_action_2'.tr,
        'exercise_t-plank_action_3'.tr,
        'exercise_t-plank_action_4'.tr,
      ],
      breaths: [
        'exercise_t-plank_breath_1'.tr
      ],
      targets: [
        'exercise_t-plank_target'.tr
      ]),
  Exercise("assets/animations/exercise/DinhDesigner/wide-arm-push-up.json",
      name: 'exercise_wide-arm-push-up'.tr,
      copyright: 'Dinh Designer on lottiefiles.com',
      effect: 'exercise_wide-arm-push-up_effect'.tr,
      actions: [
        'exercise_wide-arm-push-up_action_1'.tr,
        'exercise_wide-arm-push-up_action_2'.tr,
        'exercise_wide-arm-push-up_action_3'.tr,
        'exercise_wide-arm-push-up_action_4'.tr,
        'exercise_wide-arm-push-up_action_5'.tr,
        'exercise_wide-arm-push-up_action_6'.tr,
      ],
      breaths: [
        'exercise_wide-arm-push-up_breath_1'.tr
      ],
      targets: [
        'exercise_wide-arm-push-up_target'.tr
      ]),
];