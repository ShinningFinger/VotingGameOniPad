//
//  pickerViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/28.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "pickerViewController.h"

#import "Record.h"

#import "Applicant.h"

#import "AppDelegate.h"

#import "AddVoterViewController.h"

#import "Voter.h"

@interface pickerViewController ()


@property (strong,nonatomic) NSMutableArray *Applicants;


@end

@implementation pickerViewController

@synthesize preferenceArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
    
//    self.records= [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    Record *record = appDelegate.record;
    self.Applicants=(NSMutableArray*)record.applicant;
        
    self.preferenceArray=[[NSMutableArray alloc]init];
    for (int i=0;i <[[self Applicants]count];i++){
        [self.preferenceArray addObject:[NSString stringWithFormat:@" "]];
    }
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //return [[myDelegate ApplicantArray]count];
    
    return [[self Applicants ]count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return [[myDelegate ApplicantArray] count];
    return [[self Applicants ]count]+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   // return [[myDelegate ApplicantArray]objectAtIndex:row];
    if (row == 0) {
        return [NSString stringWithFormat:@"No.%d",component+1];
    }
    else{
        Applicant *applicant = [self.Applicants objectAtIndex:row-1];
    
        return [NSString stringWithFormat:@"%@",applicant.aname];}
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    BOOL a=true;
    if(row ==0)
        a=false;
    else{
        Applicant *applicant = [self.Applicants objectAtIndex:row-1];
        for(int j=0;j<self.Applicants.count;j++){
            if([[applicant valueForKey:@"aname"]isEqualToString:[self.preferenceArray objectAtIndex:j]]){
                NSString *message= [NSString stringWithFormat: @"You can not set two preference as the same."];
                [self displayErrorMessage:message :nil];
                a=false;
            }
        }

        if (a) {
            for(int i=0;i<[[self Applicants]count];i++){
    
                if (component==i){
                    for (int j=0; j<[[self Applicants]count]; j++) {
                        if(row-1==j){
                            self.preferenceArray[i]=applicant.aname;
                        }
                    }
                }
            }
        }
    }
}

- (IBAction)Return:(id)sender {
    for (int i=0;i<[[self Applicants] count];i++) {
        NSString *preference=[[self preferenceArray]objectAtIndex:i];
        if ([[preference stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
            [[self preferenceArray]replaceObjectAtIndex:i withObject:[[self.Applicants objectAtIndex:0] aname]];
        }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 55;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:40]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
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
