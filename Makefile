# اسم التويك الخاص بك
TWEAK_NAME = MoustacheMenu

# ملفات السورس التي سيتم تجميعها
MoustacheMenu_FILES = main.mm

# استدعاء أطر العمل الرسمية لواجهات وألوان ونظام آبل
MoustacheMenu_FRAMEWORKS = UIKit CoreGraphics QuartzCore

# تفعيل محرك الـ Objective-C الديناميكي لحقن النقرات وتخطي تحذيرات المترجم
MoustacheMenu_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-function

include $(THEOS_MAKE_PATH)/tweak.mk
