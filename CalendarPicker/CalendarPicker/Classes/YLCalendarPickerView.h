//
//  YLCalendarPickerView.h
//  CalendarPicker
//
//  Created by 余亮 on 16/2/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLCalendarPickerView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSDate * date ;

@property(nonatomic,strong) NSDate * todayDate ;

@property(nonatomic,copy) void (^calendarBlock)(NSInteger day, NSInteger month, NSInteger year) ;

+(instancetype) showOnView:(UIView *)view ;

@end
