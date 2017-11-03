//
//  Model2ViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/5.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "Model2ViewController.h"
#import <CoreData/CoreData.h>
#import "MajorityGraphView.h"
#import "AppDelegate.h"
#import "Record.h"
#import "Applicant.h"
#import "Voter.h"


@interface Model2ViewController ()


@property (strong, nonatomic) NSMutableArray *mark;

@property (strong) NSMutableArray *voters;

@property (strong) NSMutableArray *Applicants;

@property (strong, nonatomic) UILabel *Label;



@end

@implementation Model2ViewController


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
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Applicant"];
//    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"Voter"];

    CGRect labelRect = CGRectMake(20, 80, 740, 50);

    CGRect rect = [[self view] bounds];
    [self setMajorityGraphView:[[MajorityGraphView alloc] initWithFrame:rect]];
    [[self view] addSubview:[self MajorityGraphView]];
    
    [self setLabel:[[UILabel alloc] initWithFrame:labelRect]];
    [[self Label] setTextAlignment:NSTextAlignmentCenter];
    [[self Label] setFont:
     [UIFont fontWithName:@"American Typewriter" size:30]];
    [[self Label] setText:@"Majority Graph"];
    
    [[self MajorityGraphView] addSubview:[self Label]];
    [[self MajorityGraphView] addSubview:[self NextButton]];
    
    
    
  

    
    
    Record *record = appDelegate.record;
    
    self.Applicants =  [record.applicant mutableCopy];
    self.voters = (NSMutableArray *) record.voter;
    
    [[self MajorityGraphView] setNumber:self.Applicants.count];
    
    NSMutableArray *applicantsNames = [[NSMutableArray alloc] init];
    for (Applicant *a in self.Applicants) {
        [applicantsNames addObject:a.aname];
    }
    [[self MajorityGraphView] setApplicantsName:[NSMutableArray arrayWithArray:applicantsNames]];
    
    [[self MajorityGraphView] setVoters:self.voters];
    [[self MajorityGraphView] setBackgroundColor:[UIColor whiteColor]];
    
    //Initialize the mark array
    int n = (self.Applicants.count*(self.Applicants.count-1))/2;
    self.mark= [NSMutableArray arrayWithCapacity:n];
    int index=0;
    
    for (int i=0; i<self.Applicants.count-1; i++) {
        Applicant *applicant1 = [[self Applicants] objectAtIndex:i];
        //get the name of the first applicant
        NSString *name1= [applicant1 valueForKey:@"aname"];
        for (int j=i+1; j<self.Applicants.count; j++) {
            Applicant *applicant2 = [[self Applicants] objectAtIndex:j];
            //get the name of the second applicant
            NSString *name2= [applicant2 valueForKey:@"aname"];
            [self.mark addObject:[NSNumber numberWithInt:0]];
            NSInteger oneMark=[(NSNumber *)[self.mark objectAtIndex:index]intValue];
            //Traverse the preference orders
            for (Voter *voter in self.voters) {
                NSString *pre = [voter valueForKey:@"preference"];
                NSArray *pres=[pre componentsSeparatedByString:@">"];
                if ([pres indexOfObject:name1]<[pres indexOfObject:name2]) {
                    oneMark++;
                }
                else
                    oneMark--;
            }
            [self.mark replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:oneMark]];
            index++;
        }
    }
    
    
    [[self MajorityGraphView]setMark:[NSMutableArray arrayWithArray:self.mark]];
    
    appDelegate.mark = self.mark;
    
    for (NSNumber *oneMark in self.mark) {
        NSInteger aMark=oneMark.integerValue;
        if (aMark==0) {
            
            NSString *message= [NSString stringWithFormat:@"Cannot give you a complete majority graph."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Tell me why!"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^void (UIAlertAction *action) {
                                                        self.NextButton.enabled = NO;
                                                    }]];
            [[alert popoverPresentationController] setSourceView:[self view]];
            [[alert popoverPresentationController] setSourceRect:[self.view frame]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
