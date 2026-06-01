#import <UIKit/UIKit.h>
#import <dlfcn.h>
#include <mach/mach_time.h>

// تعريف الدوال لمحاكاة اللمس الحقيقي
typedef void* (*IOHIDEventSystemClientCreate_t)(CFAllocatorRef);
typedef void (*IOHIDEventSystemClientDispatchEvent_t)(void *, void *);
typedef void* (*IOHIDEventCreateDigitizerFingerEvent_t)(CFAllocatorRef, uint64_t, uint32_t, uint32_t, uint32_t, float, float, float, float, bool, bool);

@interface MoustacheOverlay : UIView
@property (nonatomic, strong) UIView *menuView;
@end

@implementation MoustacheOverlay

// 1. إنشاء الزر العائم (الشنب والتاج)
+ (void)createFloatingButton {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 60, 60);
    // يمكنك إضافة صورة الـ PNG هنا (btn.imageView.image = [UIImage imageNamed:@"moustache.png"])
    btn.backgroundColor = [UIColor blackColor];
    btn.layer.cornerRadius = 30;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [UIColor cyanColor].CGColor; // إطار فيروزي نيون
    [btn setTitle:@"👑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة ميزة السحب للزر
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [btn addGestureRecognizer:pan];
    [win addSubview:btn];
}

// 2. تصميم القائمة (النيون الملكي)
+ (void)toggleMenu {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIView *menu = [win viewWithTag:999];
    if (!menu) {
        menu = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 250, 300)];
        menu.tag = 999;
        menu.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.4 alpha:0.8]; // بنفسجي ملكي
        menu.layer.cornerRadius = 20;
        menu.layer.borderWidth = 2;
        menu.layer.borderColor = [UIColor systemPinkColor].CGColor; // إطار وردي نيون
        
        // إضافة شريط السرعة
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 50, 210, 30)];
        [menu addSubview:slider];
        
        // زر التشغيل والإيقاف
        UIButton *start = [UIButton buttonWithType:UIButtonTypeSystem];
        [start setTitle:@"▶️ تشغيل" forState:UIControlStateNormal];
        start.frame = CGRectMake(20, 100, 100, 40);
        [menu addSubview:start];
        
        [win addSubview:menu];
    } else {
        menu.hidden = !menu.hidden;
    }
}

// 3. نظام النقر الحقيقي (خلفية مستقلة)
+ (void)performRealClickAtX:(float)x Y:(float)y {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        void* handle = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_GLOBAL);
        auto CreateEvent = (IOHIDEventCreateDigitizerFingerEvent_t)dlsym(handle, "IOHIDEventCreateDigitizerFingerEvent");
        auto DispatchEvent = (IOHIDEventSystemClientDispatchEvent_t)dlsym(handle, "IOHIDEventSystemClientDispatchEvent");
        void* client = ((IOHIDEventSystemClientCreate_t)dlsym(handle, "IOHIDEventSystemClientCreate"))(kCFAllocatorDefault);
        
        uint64_t ts = mach_absolute_time();
        void* down = CreateEvent(kCFAllocatorDefault, ts, 1, 1, 1, x, y, 1.0, 1.0, true, true);
        void* up = CreateEvent(kCFAllocatorDefault, ts, 1, 1, 1, x, y, 0.0, 1.0, false, true);
        
        DispatchEvent(client, down);
        DispatchEvent(client, up);
    });
}

+ (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint trans = [p translationInView:p.view.superview];
    p.view.center = CGPointMake(p.view.center.x + trans.x, p.view.center.y + trans.y);
    [p setTranslation:CGPointZero inView:p.view.superview];
}
@end

__attribute__((constructor)) static void load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MoustacheOverlay createFloatingButton];
    });
}
