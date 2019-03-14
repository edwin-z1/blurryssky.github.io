//
//  ViewController+UserDefaults.m
//  BoringToDo
//
//  Created by blurryssky on 2019/3/11.
//  Copyright © 2019 blurryssky. All rights reserved.
//

#import "ViewController+UserDefaults.h"

#define UserDefaultsKeyCanSwitchOn @"canSwitchOn"

@implementation ViewController (UserDefaults)

- (BOOL)canSwitchOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsKeyCanSwitchOn];;
}

- (void)setCanSwitchOn:(BOOL)canSwitchOn {
    [[NSUserDefaults standardUserDefaults] setBool:canSwitchOn forKey:UserDefaultsKeyCanSwitchOn];
}

@end
