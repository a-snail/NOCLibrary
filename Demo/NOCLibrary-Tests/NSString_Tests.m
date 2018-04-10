#import <XCTest/XCTest.h>
#import "NOCLibrary.h"


@interface NSString_Tests : XCTestCase
@end


@implementation NSString_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTime {
    CMTime timeCM  = CMTimeMake((int64_t)150000, (int32_t)1000);
    NSString *foo1 = [NSString timeFromCMTime:timeCM withHourPart:NO];
    NSString *bar1 = @"02:30";
    XCTAssertEqualObjects(foo1, bar1);

    foo1 = [NSString timeFromCMTime:timeCM withHourPart:YES];
    bar1 = @"0:02:30";
    XCTAssertEqualObjects(foo1, bar1);

    Float64 fltTime = 190.f;
    NSString *foo2  = [NSString timeFromSeconds:fltTime withHourPart:NO];
    NSString *bar2  = @"03:10";
    XCTAssertEqualObjects(foo2, bar2);

    foo2 = [NSString timeFromSeconds:fltTime withHourPart:YES];
    bar2 = @"0:03:10";
    XCTAssertEqualObjects(foo2, bar2);
}

- (void)testCompare {
    NSString *foo = @"Hello World!";
    XCTAssertTrue([foo isStartWithString:@"H"]);
    XCTAssertTrue([foo isStartWithString:@"Hello"]);

    XCTAssertFalse([@"" isStartWithString:@""]);
    XCTAssertFalse([foo isStartWithString:@""]);
    XCTAssertFalse([foo isStartWithString:@"h"]);
    XCTAssertFalse([foo isStartWithString:@"World"]);

    XCTAssertTrue([foo isStartWithString:@"Hello"  moreThanLength:(NSUInteger)0]);
    XCTAssertTrue([foo isStartWithString:@"Hello"  moreThanLength:(NSUInteger)3]);
    XCTAssertTrue([foo isStartWithString:@"Hello"  moreThanLength:(NSUInteger)7]);

    XCTAssertFalse([@"" isStartWithString:@""      moreThanLength:(NSUInteger)0]);
    XCTAssertFalse([foo isStartWithString:@""      moreThanLength:(NSUInteger)0]);
    XCTAssertFalse([foo isStartWithString:@"Hello" moreThanLength:(NSUInteger)8]);

    XCTAssertTrue([foo isEndWithString:@"!"]);
    XCTAssertTrue([foo isEndWithString:@"World!"]);

    XCTAssertFalse([@"" isEndWithString:@""]);
    XCTAssertFalse([foo isEndWithString:@""]);
    XCTAssertFalse([foo isEndWithString:@"D!"]);
    XCTAssertFalse([foo isEndWithString:@"Hello"]);

    XCTAssertTrue([foo isEndWithString:@"World!" moreThanLength:(NSUInteger)0]);
    XCTAssertTrue([foo isEndWithString:@"World!" moreThanLength:(NSUInteger)3]);
    XCTAssertTrue([foo isEndWithString:@"World!" moreThanLength:(NSUInteger)6]);

    XCTAssertFalse([@"" isEndWithString:@""       moreThanLength:(NSUInteger)0]);
    XCTAssertFalse([foo isEndWithString:@""       moreThanLength:(NSUInteger)0]);
    XCTAssertFalse([foo isEndWithString:@"World!" moreThanLength:(NSUInteger)7]);

    XCTAssertTrue([foo isEqualToString:@"Hello World!"]);
    XCTAssertTrue([foo isEqualToStringIgnoreCase:@"hello world!"]);

    XCTAssertFalse([foo isEqualToString:@"hello world!"]);
    XCTAssertFalse([foo isEqualToStringIgnoreCase:@"hello"]);
}

- (void)testRepeat {
    NSString *foo = @"Hello World!";
    XCTAssertEqualObjects([foo appendRepeatString:@"#"  withTimes:5], @"Hello World!#####");
    XCTAssertEqualObjects([foo appendRepeatString:@" #" withTimes:3], @"Hello World! # # #");

    XCTAssertEqualObjects([@"-=-" repeatTimes:5], @"-=--=--=--=--=-");
}

//- (void)testPerformanceExample {
//    [self measureBlock:^{
//    }];
//}

@end
