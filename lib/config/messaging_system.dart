import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Messaging {
  // انواع مختلف نوتیفیکیشن‌ها
  static const int SUCCESS = 0;
  static const int ERROR = 1;
  static const int WARNING = 2;
  static const int INFO = 3;

  // ایجاد یک نوتیفیکیشن جدید
  static void showNotification({
    required String title,
    required String message,
    int type = INFO,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showProgressBar = true,
    bool dismissible = true,
    String? actionText,
    VoidCallback? onActionTap,
    Alignment alignment = Alignment.topCenter,
  }) {
    // تعریف رنگ‌ها براساس نوع نوتیفیکیشن
    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (type) {
      case SUCCESS:
        backgroundColor = Color(0xFF00C853);
        iconColor = Colors.white;
        icon = Icons.check_circle_outline;
        break;
      case ERROR:
        backgroundColor = Color(0xFFD50000);
        iconColor = Colors.white;
        icon = Icons.error_outline;
        break;
      case WARNING:
        backgroundColor = Color(0xFFFFAB00);
        iconColor = Colors.white;
        icon = Icons.warning_amber_outlined;
        break;
      case INFO:
      default:
        backgroundColor = Color(0xFF2196F3);
        iconColor = Colors.white;
        icon = Icons.info_outline;
        break;
    }

    // پنهان‌کردن هرگونه نوتیفیکیشن فعلی
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    // ایجاد overlayEntry برای نمایش نوتیفیکیشن سفارشی‌شده
    OverlayState? overlayState = Overlay.of(Get.overlayContext!);
    OverlayEntry? _overlayEntry;

    // کنترل‌کننده انیمیشن
    AnimationController? _animationController;
    Animation<double>? _slideAnimation;
    Animation<double>? _fadeAnimation;
    Timer? _timer;
    double _progress = 0.0;

    // ایجاد ویجت نوتیفیکیشن
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // تنظیم انیمیشن‌ها
            _animationController ??= AnimationController(
              vsync: Navigator.of(context),
              duration: Duration(milliseconds: 300),
            );

            _slideAnimation ??= Tween<double>(
                begin: alignment.y < 0 ? -1.0 : 1.0,
                end: 0.0
            ).animate(CurvedAnimation(
                parent: _animationController!,
                curve: Curves.easeOutCubic
            ));

            _fadeAnimation ??= Tween<double>(
                begin: 0.0,
                end: 1.0
            ).animate(CurvedAnimation(
                parent: _animationController!,
                curve: Curves.easeIn
            ));

            // شروع انیمیشن در اولین رندر
            if (!_animationController!.isAnimating && !_animationController!.isCompleted) {
              _animationController!.forward();

              // تنظیم تایمر برای نوار پیشرفت
              if (showProgressBar) {
                _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
                  setState(() {
                    _progress = timer.tick / (duration.inMilliseconds / 50);
                    if (_progress >= 1.0) {
                      timer.cancel();
                      // بستن نوتیفیکیشن پس از اتمام زمان
                      _animationController!.reverse().then((_) {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      });
                    }
                  });
                });
              } else {
                // بستن نوتیفیکیشن بعد از مدت زمان مشخص
                Future.delayed(duration).then((_) {
                  if (_animationController?.status != AnimationStatus.dismissed) {
                    _animationController?.reverse().then((_) {
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    });
                  }
                });
              }
            }

            // تعریف ویجت اصلی نوتیفیکیشن
            return AnimatedBuilder(
              animation: _animationController!,
              builder: (_, __) {
                return Positioned(
                  left: 0,
                  right: 0,
                  top: alignment.y < 0 ? MediaQuery.of(context).viewPadding.top + 16 + (_slideAnimation!.value * 100) : null,
                  bottom: alignment.y > 0 ? MediaQuery.of(context).viewPadding.bottom + 16 + (_slideAnimation!.value * -100) : null,
                  child: Material(
                    color: Colors.transparent,
                    child: Opacity(
                      opacity: _fadeAnimation!.value,
                      child: SafeArea(
                        child: Align(
                          alignment: alignment,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: backgroundColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (onTap != null) {
                                      onTap();
                                    }

                                    if (dismissible) {
                                      _timer?.cancel();
                                      _animationController?.reverse().then((_) {
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                      });
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: backgroundColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                icon,
                                                color: backgroundColor,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  if (message.isNotEmpty)
                                                    SizedBox(height: 4),
                                                  if (message.isNotEmpty)
                                                    Text(
                                                      message,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (actionText != null && onActionTap != null)
                                              TextButton(
                                                onPressed: () {
                                                  onActionTap();
                                                  _timer?.cancel();
                                                  _animationController?.reverse().then((_) {
                                                    _overlayEntry?.remove();
                                                    _overlayEntry = null;
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: backgroundColor,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                ),
                                                child: Text(
                                                  actionText,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            if (dismissible && actionText == null)
                                              InkWell(
                                                onTap: () {
                                                  _timer?.cancel();
                                                  _animationController?.reverse().then((_) {
                                                    _overlayEntry?.remove();
                                                    _overlayEntry = null;
                                                  });
                                                },
                                                borderRadius: BorderRadius.circular(50),
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 20,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (showProgressBar)
                                        LinearProgressIndicator(
                                          value: _progress,
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                                          minHeight: 3,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    // نمایش نوتیفیکیشن در overlay
    overlayState.insert(_overlayEntry!);
  }

  // توابع کمکی برای انواع مختلف نوتیفیکیشن‌ها
  static void showSuccess({
    required String title,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showProgressBar = true,
    bool dismissible = true,
    String? actionText,
    VoidCallback? onActionTap,
    Alignment alignment = Alignment.topCenter,
  }) {
    showNotification(
      title: title,
      message: message,
      type: SUCCESS,
      duration: duration,
      onTap: onTap,
      showProgressBar: showProgressBar,
      dismissible: dismissible,
      actionText: actionText,
      onActionTap: onActionTap,
      alignment: alignment,
    );
  }

  static void showError({
    required String title,
    String message = '',
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    bool showProgressBar = true,
    bool dismissible = true,
    String? actionText,
    VoidCallback? onActionTap,
    Alignment alignment = Alignment.topCenter,
  }) {
    showNotification(
      title: title,
      message: message,
      type: ERROR,
      duration: duration,
      onTap: onTap,
      showProgressBar: showProgressBar,
      dismissible: dismissible,
      actionText: actionText,
      onActionTap: onActionTap,
      alignment: alignment,
    );
  }

  static void showWarning({
    required String title,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showProgressBar = true,
    bool dismissible = true,
    String? actionText,
    VoidCallback? onActionTap,
    Alignment alignment = Alignment.topCenter,
  }) {
    showNotification(
      title: title,
      message: message,
      type: WARNING,
      duration: duration,
      onTap: onTap,
      showProgressBar: showProgressBar,
      dismissible: dismissible,
      actionText: actionText,
      onActionTap: onActionTap,
      alignment: alignment,
    );
  }

  static void showInfo({
    required String title,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showProgressBar = true,
    bool dismissible = true,
    String? actionText,
    VoidCallback? onActionTap,
    Alignment alignment = Alignment.topCenter,
  }) {
    showNotification(
      title: title,
      message: message,
      type: INFO,
      duration: duration,
      onTap: onTap,
      showProgressBar: showProgressBar,
      dismissible: dismissible,
      actionText: actionText,
      onActionTap: onActionTap,
      alignment: alignment,
    );
  }

  // نمایش یک نوتیفیکیشن ساده با یک دکمه یا چند دکمه
  static void showDialog({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool isDismissible = true,
    Color? color,
    IconData? icon,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon != null
                  ? Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (color ?? Colors.blue).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color ?? Colors.blue,
                ),
              )
                  : SizedBox.shrink(),
              SizedBox(height: icon != null ? 16 : 0),
              Text(
                title,
                style:const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (cancelText != null)
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          if (onCancel != null) onCancel();
                        },
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (cancelText != null && confirmText != null)
                    SizedBox(width: 8),
                  if (confirmText != null)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: color ?? Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          if (onConfirm != null) onConfirm();
                        },
                        child: Text(
                          confirmText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: isDismissible,
    );
  }

  // نمایش نوتیفیکیشن‌های بالای صفحه (مناسب برای پیام‌ها)
  static void showToast({
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    TextStyle? textStyle,
    double radius = 30,
    Alignment alignment = Alignment.center,
  }) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: textStyle ?? TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.TOP,
      borderRadius: radius,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      isDismissible: true,
      duration: duration,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      overlayBlur: 0,
    );
  }
}