//
//  Model2ViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/5.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MajorityGraphView.h"
@interface Model2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *NextButton;

@property (strong, nonatomic) MajorityGraphView *MajorityGraphView;

@end
