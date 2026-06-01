# تحديد بنية المعالج (للآيفون)
ARCHS = arm64 arm64e

# تحديد إصدار الـ SDK
TARGET = iphone:clang:latest:14.0

# استدعاء الإعدادات الأساسية للـ Theos
include $(THEOS)/makefiles/common.mk

# اسم الأداة (تأكد أن هذا الاسم يطابق اسم مشروعك)
TWEAK_NAME = MoustacheMod

# ملف الكود الرئيسي
MoustacheMod_FILES = main.mm

# المكتبات (Frameworks) التي يحتاجها الكود
MoustacheMod_FRAMEWORKS = UIKit QuartzCore CoreGraphics

# إعدادات إضافية للتأكد من ربط المكتبات بشكل صحيح
MoustacheMod_CFLAGS = -fobjc-arc

# إنهاء الملف
include $(THEOS_MAKE_PATH)/tweak.mk
