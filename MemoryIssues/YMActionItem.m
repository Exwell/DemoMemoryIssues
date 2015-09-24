//
//  YMActionItem.m
//  MemoryIssues
//
//  Created by Александр О. Кургин on 15.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import "YMActionItem.h"

@implementation YMActionItem

- (instancetype)initWithTitle:(NSString *)title action:(dispatch_block_t)actionHandler
{
    self = [super init];
    if (self != nil) {
        _actionHandler = [actionHandler copy];
        _title = [title copy];
    }
    return self;
}

@end
