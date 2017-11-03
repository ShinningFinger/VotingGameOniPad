//
//  Model2OutcomeViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/19.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Model2OutcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong,nonatomic) NSString *result;
- (IBAction)cancel:(id)sender;

@end
