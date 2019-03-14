//
//  ViewController.m
//  BoringToDo
//
//  Created by blurryssky on 2019/3/6.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+UserDefaults.h"
#import "ToDoTableCell.h"

#define DATA_PATH ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ToDoItems"])

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ToDoTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *leftBarItemSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarItem;

@property (nonatomic, strong, nullable) NSMutableArray<ToDoItem *> *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_leftBarItemSwitch setOn:self.canSwitchOn animated:YES];
    [self addRefreshControl];
    [_tableView.refreshControl beginRefreshing];
    [_tableView.refreshControl sendActionsForControlEvents:(UIControlEventValueChanged)];
}

#pragma mark - Private

- (void)addRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(loadToDoItems) forControlEvents:(UIControlEventValueChanged)];
    _tableView.refreshControl = refreshControl;
}

- (void)loadToDoItems {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
        NSData *archivedData = [NSData dataWithContentsOfFile:DATA_PATH];
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [ToDoItem class], [NSDate class]]];
        self.items = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:archivedData error:nil];
        if (self.items == nil) {
            self.items = [NSMutableArray array];
        }
        [self updateTitle];
        [self.tableView reloadData];
    });
}

- (void)updateTitle {
    NSInteger count = 0;
    for (ToDoItem *item in _items) {
        if (!item.hasDone) {
            count ++;
        }
    }
    self.title = [NSString stringWithFormat:@"ToDoList(%ld)", (long)count];
    if (count == 0) {
        self.title = @"ToDoList";
    }
}

- (void)saveToDoItems {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_items requiringSecureCoding:YES error:nil];
    [archivedData writeToFile:DATA_PATH atomically:YES];
}

#pragma mark - Action

- (IBAction)handleLeftBarItemSwitch:(UISwitch *)sender {
    self.canSwitchOn = sender.isOn;
}

- (IBAction)handleAddBarItem:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"添加一个待办事项";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self createToDoItem:weakAlert.textFields.firstObject.text];
        [self saveToDoItems];
        [self updateTitle];
        [self.tableView reloadData];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createToDoItem:(NSString *)title {
    ToDoItem *item = [ToDoItem new];
    item.title = title;
    item.date = [NSDate date];
    item.hasDone = NO;
    [_items addObject:item];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ToDoTableCell class])];
    cell.item = _items[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_items removeObjectAtIndex:indexPath.row];
        [self saveToDoItems];
        [self updateTitle];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ToDoTableCellDelegate

- (void)toDoTableCell:(ToDoTableCell *)cell item:(ToDoItem *)item didChangeSwitch:(BOOL)isOn {
    item.hasDone = isOn;
    if (!self.canSwitchOn && isOn) {
        item.hasDone = NO;
    }
    cell.item = item;
    [self saveToDoItems];
    [self updateTitle];
}

@end
