//
//  YMNonArcTableViewController.m
//  MemoryIssues
//
//  Created by Александр О. Кургин on 15.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import "YMNonArcTableViewController.h"

typedef NS_ENUM(NSUInteger, YMModelRow)
{
    YMModelRowLeak,
    YMModelRowZombie,
    YMModelRowThird,
    YMModelRowCount
};

@interface YMNonArcTableViewController ()
{
    NSString *_previousSelectedTitle;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSString *importantMessage;

@end

@implementation YMNonArcTableViewController

- (void)dealloc
{
    [_previousSelectedTitle release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.items = @[@"item1", @"item2", @"item3"];
    self.importantMessage = [NSString stringWithFormat:@"Important message!"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return YMModelRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [self titleForModelRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    _previousSelectedTitle = [[self titleForModelRow:indexPath.row] retain];
    switch (indexPath.row) {
        case YMModelRowLeak:
            [self leak];
            break;

        case YMModelRowZombie:
            [self zombie];
            break;

        case YMModelRowThird:
            [self third];
            break;

        default:
            break;
    }
}


#pragma mark - Private

- (void)leak
{
    [self showAlertViewWithTitle:@"Warning" message:@"I'm alive"];
}

- (void)zombie
{
    [self showAlertViewWithTitle:@"Attention" message:self.importantMessage];
}

- (void)third
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *message = @"Hello";
    message = [message stringByAppendingString:@" big "];
    [pool release];

    message = [message stringByAppendingString:@" world"];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSString *)titleForModelRow:(YMModelRow)modelRow
{
    NSString *title = nil;
    switch (modelRow) {
        case YMModelRowLeak:
            title = @"Show warning message!";
            break;

        case YMModelRowZombie:
            title = @"Show attention message!";
            break;

        case YMModelRowThird:
            title = @"Construct message";
            break;

        default:
            title = @"Unknown";
            break;
    }
    return title;
}



@end
