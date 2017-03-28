//
//  JLDatePickerView.h
//  KTFourPm
//
//  Created by afyylong on 2016/12/19.
//  Copyright © 2016年 afyylong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JLDatePickerMode) {
    JLDatePickerModeNomal,          //2017-11-19
    JLDatePickerModeYear,           //2017
    JLDatePickerModeYearAndMonth    //2017-11
    
};

@protocol JLDatePickerDelegate;


@interface JLDatePickerView : UIView

@property (nonatomic, readonly) JLDatePickerMode type;

@property (nonatomic, copy) NSString *time;
/** 月 */
@property (nonatomic, copy) NSString *str111;
/** 年 */
@property (nonatomic,copy) NSString *str222;
/** datepicker */
@property (nonatomic, strong) UIDatePicker *datePickerView;
/** pickerview */
@property (nonatomic, strong) UIPickerView *datePicker;

@property (weak, nonatomic) id<JLDatePickerDelegate> delegate;

+ (instancetype)pickerViewWithType:(JLDatePickerMode)type;

- (void)show;

- (void)dismiss;

- (void)showAnimated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

@end


@protocol JLDatePickerDelegate <NSObject>

- (void)JLDatePickerViewDidDismissWithConfirm:(JLDatePickerView *)pickerView string:(NSString *)string;

@optional
- (void)JLDatePickerViewDidDismissWithCancel:(JLDatePickerView *)pickerView;

@end


