//
//  YMArcTableViewController.m
//  MemoryIssues
//
//  Created by Александр О. Кургин on 15.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import "YMArcTableViewController.h"
#import "YMActionItem.h"

@interface YMArcTableViewController ()

@property (nonatomic, strong) NSArray *actions;

@end

@implementation YMArcTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    [self loadActions];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                            forIndexPath:indexPath];
    YMActionItem *actionItem = self.actions[indexPath.row];
    cell.textLabel.text = actionItem.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YMActionItem *actionItem = self.actions[indexPath.row];
    if (actionItem.actionHandler != NULL) {
        actionItem.actionHandler();
    }
}


#pragma mark - Private

- (void)loadActions
{
    NSMutableArray *actions = [[NSMutableArray alloc] init];

    YMActionItem *firstActionItem =
    [[YMActionItem alloc] initWithTitle:@"Parse many data"
                                 action:^{
                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                         @autoreleasepool {
                                             NSURL *url = [NSURL URLWithString:@"https://money.yandex.ru/api/categories-list"];
                                             NSData *data = [NSData dataWithContentsOfURL:url];
                                             for (int i = 0; i < 10 ; i++) {
                                                 [self parseData:data iteration:100];
                                             }
                                         }
                                     });
                                 }];
    [actions addObject:firstActionItem];


    YMActionItem *secondActionItem =
    [[YMActionItem alloc] initWithTitle:@"Create operation"
                                 action:^{
                                     NSBlockOperation *operation = [[NSBlockOperation alloc] init];
                                     [operation addExecutionBlock:^{
                                         if ([operation isCancelled] == NO) {
                                             NSLog(@"Operation done");
                                         }
                                     }];
                                 }];

    [actions addObject:secondActionItem];


    YMActionItem *thirdActionItem =
    [[YMActionItem alloc] initWithTitle:@"Parse bad data"
                                 action:^{
                                     __autoreleasing NSError *error = nil;
                                     NSData *badData = [@"none" dataUsingEncoding:NSUTF8StringEncoding];
                                     [self parseData:badData error:&error];

                                     NSString *errorMessage = [error localizedDescription];
                                     NSLog(@"errorMessage %@", errorMessage);
                                 }];

    [actions addObject:thirdActionItem];


    self.actions = [actions copy];
}

- (void)parseData:(NSData *)data error:(NSError **)outError
{
    @autoreleasepool {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:outError];
        if (result == nil) {
            NSLog(@"error %@", [*outError localizedDescription]);
         }
    }
}

- (void)parseData:(NSData *)data iteration:(NSUInteger)iteration
{
    for (int i = 0; i < iteration; i++) {
        [self parseData:data];
    }
}

- (void)parseData:(NSData *)data
{
    if (data != nil) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        [self iterate:result];
    }
}

- (void)iterate:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        for (id obj in object) {
            [self iterate:obj];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [object allKeys];
        for (NSString *obj in keys) {
            [self iterate:object[obj]];
        }
    }
    else if ([object isKindOfClass:[NSString class]]) {
        NSString *temp = [NSString stringWithString:(NSString *)object];
        NSLog(@"%@", temp);
    }
}



@end
