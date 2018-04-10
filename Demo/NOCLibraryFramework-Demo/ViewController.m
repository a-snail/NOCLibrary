#import "ViewController.h"
#import <NOCLibraryFramework/NOCLibrary.h>
#define LOGLEVEL 31
#import "NOCLog.h"


@interface ViewController ()
@end


@implementation ViewController {
    NSArray *itemsTest;
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate overrides

- (void)tableView:(nonnull UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];

    switch (indexPath.row) {
        case 0:
            [self test01];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource overrides

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *idReuse = @"TestItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idReuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:idReuse];
    }

    [cell.textLabel setText:[itemsTest objectAtIndex:indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return itemsTest.count;
}

#pragma mark - Table initialize

- (void)initTable {
    itemsTest = @[
                  @"Check URL Scheme"
                  ];

    [_tblTestItems setAllowsSelection:YES];
    [_tblTestItems setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

#pragma mark - Tests

- (void)test01 {
    NSBundle *bundle = NSBundle.mainBundle;
    NOCLogI(@"URLScheme : %@", [bundle bundleURLScheme:nil]);
    NOCLogI(@"URLScheme : %@", [bundle bundleURLScheme:@"nd1"]);
    NOCLogI(@"URLScheme : %@", [bundle bundleURLScheme:@"nd2"]);

    NOCLogI(@"Available : %d", [bundle availableScheme:@"http"]);
    NOCLogI(@"Available : %d", [bundle availableScheme:@"noc-demo1"]);
    NOCLogI(@"Available : %d", [bundle availableScheme:@"noc-demo2"]);
}

@end
