//
//  YMActionItem.h
//  MemoryIssues
//
//  Created by Александр О. Кургин on 24.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMActionItem : NSObject

@property (nonatomic, readonly, copy) dispatch_block_t actionHandler;
@property (nonatomic, readonly, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title action:(dispatch_block_t)actionHandler;

@end
