//
//  MajorityGraphView.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/5.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MajorityGraphView : UIView

@property (assign) NSInteger number;

@property (strong,nonatomic) NSMutableArray *applicantsName;

@property (strong,nonatomic) NSMutableArray *voters;

@property (strong) NSMutableArray *mark;

@property (strong, nonatomic) UILabel *Label;

@end
