#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - Autoresizing Mask
#define ARM_NONE UIViewAutoresizingNone
#define ARM_FLM  UIViewAutoresizingFlexibleLeftMargin
#define ARM_FW   UIViewAutoresizingFlexibleWidth
#define ARM_FRM  UIViewAutoresizingFlexibleRightMargin
#define ARM_FTM  UIViewAutoresizingFlexibleTopMargin
#define ARM_FH   UIViewAutoresizingFlexibleHeight
#define ARM_FBM  UIViewAutoresizingFlexibleBottomMargin
#define ARM_FM   ARM_FLM | ARM_FRM | ARM_FTM | ARM_FBM
#define ARM_FS   ARM_FW  | ARM_FH
#define ARM_FA   ARM_FS  | ARM_FM


#pragma mark - Dispatch Async
#define DISPATCH_ASYNC(blockBackground, blockMain) {\
    dispatch_async(\
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),\
        ^{\
            blockBackground();\
            dispatch_async(dispatch_get_main_queue(), blockMain);\
        }\
    );\
}
#define BACKGROUND_THREAD(block) {\
    dispatch_async(\
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),\
        block\
    );\
}
#define MAIN_THREAD(block) {\
    dispatch_async(\
        dispatch_get_main_queue(),\
        block\
    );\
}


#pragma mark - NSBundle (CFBundleInfo)

@interface NSBundle (CFBundleInfo)

@property (readonly, strong, nonatomic, nullable) NSString *bundleID;
@property (readonly, strong, nonatomic, nullable) NSString *bundleName;
@property (readonly, strong, nonatomic, nullable) NSArray *bundleURLTypes;
@property (readonly, strong, nonatomic, nullable) NSString *bundleVersion;
@property (readonly, strong, nonatomic, nullable) NSString *bundleVersionBuild;
@property (readonly, strong, nonatomic, nullable) NSString *bundleVersionShort;

- (BOOL)availableScheme:(nonnull NSString *)scheme;
- (nullable NSString *)bundleURLScheme:(nullable NSString *)identifier;

@end


#pragma mark - NSBundle (Platform)

@interface NSBundle (Platform)

@property (readonly, strong, nonatomic, nullable) NSString *platform;
@property (readonly, strong, nonatomic, nullable) NSString *platformVersion;

@end


#pragma mark - NSDictionary (Extends)

@interface NSDictionary (Extends)

+ (nonnull NSDictionary *)extend:(nonnull NSDictionary *)original
                  withDictionary:(nonnull NSDictionary *)target
                       overwrite:(BOOL)overwrite;
- (nonnull NSDictionary *)extend:(nonnull NSDictionary *)target
                       overwrite:(BOOL)overwrite;

@end


#pragma mark - NSDictionary (Key)

@interface NSDictionary (Key)

- (BOOL)existsKey:(nonnull NSString *)key;
- (BOOL)existsKeyIgnoreCase:(nonnull NSString *)key;

@end


#pragma mark - NSDictionary (Value)

@interface NSDictionary (Value)

- (nullable id)objectForKeyIgnoreCase:(nonnull id)key;
- (nullable id)valueForKeyIgnoreCase:(nonnull NSString *)key;

@end


#pragma mark - NSFileManager (Path)

@interface NSFileManager (Path)

- (nullable NSString *)getDocumentsDirectory;

@end


#pragma mark - NSOperationQueue (RunBlock)

@interface NSOperationQueue (RunBlock)

+ (nonnull NSOperationQueue *)runBlock:(void (^_Nullable)(void))block
                               inQueue:(nullable NSOperationQueue *)queue;
+ (nonnull NSOperation *)runBlock:(void (^_Nullable)(void))block
                          inQueue:(nullable NSOperationQueue *)queue
                       completion:(void (^_Nullable)(BOOL finished))completion;
+ (nonnull NSOperationQueue *)runBlock:(void (^_Nullable)(void))block
                               inQueue:(nullable NSOperationQueue *)queue
                             mainBlock:(void (^_Nullable)(void))main;
+ (void)runBlockMainQueue:(void (^_Nullable)(void))block;

@end


#pragma mark - NSString (Compare)

@interface NSString (Compare)

- (BOOL)isEndWithString:(nonnull NSString *)end;
- (BOOL)isEndWithString:(nonnull NSString *)end
         moreThanLength:(NSUInteger)more;
- (BOOL)isEqualToStringIgnoreCase:(nonnull NSString *)target;
- (BOOL)isStartWithString:(nonnull NSString *)start;
- (BOOL)isStartWithString:(nonnull NSString *)start
           moreThanLength:(NSUInteger)more;

@end


#pragma mark - NSString (Repeat)

@interface NSString (Repeat)

- (nonnull NSString *)appendRepeatString:(nonnull NSString *)target
                               withTimes:(NSUInteger)times;
- (nonnull NSString *)repeatTimes:(NSUInteger)times;

@end


#pragma mark - NSString (Time)

@interface NSString (Time)

+ (nonnull NSString *)timeFromCMTime:(CMTime)time
                        withHourPart:(BOOL)always;
+ (nonnull NSString *)timeFromSeconds:(Float64)seconds
                         withHourPart:(BOOL)always;

@end


#pragma mark - NSURL (Query)

@interface NSURL (Query)

@property (readonly, strong, nonatomic, nullable) NSDictionary *queries;

@end


#pragma mark - UIColor (HexRGBColor)

@interface UIColor (HexRGBColor)

+ (nonnull UIColor *)colorWithHex:(unsigned long)hex alpha:(CGFloat)alpha;
+ (nonnull UIColor *)colorWithHexString:(nonnull NSString *)hexString;

@end


#pragma mark - UIImage (Draw)

@interface UIImage (Draw)

+ (nonnull UIImage *)circle:(nonnull UIColor *)color size:(CGSize)size;
+ (nonnull UIImage *)rect:(nonnull UIColor *)color size:(CGSize)size;

@end


#pragma mark - UIView (FindViewController)

@interface UIView (FindViewController)

- (nullable id)parentViewController;
- (nullable UIViewController *)parentUIViewController;

@end
