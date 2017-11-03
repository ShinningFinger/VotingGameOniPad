//
//  BordaCountViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/10.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BordaCountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *text;
- (IBAction)Determine:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Result;

@end
