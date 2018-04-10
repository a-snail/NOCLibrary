#import "NOCLibrary.h"
#import "NOCLog.h"


#pragma mark - NSBundle (CFBundleInfo)

@implementation NSBundle (CFBundleInfo)

- (nullable NSString *)bundleID {
    return (NSString *)[self objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (nullable NSString *)bundleName {
    return (NSString *)[self objectForInfoDictionaryKey:@"CFBundleName"];
}

- (nullable NSArray *)bundleURLTypes {
    return (NSArray *)[self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
}

- (nullable NSString *)bundleVersion {
    return [NSString stringWithFormat:@"%@.%@",
            self.bundleVersionShort,
            self.bundleVersionBuild];
}

- (nullable NSString *)bundleVersionBuild {
    return (NSString *)[self objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (nullable NSString *)bundleVersionShort {
    return (NSString *)[self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (BOOL)availableScheme:(nonnull NSString *)scheme {
    NOCLogV(@"scheme : %@", scheme);
    NSArray *types = self.bundleURLTypes;
    for (NSDictionary *type in types) {
        if ([type isKindOfClass:[NSDictionary class]]) {
            NSArray *schemes = [type objectForKey:@"CFBundleURLSchemes"];
            for (NSString *value in schemes) {
                if ([value isEqualToString:scheme]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (nullable NSString *)bundleURLScheme:(nullable NSString *)identifier {
    NOCLogV(@"identifier : %@", identifier);
    NSArray *types = self.bundleURLTypes;
    for (NSDictionary *type in types) {
        if ([type isKindOfClass:[NSDictionary class]]) {
            NSString *name = [type objectForKey:@"CFBundleURLName"];
            if (identifier && [identifier isEqualToString:name]) {
                NSArray *schemes = [type objectForKey:@"CFBundleURLSchemes"];
                if (schemes && [schemes lastObject]) {
                    return [schemes objectAtIndex:(NSUInteger)0];
                }
            }
        }
    }
    return nil;
}

@end


#pragma mark - NSBundle (Platform)

@implementation NSBundle (Platform)

- (nullable NSString *)platform {
    return (NSString *)[self objectForInfoDictionaryKey:@"DTPlatformName"];
}

- (nullable NSString *)platformVersion {
    return (NSString *)[self objectForInfoDictionaryKey:@"DTPlatformVersion"];
}

@end


#pragma mark - NSDictionary (Extends)

@implementation NSDictionary (Extends)

+ (nonnull NSDictionary *)extend:(nonnull NSDictionary *)original
                  withDictionary:(nonnull NSDictionary *)target
                       overwrite:(BOOL)overwrite {
    NOCLogV(@"%@%@\n%@%@\n%@%@",
            @"original  : ", original,
            @"target    : ", target,
            @"overwrite : ", @(overwrite));
    NSMutableDictionary *result = [NSMutableDictionary
                                   dictionaryWithDictionary:original];
    __block NSMutableDictionary *bResult = result;
    [target enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //NOCLogI(@"%@%@\n%@%@\n%@%@",
        //        @"key  : ", key,
        //        @"obj  : ", obj,
        //        @"stop : ", stop ? @"YES" : @"NO");
        if (![original objectForKey:key]) {
            [bResult setObject:obj forKey:key];
        }
        else {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [(NSDictionary *)[original objectForKey:key]
                                     extend:(NSDictionary *)obj
                                     overwrite:overwrite];
                [bResult setObject:dic forKey:key];
            }
            else {
                if (overwrite) {
                    [bResult setObject:obj forKey:key];
                }
            }
        }
    }];

    return (NSDictionary *)[result mutableCopy];
}

- (nonnull NSDictionary *)extend:(nonnull NSDictionary *)target
                       overwrite:(BOOL)overwrite {
    NOCLogV(@"%@%@\n%@%@\n%@%@",
            @"self      : ", self,
            @"target    : ", target,
            @"overwrite : ", @(overwrite));
    return [[self class] extend:self withDictionary:target overwrite:overwrite];
}

@end


#pragma mark - NSDictionary (Key)

@implementation NSDictionary (Key)

- (BOOL)existsKey:(nonnull NSString *)key {
    NOCLogV(@"key : %@", key);
    if ([[self allKeys] containsObject:key]) {
        return YES;
    }
    return NO;
}

- (BOOL)existsKeyIgnoreCase:(nonnull NSString *)key {
    NOCLogV(@"key : %@", key);
    if ([self existsKey:key]) {
        return YES;
    }

    NSString *lowerKey = [key lowercaseString];
    for (NSString *k in [self allKeys]) {
        if ([lowerKey isEqualToString:[k lowercaseString]]) {
            return YES;
        }
    }
    return NO;
}

@end


#pragma mark - NSDictionary (Value)

@implementation NSDictionary (Value)

- (nullable id)objectForKeyIgnoreCase:(nonnull id)key {
    NOCLogV(@"key : %@", key);
    id result = [self objectForKey:key];
    if (result) {
        return result;
    }

    if ([key isKindOfClass:[NSString class]]) {
        NSString *lowerKey = [(NSString *)key lowercaseString];
        for (id k in [self allKeys]) {
            if ([k isKindOfClass:[NSString class]]) {
                if ([lowerKey isEqualToString:[(NSString *)k lowercaseString]]) {
                    return [self objectForKey:k];
                }
            }
        }
    }
    return nil;
}

- (nullable id)valueForKeyIgnoreCase:(nonnull NSString *)key {
    NOCLogV(@"key : %@", key);
    id result = [self valueForKey:key];
    if (result) {
        return result;
    }

    NSString *lowerKey = [key lowercaseString];
    for (id k in [self allKeys]) {
        if ([k isKindOfClass:[NSString class]]) {
            if ([lowerKey isEqualToString:[(NSString *)k lowercaseString]]) {
                return [self valueForKey:k];
            }
        }
    }
    return nil;
}

@end


#pragma mark - NSFileManager (Path)

@implementation NSFileManager (Path)

- (nullable NSString *)getDocumentsDirectory {
    NOCLogV(@"");
    BOOL isDir = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    if (paths && paths.count > 0) {
        for (NSString *path in paths) {
            if ([path rangeOfString:@"Documents"].location != NSNotFound) {
                if ([self fileExistsAtPath:path isDirectory:&isDir]) {
                    if (isDir) {
                        return path;
                    }
                }
            }
        }
    }

    NSString *pathDoc = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    if ([self fileExistsAtPath:pathDoc isDirectory:&isDir]) {
        if (isDir) {
            return pathDoc;
        }
    }

    return nil;
}

@end


#pragma mark - NSOperationQueue (RunBlock)

@implementation NSOperationQueue (RunBlock)

+ (nonnull NSOperationQueue *)runBlock:(void (^_Nullable)(void))block
                               inQueue:(nullable NSOperationQueue *)queue {
    NOCLogV(@"%@%@\n%@%@",
            @"block : ", block,
            @"queue : ", queue);
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        block();
    }];
    [queue addOperation:operation];

    return queue;
}

+ (nonnull NSOperation *)runBlock:(void (^_Nullable)(void))block
                          inQueue:(nullable NSOperationQueue *)queue
                       completion:(void (^_Nullable)(BOOL finished))completion {
    NOCLogV(@"%@%@\n%@%@\n%@%@",
            @"block      : ", block,
            @"queue      : ", queue,
            @"completion : ", completion);
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }

    NSOperation *operationB = [NSBlockOperation blockOperationWithBlock:block];
    NSOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        completion(operationB.isFinished);
    }];
    [operationC addDependency:operationB];

    [[NSOperationQueue currentQueue] addOperation:operationC];
    [queue addOperation:operationB];

    return operationB;
}

+ (nonnull NSOperationQueue *)runBlock:(void (^_Nullable)(void))block
                               inQueue:(nullable NSOperationQueue *)queue
                             mainBlock:(void (^_Nullable)(void))main {
    NOCLogV(@"%@%@\n%@%@\n%@%@",
            @"block : ", block,
            @"queue : ", queue,
            @"main  : ", main);
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        block();
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            main();
        }];
    }];
    [queue addOperation:operation];

    return queue;
}

+ (void)runBlockMainQueue:(void (^_Nullable)(void))block {
    NOCLogV(@"block : %@", block);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        block();
    }];
}

@end


#pragma mark - NSString (Compare)

@implementation NSString (Compare)

- (BOOL)isEndWithString:(nonnull NSString *)end {
    NOCLogV(@"end : %@", end);
    return [self isEndWithString:end moreThanLength:(NSUInteger)0];
}

- (BOOL)isEndWithString:(nonnull NSString *)end
         moreThanLength:(NSUInteger)more {
    NOCLogV(@"%@%@\n%@%lu",
            @"end  : ", end,
            @"more : ", (unsigned long)more);
    if (self.length < 1 || end.length < 1) return NO;
    if (self.length < end.length + more) return NO;
    NSUInteger len = self.length - end.length;
    if ([[self substringFromIndex:len] isEqualToString:end]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualToStringIgnoreCase:(nonnull NSString *)target {
    NOCLogV(@"target : %@", target);
    if (target.length == 0) {
        return (self.length == 0);
    }
    if ([[self lowercaseString] isEqualToString:[target lowercaseString]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isStartWithString:(nonnull NSString *)start {
    NOCLogV(@"start : %@", start);
    return [self isStartWithString:start moreThanLength:(NSUInteger)0];
}

- (BOOL)isStartWithString:(nonnull NSString *)start
           moreThanLength:(NSUInteger)more {
    NOCLogV(@"%@%@\n%@%lu",
            @"start : ", start,
            @"more  : ", (unsigned long)more);
    if (self.length < 1 || start.length < 1) return NO;
    if (self.length < start.length + more) return NO;
    if ([[self substringToIndex:start.length] isEqualToString:start]) {
        return YES;
    }
    return NO;
}

@end


#pragma mark - NSString (Repeat)

@implementation NSString (Repeat)

- (nonnull NSString *)appendRepeatString:(nonnull NSString *)target
                               withTimes:(NSUInteger)times {
    NOCLogV(@"%@%@\n%@%lu",
            @"target : ", target,
            @"times  : ", (unsigned long)times);
    return [self stringByPaddingToLength:(NSUInteger)(self.length + (times * target.length))
                              withString:target
                         startingAtIndex:0];
}

- (nonnull NSString *)repeatTimes:(NSUInteger)times {
    NOCLogV(@"times : %lu", (unsigned long)times);
    return [@"" stringByPaddingToLength:(times * self.length)
                             withString:self
                        startingAtIndex:0];
}

@end


#pragma mark - NSString (Time)

@implementation NSString (Time)

+ (nonnull NSString *)timeFromCMTime:(CMTime)time
                        withHourPart:(BOOL)always {
    NOCLogV(@"Seconds of time : %f", CMTimeGetSeconds(time));
    Float64 seconds = 0.f;
    if (CMTIME_IS_NUMERIC(time)) {
        seconds = CMTimeGetSeconds(time);
    }
    return [NSString timeFromSeconds:seconds withHourPart:always];
}

+ (nonnull NSString *)timeFromSeconds:(Float64)seconds
                         withHourPart:(BOOL)always {
    NOCLogV(@"seconds : %f", seconds);
    NSString *H = @"", *M = @"", *S = @"";

    int h = (int)((float)seconds / (float)3600.f);
    int t = (int)fmodf((float)seconds,  (float)3600.f);
    if (h > (int)0) {
        H = [NSString stringWithFormat:@"%02d:", h];
    }
    else {
        if (always) {
            H = @"0:";
        }
    }

    int m = (int)((float)t / (float)60.f);
    M = [NSString stringWithFormat:@"%02d:", m];

    int s = (int)fmodf((float)t, (float)60.f);
    S = [NSString stringWithFormat:@"%02d", s];

    NSString *result = [NSString stringWithFormat:@"%@%@%@", H, M, S];
    H = M = S = nil;
    return result;
}

@end


#pragma mark - NSURL (Query)

@implementation NSURL (Query)

- (nullable NSDictionary *)queries {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSArray *components = [self.query componentsSeparatedByString:@"&"];
    for (NSString *component in components) {
        NSArray *splits = [component componentsSeparatedByString:@"="];
        NSString *key   = [splits objectAtIndex:0];
        key             = key.stringByRemovingPercentEncoding;
        NSString *value = [splits objectAtIndex:1];
        value           = value.stringByRemovingPercentEncoding;
        if (splits.count > 2) {
            for (int i = 2; i <= splits.count - 1; i++) {
                NSString *val = [splits objectAtIndex:i];
                val           = val.stringByRemovingPercentEncoding;
                value = [NSString stringWithFormat:@"%@=%@", value, val];
            }
        }
        [parameters setObject:value forKey:key];
    }
    return (NSDictionary *)[parameters copy];
}

@end


#pragma mark - UIColor (HexRGBColor)

@implementation UIColor (HexRGBColor)

+ (nonnull UIColor *)colorWithHex:(unsigned long)hex alpha:(CGFloat)alpha {
    NOCLogV(@"%@%lu\n%@%f",
            @"hex   : ", hex,
            @"alpha : ", alpha);
    return [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((hex & 0x00FF00) >>  8)) / 255.0
                            blue:((CGFloat)((hex & 0X0000FF) >>  0)) / 255.0
                           alpha:alpha];
}

+ (nonnull UIColor *)colorWithHexString:(nonnull NSString *)hexString {
    NOCLogV(@"hexString : %@", hexString);
    unsigned long long hex = 0;
    float alpha = 1.f;
    if (hexString.length <= 8) {
        [[NSScanner scannerWithString:hexString] scanHexLongLong:&hex];
    }
    else {
        NSString *rgb = [hexString substringWithRange:NSMakeRange(0, 8)];
        NSString *alp = [hexString substringWithRange:NSMakeRange(8, 2)];
        alp = [NSString stringWithFormat:@"0x%@", alp];
        [[NSScanner scannerWithString:rgb] scanHexLongLong:&hex];
        [[NSScanner scannerWithString:alp] scanHexFloat:&alpha];
        alpha = (CGFloat)(alpha / 255.0);
        rgb = nil;
        alp = nil;
    }
    return [UIColor colorWithHex:(unsigned long)hex alpha:(CGFloat)alpha];
}

@end


#pragma mark - UIImage (Draw)

@implementation UIImage (Draw)

+ (nonnull UIImage *)circle:(nonnull UIColor *)color size:(CGSize)size {
    NOCLogV(@"%@%@\n%@%@",
            @"color : ", color,
            @"size  : ", NSStringFromCGSize(size));
    static UIImage *img = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, (CGFloat)1.f);
        CGContextRef ref = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ref);

        CGFloat pos = (CGFloat)0.f;
        CGRect rect = CGRectMake(pos, pos, size.width, size.height);
        CGContextSetFillColorWithColor(ref, color.CGColor);
        CGContextFillEllipseInRect(ref, rect);

        CGContextRestoreGState(ref);
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return img;
}

+ (nonnull UIImage *)rect:(nonnull UIColor *)color size:(CGSize)size {
    NOCLogV(@"%@%@\n%@%@",
            @"color : ", color,
            @"size  : ", NSStringFromCGSize(size));
    static UIImage *img = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, (CGFloat)1.f);
        CGContextRef ref = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ref);

        CGFloat pos = (CGFloat)0.f;
        CGRect rect = CGRectMake(pos, pos, size.width, size.height);
        CGContextSetFillColorWithColor(ref, color.CGColor);
        CGContextFillRect(ref, rect);

        CGContextRestoreGState(ref);
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return img;
}

@end


#pragma mark - UIView (FindViewController)

@implementation UIView (FindViewController)

- (nullable id)parentViewController {
    NOCLogV(@"");
    id nextResponder = self.nextResponder;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder parentViewController];
    }
    else {
        return nil;
    }
}

- (nullable UIViewController *)parentUIViewController {
    NOCLogV(@"");
    return (UIViewController *)[self parentViewController];
}

@end
