//
//  YLCalendarPickerView.m
//  CalendarPicker
//
//  Created by 余亮 on 16/2/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "YLCalendarPickerView.h"
#import "UIColor+ZXLazy.h"
#import "CalendarViewCell.h"


NSString * const YLCalendarCellIdentifier = @"CalendarCell";

@interface YLCalendarPickerView ()
@property (weak, nonatomic) IBOutlet UIButton *PreButton;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (weak, nonatomic) IBOutlet UILabel *MonthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionV;
@property (nonatomic,strong) NSArray * weekDayArray ;
@property (nonatomic,strong) UIView * mask ;

@end

@implementation YLCalendarPickerView

- (void)drawRect:(CGRect)rect
{
    [self addTap];
    [self addSwipe];
    [self show];
}

- (void)awakeFromNib
{
    [_CollectionV registerClass:[CalendarViewCell class] forCellWithReuseIdentifier:YLCalendarCellIdentifier];
//    UINib * nib = [UINib nibWithNibName:@"YLCalendarPickerView" bundle:nil];
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (void) customInterface
{
    CGFloat itemWidth = _CollectionV.frame.size.width / 7;
    CGFloat itemHeight = _CollectionV.frame.size.height / 7 ;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0 ;
    layout.minimumInteritemSpacing = 0;
    [_CollectionV setCollectionViewLayout:layout animated:YES];
}

- (void)setDate:(NSDate *)date
{
    _date = date ;
    [_MonthLabel setText:[NSString stringWithFormat:@"%.2ld-%li",(long)[self month:date],(long)[self year:date]]];
    [_CollectionV reloadData];
}




- (IBAction)PreButtonClick:(UIButton *)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.date = [self lastMonth:self.date];
    } completion:nil];
    
}
- (IBAction)NextButtonClick:(UIButton *)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.date = [self nextMonth:self.date];
    } completion:nil];
    
}

- (void) addTap
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}

- (void) hide
{
    [UIView animateWithDuration:0.5 animations:^(void){
        self.transform = CGAffineTransformTranslate(self.transform, 0,  - self.frame.size.height);
        self.mask.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void) addSwipe
{
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NextButtonClick:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
    [self addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(PreButtonClick:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight ;
    [self addGestureRecognizer:swipeRight];
}

- (void) show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, -self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void){
        self.transform = CGAffineTransformIdentity ;
    } completion:^(BOOL finished) {
        [self customInterface];
    }];
    
}



+ (instancetype) showOnView:(UIView *)view
{
    YLCalendarPickerView * calendarPickerV = [[[NSBundle mainBundle] loadNibNamed:@"YLCalendarPickerView" owner:self options:nil] firstObject];
    calendarPickerV.mask = [[UIView alloc] initWithFrame:view.bounds];
    calendarPickerV.mask.backgroundColor = [UIColor blackColor];
    calendarPickerV.mask.alpha = 0.3 ;
    [view addSubview:calendarPickerV.mask];
    [view addSubview:calendarPickerV];
    return calendarPickerV ;
}

#pragma mark -  date 
- (NSInteger)day:(NSDate *)date {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return  [components day];
}

- (NSInteger)month:(NSDate *)date
{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return  [components month];
}

- (NSInteger)year:(NSDate *)date
{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return  [components year];
}

- (NSInteger) firstWeekdayInThisMonth:(NSDate *)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];  //1.Sun
    NSDateComponents * component = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate * firstdayOfMonthDate = [calendar dateFromComponents:component];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstdayOfMonthDate];
    return firstWeekday - 1 ;
    
}

//当前月的所有天数
- (NSInteger) totaldaysInThisMonth:(NSDate *)date
{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length ;
}

//某个月的所有天数
- (NSInteger) totaldaysInMonth:(NSDate *)date
{
    NSRange daysInMonth = [[NSCalendar currentCalendar ] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInMonth.length ;
    
}

// -1 代表上个月
- (NSDate *)lastMonth:(NSDate *)date
{
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1 ;
    NSDate * newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate ;
}

//+1 代表下个月
- (NSDate *)nextMonth:(NSDate *)date
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.month = +1 ;
    NSDate * newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return newDate ;
}

#pragma mark  -  UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2 ;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count ;
    }else{
        return 42 ;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YLCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0 ) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#15cc9c"]];
    }else{
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];

        NSInteger day = 0 ;
        NSInteger i = indexPath.row ;
        
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
        }else{
            day = i - firstWeekday + 1 ;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li", (long)day]];
            [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];

            
            //this month
            if ([_todayDate isEqualToDate:_date ]) {
                if (day == [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#4898eb"]]; //当前日期
                }else if (day > [self day:_date]){
                    [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];//即将到来的日期
                }
            }else if ([_todayDate compare:_date] == NSOrderedAscending){
                [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
            }
        }
    }
    return cell ;
}



- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 ) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0 ;
        NSInteger i = indexPath.row ;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            
            //this month
            if ([_todayDate isEqualToDate:_date]) {
                if (day <= [self day:_date]) {
                    return YES ;
                }
            }else if ([_todayDate compare:_date] == NSOrderedDescending){
                return YES ;
            }
        }
    }
    return NO ;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear |  NSCalendarUnitMonth | NSCalendarUnitDay  ) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0 ;
    NSInteger i = indexPath.row ;
    day = i - firstWeekday + 1 ;
    if (self.calendarBlock) {   //Block调用
        self.calendarBlock(day,[components month],[components year]) ;
    }
    
    [self hide ];
}


@end






































