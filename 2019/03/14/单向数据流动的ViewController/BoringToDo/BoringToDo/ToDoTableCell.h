//
//  ToDoTableCell.h
//  BoringToDo
//
//  Created by blurryssky on 2019/3/6.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ToDoTableCell;
@protocol ToDoTableCellDelegate <NSObject>

@optional
- (void)toDoTableCell:(ToDoTableCell *)cell item:(ToDoItem *)item didChangeSwitch:(BOOL)isOn;

@end

@interface ToDoTableCell : UITableViewCell

@property (nonatomic, assign, nullable) id<ToDoTableCellDelegate> delegate;
@property (nonatomic, strong) ToDoItem *item;

@end

NS_ASSUME_NONNULL_END
