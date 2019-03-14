//
//  ToDoTableCell.m
//  BoringToDo
//
//  Created by blurryssky on 2019/3/6.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import "ToDoTableCell.h"

@interface ToDoTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *doneSwitch;

@end

@implementation ToDoTableCell

#pragma mark - Override

- (void)setItem:(ToDoItem *)item {
    _item = item;
    [self update];
}

#pragma mark - Private

- (void)update {
    _titleLabel.text = _item.title;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    _dateLabel.text = [formatter stringFromDate:_item.date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.doneSwitch setOn:self.item.hasDone animated:YES];
    });
}

- (IBAction)handleSwitch:(UISwitch *)sender {
    
    if (_delegate) {
        [_delegate toDoTableCell:self item:_item didChangeSwitch:sender.isOn];
    }
}

@end
