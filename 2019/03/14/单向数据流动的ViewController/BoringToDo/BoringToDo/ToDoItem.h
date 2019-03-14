//
//  ToDoItem.h
//  BoringToDo
//
//  Created by blurryssky on 2019/3/6.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem : NSObject 

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL hasDone;

@end

NS_ASSUME_NONNULL_END
