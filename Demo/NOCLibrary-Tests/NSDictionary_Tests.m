#import <XCTest/XCTest.h>
#import "NOCLibrary.h"


@interface NOCLibrary_Tests : XCTestCase
@end


@implementation NOCLibrary_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExtend {
    NSDictionary *foo1 = @{@"a": @"1", @"b": @"2"};
    NSDictionary *bar1 = @{@"c": @"3", @"d": @"4"};
    NSDictionary *res1 = @{@"a": @"1", @"b": @"2", @"c": @"3", @"d": @"4"};
    XCTAssertEqualObjects([foo1 extend:bar1 overwrite:NO], res1);

    NSDictionary *foo2 = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    NSDictionary *bar2 = @{@"c": @"C", @"d": @"D", @"z": @"Z"};
    NSDictionary *res2 = @{@"a": @"1", @"b": @"2", @"c": @"3", @"d": @"D", @"z": @"Z"};
    XCTAssertEqualObjects([foo2 extend:bar2 overwrite:NO], res2);

    NSDictionary *foo3 = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    NSDictionary *bar3 = @{@"c": @"C", @"d": @"D", @"z": @"Z"};
    NSDictionary *res3 = @{@"a": @"1", @"b": @"2", @"c": @"C", @"d": @"D", @"z": @"Z"};
    XCTAssertEqualObjects([foo3 extend:bar3 overwrite:YES], res3);
}

- (void)testExtendStatic {
    NSDictionary *foo1 = @{@"a": @"1", @"b": @"2"};
    NSDictionary *bar1 = @{@"c": @"3", @"d": @"4"};
    NSDictionary *res1 = @{@"a": @"1", @"b": @"2", @"c": @"3", @"d": @"4"};
    XCTAssertEqualObjects([NSDictionary extend:foo1 withDictionary:bar1 overwrite:NO], res1);

    NSDictionary *foo2 = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    NSDictionary *bar2 = @{@"c": @"C", @"d": @"D", @"z": @"Z"};
    NSDictionary *res2 = @{@"a": @"1", @"b": @"2", @"c": @"3", @"d": @"D", @"z": @"Z"};
    XCTAssertEqualObjects([NSDictionary extend:foo2 withDictionary:bar2 overwrite:NO], res2);

    NSDictionary *foo3 = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    NSDictionary *bar3 = @{@"c": @"C", @"d": @"D", @"z": @"Z"};
    NSDictionary *res3 = @{@"a": @"1", @"b": @"2", @"c": @"C", @"d": @"D", @"z": @"Z"};
    XCTAssertEqualObjects([NSDictionary extend:foo3 withDictionary:bar3 overwrite:YES], res3);
}

- (void)testExistsKey {
    NSDictionary *foo = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    XCTAssertTrue([foo existsKey:@"a"]);
    XCTAssertFalse([foo existsKey:@"d"]);
    XCTAssertFalse([foo existsKey:@"A"]);
}

- (void)testExistsKeyIgnoreCase {
    NSDictionary *foo = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    XCTAssertTrue([foo existsKeyIgnoreCase:@"a"]);
    XCTAssertTrue([foo existsKeyIgnoreCase:@"A"]);
    XCTAssertFalse([foo existsKeyIgnoreCase:@"d"]);
}

- (void)testObjectForKeyIgnoreCase {
    NSDictionary *foo = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    XCTAssertNil([foo objectForKeyIgnoreCase:@"D"]);
    XCTAssertEqual([foo objectForKeyIgnoreCase:@"a"], @"1");
    XCTAssertEqual([foo objectForKeyIgnoreCase:@"A"], @"1");
}

- (void)testValueForKeyIgnoreCase {
    NSDictionary *foo = @{@"a": @"1", @"b": @"2", @"c": @"3"};
    XCTAssertNil([foo valueForKeyIgnoreCase:@"D"]);
    XCTAssertEqual([foo valueForKeyIgnoreCase:@"a"], @"1");
    XCTAssertEqual([foo valueForKeyIgnoreCase:@"A"], @"1");
}

//- (void)testPerformanceExample {
//    [self measureBlock:^{
//    }];
//}

@end
