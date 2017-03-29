//
//  JLDatePickerView.m
//  KTFourPm
//
//  Created by afyylong on 2016/12/19.
//  Copyright © 2016年 afyylong. All rights reserved.
//


#import "JLDatePickerView.h"

const CGFloat JLDatePickerViewBottomViewHeight = 216.0;
const CGFloat JLDatePickerViewButtonWidth = 64.0;
const CGFloat JLDatePickerViewButtonHeight = 35.0;

@interface JLDatePickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

/** 年份数组 */
@property (strong,nonatomic) NSMutableArray *yearArr;
/** 月份数组 */
@property (strong,nonatomic) NSMutableArray *monthArr;
/** 选择的时间 */
@property (strong,nonatomic) NSString *timeSelectedString;
@property (strong,nonatomic) NSString *yearStr;
@property (strong,nonatomic) NSString *monthStr;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation JLDatePickerView

- (instancetype)initWithFrame:(CGRect)frame type:(JLDatePickerMode)type {
    self = [super initWithFrame:frame];
    
    if (self) {
        _type = type;
        
        [self setupInit];
    }
    
    return self;
}

#pragma mark - Public
+ (instancetype)pickerViewWithType:(JLDatePickerMode)type {
    JLDatePickerView *view = [[JLDatePickerView alloc] initWithFrame:CGRectZero type:type];
    
    return view;
}

- (void)show {
    [self showAnimated:true];
}

- (void)showAnimated:(BOOL)animated {
    if (self.superview) {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    CGFloat bottomViewY = CGRectGetHeight([UIScreen mainScreen].bounds) - JLDatePickerViewBottomViewHeight;
    CGRect bottomFrame = CGRectMake(0, bottomViewY, CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight);
//
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^ {
            self.alpha = 1.0;
            _bottomView.frame = bottomFrame;
        }];
    } else {
        _bottomView.frame = bottomFrame;
        self.alpha = 1.0;
    }
}

- (void)dismiss {
    [self dismissAnimated:true];
}

- (void)dismissAnimated:(BOOL)animated {
    
    if (animated) {
        CGRect bottomFrame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight);
        
        [UIView animateWithDuration:0.3 animations:^ {
            self.alpha = 0.0;
            
            _bottomView.frame = bottomFrame;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - Private
- (void)setupInit {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    self.alpha = 0.0;
    
    [self setupMainView];
    
    [self setupBottomView];
    
//    [self setupPicker];
}

- (void)setupMainView {
    if (_mainView) {
        return;
    }
    _mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    _mainView.userInteractionEnabled = true;
    [self addSubview:_mainView];
    
    UITapGestureRecognizer *mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainTap:)];
    [_mainView addGestureRecognizer:mainTap];
}

- (void)setupBottomView {
    if (_bottomView) {
        return;
    }
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_bottomView];
    
    [self setupCancelAndConfirmButton];
}

//确定和取消按钮
- (void)setupCancelAndConfirmButton {
    
    UIColor *buttonTitleColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:1.0 alpha:1.0];
    
    // Cancel
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, JLDatePickerViewButtonWidth, JLDatePickerViewButtonHeight)];
    
    NSString *cancelText = @"取消";
    
    cancelButton.titleLabel.text = cancelText;
    [cancelButton setTitle:cancelText forState:UIControlStateNormal];
    [cancelButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Confirm
    CGFloat confirmButtonX = CGRectGetWidth([UIScreen mainScreen].bounds) - JLDatePickerViewButtonWidth;
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmButtonX, 0, JLDatePickerViewButtonWidth, JLDatePickerViewButtonHeight)];
    NSString *confirmText = @"确定";
    confirmButton.titleLabel.text = confirmText;
    [confirmButton setTitle:confirmText forState:UIControlStateNormal];
    [confirmButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:cancelButton];
    [_bottomView addSubview:confirmButton];
}


//设置初始时间
- (void)setTime:(NSString *)time {
    
    if (time.length > 5) {
        _str111 = [time substringFromIndex:6];
        _str222 = [time substringToIndex:4];
    }else {
        _str222 = time;
    }
    
    [self setupPicker];
    
}
//
- (void)setupPicker {
    if (_type == JLDatePickerModeNomal) {
        if (_datePicker) {
            return;
        }
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, JLDatePickerViewButtonHeight, CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight - JLDatePickerViewButtonHeight)];
        _datePickerView.datePickerMode = UIDatePickerModeDate;

        [_bottomView addSubview:_datePickerView];
        
        
    } else if (_type == JLDatePickerModeYearAndMonth) {
        if (_datePicker) {
            return;
        }
        //初始时间选择文字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM"];
        self.monthStr = [formatter stringFromDate:[NSDate date]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy"];
        self.yearStr = [formatter1 stringFromDate:[NSDate date]];
        self.timeSelectedString = [NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr];
        
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, JLDatePickerViewButtonHeight, CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight - JLDatePickerViewButtonHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
        [_bottomView addSubview:_datePicker];
        
        int a = [_str111 intValue];
        int b = [_str222 intValue];
        [self.datePicker selectRow:a-1 inComponent:1 animated:NO];
        [self.datePicker selectRow:b-1900 inComponent:0 animated:NO];

        
    }else if (_type == JLDatePickerModeYear) {
        if (_datePicker) {
            return;
        }
        
        //初始时间选择文字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM"];
        self.monthStr = [formatter stringFromDate:[NSDate date]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy"];
        self.yearStr = [formatter1 stringFromDate:[NSDate date]];
        self.timeSelectedString = [NSString stringWithFormat:@"%@",self.yearStr];
        
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, JLDatePickerViewButtonHeight, CGRectGetWidth([UIScreen mainScreen].bounds), JLDatePickerViewBottomViewHeight - JLDatePickerViewButtonHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
        [_bottomView addSubview:_datePicker];
        
        int b = [_str222 intValue];
        [self.datePicker selectRow:b-1900 inComponent:0 animated:NO];
    }
    
    
}

#pragma mrak -
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_type == JLDatePickerModeYearAndMonth) {
        return 2;
    }
    if (_type == JLDatePickerModeYear) {
        return 1;
    }
    return 1;
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.yearStr = self.yearArr[row];
    }else{
        self.monthStr = self.monthArr[row];
    }
    if (_type == JLDatePickerModeYearAndMonth) {
        self.timeSelectedString = [NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr];
    }else if (_type == JLDatePickerModeYear) {
        self.timeSelectedString = [NSString stringWithFormat:@"%@",self.yearStr];
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_type == JLDatePickerModeYearAndMonth) {
        if (component == 0) {
            return 400;
        }else {
            return 12;
        }
    }else if (_type == JLDatePickerModeYear) {
        return 400;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_type == JLDatePickerModeYearAndMonth) {
        if (component == 0) {
            return  self.yearArr[row];
        }else {
            return  self.monthArr[row];
        }
    }else if (_type == JLDatePickerModeYear) {
        return  self.yearArr[row];
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - 懒加载
/**
 月份

 @return 月份数组
 */
-(NSMutableArray *)monthArr{
    if (!_monthArr) {
        self.monthArr = [[NSMutableArray alloc]init];
        for (int i = 1; i<13; i++) {
            NSString *str;
            if ( i < 10) {
                str = [NSString stringWithFormat:@"%02d",i];
            }else {
                str = [NSString stringWithFormat:@"%d",i];
            }
            [self.monthArr addObject:str];
        }
    }
    return _monthArr;
}

/**
 最大和最小年份

 @return 数组
 */
-(NSMutableArray *)yearArr{
    if (!_yearArr) {
        self.yearArr = [[NSMutableArray alloc]init];
        for (int i = 1900; i<3000; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            
            [self.yearArr addObject:str];
        }
    }
    return _yearArr;
}

#pragma mark - Selector
- (void)mainTap:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        [self dismiss];
        
        if ([_delegate respondsToSelector:@selector(JLDatePickerViewDidDismissWithCancel:)]) {
            [_delegate JLDatePickerViewDidDismissWithCancel:self];
        }
    }
}

//取消
- (void)cancelClicked:(UIButton *)sender {
    [self dismiss];
    
    if ([_delegate respondsToSelector:@selector(JLDatePickerViewDidDismissWithCancel:)]) {
        [_delegate JLDatePickerViewDidDismissWithCancel:self];
    }
}

//确定
- (void)confirmClicked:(UIButton *)sender {
    [self dismiss];
    
    if ([_delegate respondsToSelector:@selector(JLDatePickerViewDidDismissWithConfirm:string:)]) {
        [_delegate JLDatePickerViewDidDismissWithConfirm:self string:self.timeSelectedString];
    }
}







@end
