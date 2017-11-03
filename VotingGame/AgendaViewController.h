//
//  AgendaViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/13.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *ResultText;

- (IBAction)RuntheGame:(id)sender;
- (IBAction)determine:(id)sender;
- (IBAction)CallGraph:(id)sender;

@end
