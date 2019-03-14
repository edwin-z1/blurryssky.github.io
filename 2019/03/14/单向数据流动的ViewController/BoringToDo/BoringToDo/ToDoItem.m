//
//  ToDoItem.m
//  BoringToDo
//
//  Created by blurryssky on 2019/3/6.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import "ToDoItem.h"

@interface ToDoItem() <NSSecureCoding>

@end

@implementation ToDoItem

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeBool:_hasDone forKey:@"hasDone"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _hasDone = [aDecoder decodeBoolForKey:@"hasDone"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
