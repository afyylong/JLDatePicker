//
//  ViewController.m
//  JLDatePicker
//
//  Created by afyylong on 2017/3/28.
//  Copyright © 2017年 afyylong. All rights reserved.
//

#import "ViewController.h"
#import "JLDatePickerView.h"

@interface ViewController ()<JLDatePickerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(UIButton *)sender {
    
    /*只显示年
     JLDatePickerView *picker = [JLDatePickerView pickerViewWithType:JLDatePickerModeYear];
     picker.delegate = self;
     NSDateFormatter *formatter = [NSDateFormatter new];
     [formatter setDateFormat:@"YYYY"];
     picker.time = [formatter stringFromDate:[NSDate date]];
     [picker show];
     */
    //显示年月
     JLDatePickerView *picker = [JLDatePickerView pickerViewWithType:JLDatePickerModeYearAndMonth];
     picker.delegate = self;
     NSDateFormatter *formatter = [NSDateFormatter new];
     [formatter setDateFormat:@"YYYY-MM"];
    //当前月
     picker.time = [formatter stringFromDate:[NSDate date]];
     [picker show];
    
    
    /*
    //年月日
    JLDatePickerView *picker = [JLDatePickerView pickerViewWithType:JLDatePickerModeNomal];
    picker.delegate = self;
    //不需要些内容
    picker.time = @"";
    picker.datePickerView.datePickerMode = UIDatePickerModeDate;
    [picker show];
    */
    
}

- (void)JLDatePickerViewDidDismissWithConfirm:(JLDatePickerView *)pickerView string:(NSString *)string {
    if (pickerView.type == JLDatePickerModeYear || pickerView.type == JLDatePickerModeYearAndMonth || pickerView.type == JLDatePickerModeNomal) {
        [_dateBtn setTitle:string forState:UIControlStateNormal];
        
    }
}

@end
