//
//  ViewController.m
//  CalendarPicker
//
//  Created by 余亮 on 16/2/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "ViewController.h"
#import "YLCalendarPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)btnClick:(UIButton *)sender {
    YLCalendarPickerView * calendarPickerV = [YLCalendarPickerView showOnView:self.view ];
    calendarPickerV.todayDate = [NSDate date];
    calendarPickerV.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPickerV.calendarBlock = ^(NSInteger day, NSInteger month,NSInteger yesr){
        NSLog(@"%li-%li-%li",(long)yesr ,(long)month,(long)day);
    };
}

@end






















