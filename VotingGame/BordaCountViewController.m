//
//  BordaCountViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/10.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "BordaCountViewController.h"
#import "AppDelegate.h"
#import "Applicant.h"
#import "Record.h"
#import "Voter.h"
#import <CoreData/CoreData.h>


@interface BordaCountViewController ()

@property (strong) NSMutableArray *voters;

@property (strong) NSMutableArray *applicants;

@property (strong) NSMutableArray *bCounts;

@end

@implementation BordaCountViewController

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
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];

//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    
//    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] initWithEntityName:@"Voter"];
//    
//    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"Applicant"];
    
    Record *record = appDelegate.record;
    
    self.voters = (NSMutableArray *) record.voter;
    
    self.applicants = (NSMutableArray *) record.applicant;
    
    self.bCounts = [NSMutableArray arrayWithCapacity:[self.applicants count]];
    
    
    NSMutableString *labelText = [NSMutableString stringWithFormat:@"In this game there are %d applicants, therefore there are %d ranks.", self.applicants.count, self.applicants.count];
    for (int j=0; j<self.applicants.count; j++) {
        [labelText appendFormat:@"\n\nRank %d counts %d. ", (j+1), (self.applicants.count-j-1)];
    }
    
    [self.text setText:labelText];
    
    
    for (int i=0; i<self.applicants.count; i++) {
        [self.bCounts addObject:[NSNumber numberWithInt:0]];
    }
    
    for (Voter *voter in self.voters) {
        NSString *pre = [voter valueForKey:@"preference"];
        NSArray *pres=[pre componentsSeparatedByString:@">"];
        for (int m=0; m<self.applicants.count; m++) {
            for (int n=0; n<self.applicants.count; n++) {
                Applicant *applicant = [[self applicants] objectAtIndex:n];
                if([[pres objectAtIndex:m]isEqualToString:[applicant valueForKey:@"aname"]]){
                    NSInteger bcount=[(NSNumber *)[self.bCounts objectAtIndex:n]intValue];
                    bcount=bcount+(self.applicants.count-m-1);
                    [self.bCounts replaceObjectAtIndex:n withObject:[NSNumber numberWithInt:bcount]];
                }
            }
        }
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applicants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BordaCount" forIndexPath:indexPath];
    NSInteger bcount= [(NSNumber*) [self.bCounts objectAtIndex:indexPath.row]intValue];
    
    NSManagedObjectModel *applicant= [self.applicants objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"The Borda count for %@ is",[applicant valueForKey:@"aname"]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d",bcount]];
    
    
    return cell;
}

- (IBAction)Determine:(id)sender {
    BOOL hasTheSameCount=FALSE;
    NSMutableString *Result = [[NSMutableString alloc]init];
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortedBcount = [self.bCounts sortedArrayUsingComparator:cmptr];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.applicants.count];
    [Result appendString: [NSString stringWithFormat:@"The final preference order is: "]];
    NSNumber *anotherCount =[[NSNumber alloc]init];
    for (NSNumber *bcount in sortedBcount) {
        if ([bcount integerValue]==[anotherCount integerValue]) {
            [[self Result]setText:@"There is no winner in this game."];
            hasTheSameCount=TRUE;
        }
        NSInteger index = [self.bCounts indexOfObject:bcount];
        Applicant *a=[self.applicants objectAtIndex:index];
        [resultArray addObject:a.aname];
        anotherCount = bcount;

    }
    NSString *finalPre =  [resultArray componentsJoinedByString:@" > "];
    
    [Result appendString:finalPre];
    if(!hasTheSameCount)
        [[self Result]setText:Result];
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
