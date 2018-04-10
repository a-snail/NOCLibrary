#import <XCTest/XCTest.h>
#import "NOCLibrary.h"


@interface NSURL_Tests : XCTestCase
@end


@implementation NSURL_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testQuery {
    NSURL *url1 = [NSURL URLWithString:@"http://www.sample.com/test"];
    NSDictionary *queries1 = url1.queries;
    NSDictionary *expect1  = @{};
    XCTAssertEqualObjects(queries1, expect1);

    NSURL *url2 = [NSURL URLWithString:@"http://www.sample.com/test?k1=v1"];
    NSDictionary *queries2 = url2.queries;
    NSDictionary *expect2  = @{@"k1": @"v1"};
    XCTAssertEqualObjects(queries2, expect2);

    NSURL *url3 = [NSURL URLWithString:@"http://www.sample.com/test?k1=v1&k2=v2&k3=v3"];
    NSDictionary *queries3 = url3.queries;
    NSDictionary *expect3  = @{@"k1": @"v1",
                               @"k2": @"v2",
                               @"k3": @"v3"};
    XCTAssertEqualObjects(queries3, expect3);

    NSURL *url4 = [NSURL URLWithString:@"http://www.sample.com/test?k1=v1&k2=v2=v3"];
    NSDictionary *queries4 = url4.queries;
    NSDictionary *expect4  = @{@"k1": @"v1",
                               @"k2": @"v2=v3"};
    XCTAssertEqualObjects(queries4, expect4);
}

//- (void)testPerformanceExample {
//    [self measureBlock:^{
//    }];
//}

@end
