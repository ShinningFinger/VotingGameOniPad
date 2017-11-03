//
//  ApplicantTableViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "ApplicantTableViewController.h"

#import "AppDelegate.h"

#import "AddApplicantViewController.h"

#import "VoterTableViewController.h"

#import "Applicant.h"


#import <CoreData/CoreData.h>

@interface ApplicantTableViewController ()

@property (strong,nonatomic) NSMutableArray *Applicants;

@property (strong,nonatomic) NSMutableArray *voters;

@property (strong,nonatomic) NSMutableArray *Records;


@end

@implementation ApplicantTableViewController


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
    self.record = appDelegate.record;
    self.Applicants = (NSMutableArray *)self.record.applicant ;
    self.voters = (NSMutableArray *) self.record.voter;
    [self updateStatusLabel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//      self.navigationItem.leftBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated {
    
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Applicant"];
    
    //    self.Applicants= [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
 
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.Applicants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicantCell" forIndexPath:indexPath];
    Applicant *applicant = (Applicant *)[self.Applicants objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",applicant.aname]];
    [self updateStatusLabel];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.voters.count !=0){
               NSString *message= [NSString stringWithFormat:@"You are deleting an candidate. Please change the preference order for each voter."];
            [self displayErrorMessage:message :nil];
        }
        [context deleteObject:[self.Applicants objectAtIndex:indexPath.row]];;
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateStatusLabel];
    }
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"UpdateApplicant"]) {
        Applicant *SelectedApplicant = [self.Applicants objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        AddApplicantViewController *addApplicantView = segue.destinationViewController;
        addApplicantView.applicant = SelectedApplicant;
    }
}


- (IBAction)Next:(id)sender {
    
    if (self.Applicants.count==0) {
        NSString *message= [NSString stringWithFormat:@"You need set some candidates before playing this game!"];
        [self displayErrorMessage:message :sender];
            }
    if (self.Applicants.count==1) {
        NSString *message= [NSString stringWithFormat:@"No voting games contain only one candidate, please add more candidates!"];
        [self displayErrorMessage:message :sender];
    }

}


- (void) updateStatusLabel{
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:16.0],NSFontAttributeName,
                                   [UIColor darkGrayColor],NSForegroundColorAttributeName,
                                   nil];
    NSString *statusText =@"Hi, guys. This is the page for adding new candidates and setting names for them. Each candidate will take part in the following voting games. So you need to build enough candidates for the games.";
    NSAttributedString *displayText = [[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
    
    if (self.Applicants.count ==1) {
        
        statusText =[statusText stringByAppendingString:@"\n\nNow we have one candidate, but no voting game contains only one candidate. Add more candidates and press next button to conduct next step. "];
        displayText =[[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
        [self.StatusText setAttributedText:displayText];
    }
    else if(self.Applicants.count == 2){
        statusText = [statusText stringByAppendingString:@"\n\nNow we have two candidates, this time we can play the single pairwise election. Add more candidates if you want to play a general voting game. "];
        displayText =[[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
        [self.StatusText setAttributedText:displayText];
    }
    else if(self.Applicants.count >2){
        statusText = [statusText stringByAppendingString:@"\n\nYou have set enough candidates. You can add more candidates or press next to set the voter information."];
        displayText =[[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
        [self.StatusText setAttributedText:displayText];
    }
    [self.StatusText setFrame:CGRectMake(8, 770-self.Applicants.count*60, 752, 109)];
    [self.StatusText setAttributedText:displayText];
    
}


-(void)displayErrorMessage: (NSString *)message :(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                            }]];
    [[alert popoverPresentationController] setSourceView:[self view]];
    [[alert popoverPresentationController] setSourceRect:[sender frame]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
