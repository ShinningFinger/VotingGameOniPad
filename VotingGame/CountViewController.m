//
//  CountViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/30.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "CountViewController.h"

#import <CoreData/CoreData.h>

#import "Applicant.h"

#import "AppDelegate.h"

#import "OutComeViewController.h"

#import "ManipulationViewController.h"

@interface CountViewController ()

//@property (strong) NSMutableArray *preferences;
@property (strong,nonatomic) NSMutableArray *voters;

@property (strong ,nonatomic) NSMutableArray *applicants;

@property (strong ,nonatomic) NSMutableArray *counts;

@property (strong, nonatomic) Applicant *winner;

@property (strong,nonatomic) NSMutableArray *possibleWinner;
@end

@implementation CountViewController

-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.possibleWinner=[NSMutableArray arrayWithCapacity:0];
    
}

-(void)viewDidAppear:(BOOL)animated {
    self.ManipulationButton.enabled=NO;

    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
    Record *record =appDelegate.record;
    self.voters = (NSMutableArray *) record.voter;
    
    self.applicants = (NSMutableArray *) record.applicant;
    self.counts = [NSMutableArray arrayWithCapacity:[self.applicants count]];
    
    
    for (int i=0; i<self.applicants.count; i++) {
        NSMutableArray *countArray =[NSMutableArray arrayWithCapacity:[self.applicants count]];
        for (int j=0; j<self.applicants.count; j++) {
            [countArray addObject:[NSNumber numberWithInt:0]];
        }
        [self.counts addObject:countArray];
    }
    
    for (int j=0; j<self.applicants.count; j++) {
        NSMutableArray *oneCount = [self.counts objectAtIndex:j];
        
        for (Voter *voter in self.voters) {
            
            NSString *pre = [voter valueForKey:@"preference"];
            //Transfer the voter preference into the preference array
            NSArray *pres=[pre componentsSeparatedByString:@">"];
            
            for (int m=0; m<self.applicants.count; m++) {
                Applicant *applicant = [[self applicants] objectAtIndex:m];
                if ([[pres objectAtIndex:j]isEqualToString:[applicant valueForKey:@"aname"]]) {
                    
                    NSInteger count=[(NSNumber *)[oneCount objectAtIndex:m]intValue];
                    count++;
                    [oneCount replaceObjectAtIndex:m withObject:[NSNumber numberWithInt:count]];
                }
            }
        }
        [self.counts replaceObjectAtIndex:j withObject:oneCount];
    }
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.applicants.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.applicants.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicantCountCell" forIndexPath:indexPath];
    
    
    NSMutableArray *oneCount=[self.counts objectAtIndex:indexPath.section];
    
    NSInteger count= [(NSNumber*) [oneCount objectAtIndex:indexPath.row]integerValue];
    Applicant *applicant= [self.applicants objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ counts",[applicant valueForKey:@"aname"]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d times",count]];
    NSLog(@"Candidate: %@ counts: %d times",applicant.aname,count );

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section  {
    
    int a = (int)section+1;
    return [NSString stringWithFormat:@"Rank %d",a ];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Manipulation"]) {
        ManipulationViewController *VC = segue.destinationViewController;
        VC.possibleWinner=self.possibleWinner;
    }
    
    if ([[segue identifier] isEqualToString:@"GetOutCome"]) {
       
        OutComeViewController *VC = segue.destinationViewController;
        
        NSMutableArray *RankFirst=[self.counts objectAtIndex:0];
        
        
        NSInteger i = [RankFirst indexOfObject:[RankFirst valueForKeyPath:@"@max.integerValue"]];
        
        self.winner = [self.applicants objectAtIndex:i];
        
        int count=0;
        int n = self.applicants.count;
        
        for (int i = 0; i<n; i++  ){
            NSNumber *c = [RankFirst objectAtIndex:i];
            NSInteger C =[c integerValue];
            if (C == [[RankFirst valueForKeyPath:@"@max.integerValue"] integerValue] ){
                [self.possibleWinner addObject:[self.applicants objectAtIndex:i]];
                count++;
            }
        }
        
        if (count>1) {
            VC.HaveWinner =false;
            if (count!=self.applicants.count)
                self.ManipulationButton.enabled=YES;
        }
        else{
            VC.HaveWinner =true;
            VC.winner = self.winner;
 
        }
    }
    
    
}

@end
