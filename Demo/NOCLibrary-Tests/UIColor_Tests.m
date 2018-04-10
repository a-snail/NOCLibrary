#import <XCTest/XCTest.h>
#import "NOCLibrary.h"


@interface UIColor_Tests : XCTestCase
@end

@implementation UIColor_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHexRGBColor {
    UIColor *white1 = [UIColor colorWithRed:(CGFloat)1.f green:1.f blue:1.f alpha:1.f];
    UIColor *white2 = [UIColor colorWithHex:(unsigned long)0xFFFFFF alpha:(CGFloat)1.f];
    XCTAssertEqualObjects(white1, white2);

    UIColor *black1 = [UIColor colorWithRed:(CGFloat)0.f green:0.f blue:0.f alpha:0.f];
    UIColor *black2 = [UIColor colorWithHex:(unsigned long)0x000000 alpha:(CGFloat)0.f];
    XCTAssertEqualObjects(black1, black2);

    UIColor *red1   = [UIColor colorWithRed:(CGFloat)1.f green:0.f blue:0.f alpha:1.f];
    UIColor *red2   = [UIColor colorWithHex:(unsigned long)0xFF0000 alpha:(CGFloat)1.f];
    XCTAssertEqualObjects(red1, red2);

    UIColor *white3 = [UIColor colorWithHexString:@"0xFFFFFFFF"];
    XCTAssertEqualObjects(white1, white3);
    UIColor *white4 = [UIColor colorWithHexString:@"0xFFFFFF"];
    XCTAssertEqualObjects(white1, white4);

    UIColor *black3 = [UIColor colorWithHexString:@"0x00000000"];
    XCTAssertEqualObjects(black1, black3);
    UIColor *black4 = [UIColor colorWithHexString:@"0x000000"];
    XCTAssertNotEqualObjects(black1, black4);

    UIColor *red3   = [UIColor  colorWithHexString:@"0xFF0000FF"];
    XCTAssertEqualObjects(red1, red3);
    UIColor *red4 = [UIColor colorWithHexString:@"0xFF0000"];
    XCTAssertEqualObjects(red1, red4);
}

//- (void)testPerformanceExample {
//    [self measureBlock:^{
//    }];
//}

@end
