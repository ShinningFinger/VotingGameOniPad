//
//  VoterTableViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "VoterTableViewController.h"

#import "AddVoterViewController.h"

#import "Applicant.h"

#import "AppDelegate.h"

#import "Record.h"

#import "Voter.h"

#import <CoreData/CoreData.h>


@interface VoterTableViewController ()

@property (strong) NSMutableArray *voters;

@property (strong) NSMutableArray *applicants;

@property (strong) NSMutableArray *records;


@end

@implementation VoterTableViewController{
    NSMutableArray *preferences;
    }


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
    [self updateStatusLabel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Voter"];
//    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"Applicant"];
//    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
//    self.records= [[managedObjectContext executeFetchRequest:fetchRequest3 error:nil] mutableCopy];
    Record *record = appDelegate.record;
    self.voters = (NSMutableArray *)record.voter;
    self.applicants = (NSMutableArray *)record.applicant;

    
//    self.voters= [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    self.applicants= [[managedObjectContext executeFetchRequest:fetchRequest2 error:nil] mutableCopy];

    
    preferences=[NSMutableArray arrayWithCapacity:self.voters.count];
    
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
    return self.voters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIndenifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndenifier forIndexPath:indexPath];
    
    Voter *voter = [self.voters objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[voter valueForKey:@"name"]]];
   
    
    [cell.detailTextLabel setText:[voter valueForKey:@"preference"]];

    [preferences addObject:cell.detailTextLabel.text ];
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
        [context deleteObject:[self.voters objectAtIndex:indexPath.row]];;
        
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

- (IBAction)Next:(id)sender {
    
    for (NSString *preference in preferences) {
        NSArray *pres=[preference componentsSeparatedByString:@">"];
        if(pres.count!=self.applicants.count){
            NSString *message= [NSString stringWithFormat:@"There is a new candidate. Please change the preference order."];
            [self displayErrorMessage:message :sender];
        }
        for (Applicant *appplicant in self.applicants){
            NSString *applicantName = appplicant.aname;
            if (![pres containsObject:applicantName]) {
                NSString *message= [NSString stringWithFormat:@"One candidate's name has been updated, please check the candidate list and change the preference order."];
                [self displayErrorMessage:message :sender];

            }
        }
    }

if (self.voters.count==0) {
        NSString *message= [NSString stringWithFormat:@"You need set some voters before playing this game!"];
        [self displayErrorMessage:message :sender];
    }
    if (self.voters.count==1) {
        NSString *message= [NSString stringWithFormat:@"You have only one voters in this game which makes this game meaningless."];
        [self displayErrorMessage:message :sender];
    }
    
    if (self.voters.count%2==0){
        NSString *message= [NSString stringWithFormat:@"You set even number of voters in this game and it will probably make the majority graph invalid which means the system can not determine the majority of a preference and then is not able to draw the graph."];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notes"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"All right, I will change the number"
                                                  style:UIAlertActionStyleDefault
                                                handler:^void (UIAlertAction *action) {
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Let us continue. We will see"
                                                  style:UIAlertActionStyleDefault
                                                handler:^void (UIAlertAction *action) {
                                                    [self performSegueWithIdentifier:@"Determine" sender:self];
                                                }]];

        [[alert popoverPresentationController] setSourceView:[self view]];
        [[alert popoverPresentationController] setSourceRect:[sender frame]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 if ([[segue identifier] isEqualToString:@"UpdateVoter"]) {
     Voter *SelectedVoter = [self.voters objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
     AddVoterViewController *addVoterView = segue.destinationViewController;
     addVoterView.voter = SelectedVoter;
 }
 
 }


- (void) updateStatusLabel{
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:16.0],NSFontAttributeName,
                                   [UIColor darkGrayColor],NSForegroundColorAttributeName,
                                   nil];
    NSString *statusText =@"This is the page for adding new voters and setting names and preference orders for them. Each voter must have one preference order over the previous candidates. All of the voters' preferences will finally determine a final outcome through some voting mechanism. Each candidate's name will be linked by '>' symbol in the preference order which means the voter prefer the former candidate than the later.";
    NSAttributedString *displayText = [[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
    
    if (self.voters.count ==1) {
        
        statusText =[statusText stringByAppendingString:@"\n\nNow we have one voter, but one voter will make the voting game boring and meaningless.Try to add more voters. "];
        displayText =[[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
        [self.statusLabel setAttributedText:displayText];
    }

    else if(self.voters.count >1){
        statusText = [statusText stringByAppendingString:@"\n\nYou have set enough voters. You can add more voters or press the next button to play the game"];
        displayText =[[NSMutableAttributedString alloc]initWithString:statusText attributes:attributeDict];
        [self.statusLabel setAttributedText:displayText];
    }
    [self.statusLabel setFrame:CGRectMake(8, 760-self.applicants.count*84, 752, 170)];

    [self.statusLabel setAttributedText:displayText];
    
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
