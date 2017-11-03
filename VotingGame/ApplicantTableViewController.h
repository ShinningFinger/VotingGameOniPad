//
//  ApplicantTableViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Record.h"

@protocol UIViewPassValueDelegate
- (void)passValue:(Record *)value;
@end

@interface ApplicantTableViewController : UITableViewController

@property (strong) Record *record;

- (IBAction)Next:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *StatusText;


@end
