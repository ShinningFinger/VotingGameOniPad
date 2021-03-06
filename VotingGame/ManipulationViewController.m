//
//  ManipulationViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/24.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "ManipulationViewController.h"

#import "pickerViewController.h"

#import "AppDelegate.h"

#import "Applicant.h"

#import "Record.h"

#import <CoreData/CoreData.h>



@interface ManipulationViewController ()

@property (strong,nonatomic) NSString *pre;

@property (strong,nonatomic) NSMutableArray *preferenceArray;

@property (strong,nonatomic) NSMutableArray *applicants;

@property (strong,nonatomic) NSMutableArray *voters;

@property (strong,nonatomic) NSMutableArray *records;

@end

@implementation ManipulationViewController
{
    Voter *newVoter;
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
    self.preferenceArray=[[NSMutableArray alloc]init];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:24],NSFontAttributeName,
                                   [UIColor blackColor],NSForegroundColorAttributeName,
                                   nil];
    NSMutableString *text=[[NSMutableString alloc]initWithString:@"Possible winners are:"];
    for(Applicant *applicant in self.possibleWinner){
        [text appendFormat:@" %@ ",applicant.aname ];
    }
    [text appendString:@"\n\n\nHaving possible winner means there are two or more candidates with the same largest count in the first rank which will make each of them possible to win if one more vote is submitted."];
    NSAttributedString *displayText = [[NSMutableAttributedString alloc]initWithString:text attributes:attributeDict];
    self.Text.adjustsFontSizeToFitWidth=YES;
    [self.Text setAttributedText:displayText];
    // Do any additional setup after loading the view.
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

- (IBAction)SaveData:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
    
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
    
    //    self.records= [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    Record *record =appDelegate.record;
    
    self.voters=(NSMutableArray *)record.voter;
    
    if (self.voter) {
        
        NSString *name= [[self Name]text];
        BOOL a=true;
        for (int i=0; i<self.voters.count;i++){
            Voter *Voter= [self.voters objectAtIndex:i];
            if (Voter != self.voter) {
                NSString *aname= [Voter valueForKey:@"name" ];
                if ([name isEqualToString:aname]) {
                    NSString *message = [NSString stringWithFormat:@"There exists the same voter, please select another name."];
                    [self displayErrorMessage:message :sender];
                    a=false;
                }
            }
        }
        self.preferenceArray = (NSMutableArray *)[self.Preference.text componentsSeparatedByString:@">"];
        for(int m=0; m<self.preferenceArray.count-1; m++){
            NSString *onePreference = [self.preferenceArray objectAtIndex:m];
            for (int j=m+1; j<self.preferenceArray.count; j++) {
                NSString *anotherPreference =[self.preferenceArray objectAtIndex:j];
                if([onePreference isEqualToString:anotherPreference]){
                    NSString *message= [NSString stringWithFormat: @"You can not set two preference as the same."];
                    [self displayErrorMessage:message :sender];
                    a=false;
                }
            }
        }
        
        if(a){
            if([[self.Name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
                NSString *message =[NSString stringWithFormat:@"You have not entered voter's name"];
                [self displayErrorMessage:message :sender];
            }
            else{
                [self.voter setValue:self.Name.text forKey:@"name"];
                [self.voter setValue:self.Preference.text forKey:@"preference"];
            }
        }
    }
    
    else {
        NSString *name= [[self Name]text];
        BOOL a=true;
        for (int i=0; i<self.voters.count;i++){
            Voter *Voter= [self.voters objectAtIndex:i];
            NSString *aname= [Voter valueForKey:@"name" ];
            if ([name isEqualToString:aname]) {
                NSString *message = [NSString stringWithFormat:@"There exists the same voter, please select another name."];
                [self displayErrorMessage:message :sender];
                a=false;
            }
        }
        
        if([[self.Preference.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
            NSString *message =[NSString stringWithFormat:@"You have not set the preference"];
            [self displayErrorMessage:message :sender];
        }
        
        else{
            for(int m=0; m<self.preferenceArray.count-1; m++){
                NSString *onePreference = [self.preferenceArray objectAtIndex:m];
                for (int j=m+1; j<self.preferenceArray.count; j++) {
                    NSString *anotherPreference =[self.preferenceArray objectAtIndex:j];
                    if([onePreference isEqualToString:anotherPreference]){
                        NSString *message= [NSString stringWithFormat: @"You can not set two preference as the same."];
                        [self displayErrorMessage:message :sender];
                        a=false;
                    }
                }
            }
            
            if(a){
                if([[self.Name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
                    NSString *message =[NSString stringWithFormat:@"You have not entered voter's name"];
                    [self displayErrorMessage:message :sender];
                }
                
                else{
                    newVoter = [NSEntityDescription insertNewObjectForEntityForName:@"Voter" inManagedObjectContext:context];
                    
                    [newVoter setRecordOfVoter:record];
                    
                    [newVoter setValue:self.Name.text forKey:@"name"];
                    
                    [newVoter setValue:self.Preference.text forKey:@"preference"];
                    
                }
            }
        }
    }
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (IBAction)DismissKeyboard:(id)sender {
    [self resignFirstResponder];
}



- (IBAction)unwindSegueToViewController:(UIStoryboardSegue *)segue  {
    
    pickerViewController *vc=(pickerViewController *)segue.sourceViewController;
    
    self.preferenceArray=vc.preferenceArray;
    
    self.pre=[[self preferenceArray]componentsJoinedByString:@">"];
    
    [[self Preference]setText:self.pre];
    
    
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
