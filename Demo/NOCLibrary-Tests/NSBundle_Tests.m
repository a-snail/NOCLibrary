#import <XCTest/XCTest.h>
#import "NOCLibrary.h"


@interface NSBundle_Tests : XCTestCase
@end


@implementation NSBundle_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBundleInfo {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *bundleID = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    XCTAssertEqualObjects(bundle.bundleID, bundleID);

    NSString *bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    XCTAssertEqualObjects(bundle.bundleName, bundleName);

    NSArray *bundleURLTypes = [bundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    XCTAssertEqualObjects(bundle.bundleURLTypes, bundleURLTypes);

    NSString *bundleVersion = [NSString stringWithFormat:@"%@.%@",
                               bundle.bundleVersionShort,
                               bundle.bundleVersionBuild];
    XCTAssertEqualObjects(bundle.bundleVersion, bundleVersion);

    NSString *bundleVersionShort = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    XCTAssertEqualObjects(bundle.bundleVersionShort, bundleVersionShort);

    NSString *bundleVersionBuild = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    XCTAssertEqualObjects(bundle.bundleVersionBuild, bundleVersionBuild);
}

- (void)testPlatform {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *platform = [bundle objectForInfoDictionaryKey:@"DTPlatformName"];
    XCTAssertEqualObjects(bundle.platform, platform);

    NSString *platformVersion = [bundle objectForInfoDictionaryKey:@"DTPlatformVersion"];
    XCTAssertEqualObjects(bundle.platformVersion, platformVersion);
}

//- (void)testPerformanceExample {
//    [self measureBlock:^{
//    }];
//}

@end
