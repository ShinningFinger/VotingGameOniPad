//
//  OutComeViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/17.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Applicant.h"

@interface OutComeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *OutComeLabel;
- (IBAction)Back:(id)sender;

@property BOOL HaveWinner;
@property (strong,nonatomic) Applicant *winner;


@end
