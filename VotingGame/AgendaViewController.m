//
//  AgendaViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/13.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "AgendaViewController.h"

#import "AppDelegate.h"

#import "Record.h"

#import "Applicant.h"

#import "AgendaViewController.h"

#import "Model2OutcomeViewController.h"

#import "Model2ViewController.h"


@interface AgendaViewController ()


@property (strong,nonatomic) NSMutableArray * applicants;

@property (strong,nonatomic) NSMutableArray * nameArray;

@property (strong,nonatomic) NSMutableArray * agendaArray;

@property (strong, nonatomic) NSMutableArray *mark;

@property (strong,nonatomic) Applicant *winner;

@property (strong) UILabel *first;

@end

@implementation AgendaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
    
    Record *record = appDelegate.record;
    
    self.applicants = (NSMutableArray *) record.applicant;
    
    CGFloat width = self.view.bounds.size.width;
    
    Applicant *applicant = [self.applicants objectAtIndex:0];

    self.agendaArray = [NSMutableArray arrayWithCapacity:self.applicants.count];
    self.nameArray = [[NSMutableArray alloc] init];
    for (int i=1; i<self.applicants.count; i++) {
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(width/2-50, 300+60*(i-1), 100, 70)];
        [label setText:[NSString stringWithFormat:@"Election %d \nVS",i]];
        [label setNumberOfLines:0];
        label.adjustsFontSizeToFitWidth = YES;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:25]];
        [[self view]addSubview:label];
    }
    
     self.first =[[UILabel alloc] initWithFrame:CGRectMake(width/2-300, 310, 100, 60)];
    self.first.adjustsFontSizeToFitWidth=YES;
    [self.first setTextAlignment:NSTextAlignmentCenter];
    [self.first setFont:[UIFont systemFontOfSize:35]];
    [[self view]addSubview:self.first];
    for (int i=0;i <[[self applicants]count];i++){
        [[self nameArray] addObject:@" "];
        [self.agendaArray addObject:applicant];
    }
    
//    [self updateLabel];
    self.ResultText.editable=NO;
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //return [[myDelegate ApplicantArray]count];
    
    return [[self applicants ]count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return [[myDelegate ApplicantArray] count];
    return [[self applicants ]count]+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // return [[myDelegate ApplicantArray]objectAtIndex:row];
    if (row!=0) {
        
        Applicant *applicant = [self.applicants objectAtIndex:row-1];
    
        return [NSString stringWithFormat:@"%@",[applicant valueForKey:@"aname"]];
    }
    else
        {
            if (component==0||component==1) {
                return [NSString stringWithFormat:@"Select one candidate for election 1"];
            }
            else
                return[NSString stringWithFormat:@"Select one candidate for election %d",component];
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
//    NSMutableArray *labelArray = [[NSMutableArray alloc] init];
//    for (int i=1; i<self.applicants.count; i++) {
//       
//        [labelArray addObject:label];
//    }
    
    if (row != 0) {
    Applicant *applicant = [self.applicants objectAtIndex:row-1];
    
//    BOOL a=true;
//    for(int j=0;j<self.applicants.count;j++){
//        
//        if([[applicant valueForKey:@"aname"]isEqualToString:[self.nameArray objectAtIndex:j]]){
//            NSString *message= [NSString stringWithFormat: @"Wrong arrangement."];
//            [self displayErrorMessage:message :nil];
//            a=false;
//        }
//    }
    
    
//    if (a) {
    
        for(int i=0;i<[[self applicants]count];i++){
            if (component==i){
                
                for (int j=0; j<self.applicants.count; j++) {
                    if(row-1==j){
                        self.nameArray[i]=[applicant valueForKey:@"aname"];
                        [self.agendaArray replaceObjectAtIndex:i withObject:applicant];
                        if (component == 0){
                            self.first.text = applicant.aname;
                        }
                        else
                            {
                                if (component !=1){
                                    UILabel *leftLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-390, 310+(i-1)*60, 300, 60)];
                                    [leftLabel setTextAlignment:NSTextAlignmentCenter];
                                    [leftLabel setFont:[UIFont systemFontOfSize:25]];
                                    [[self view]addSubview:leftLabel];
                                    leftLabel.text=[NSString stringWithFormat:@"Winner of Election %d",component-1];}
                                UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2+150, 310+(i-1)*60, 150, 60)];
                                [label setTextAlignment:NSTextAlignmentCenter];
                                [label setBackgroundColor:[UIColor whiteColor]];
                                [label setFont:[UIFont systemFontOfSize:35]];
                                [[self view]addSubview:label];
                                label.text=applicant.aname;
                            }
                            //                        [self updateLabel];
                    }
                }
            }
        }
    }
    }
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        if(row != 0)
            [pickerLabel setFont:[UIFont systemFontOfSize:40]];
        else
            [pickerLabel setFont:[UIFont systemFontOfSize:30]];
        
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}




- (IBAction)RuntheGame:(id)sender {

    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];

    self.mark = appDelegate.mark;

    NSInteger n = self.applicants.count;
    
    NSString *result=[[NSString alloc]init];
    Applicant *firstApplicant = [self.agendaArray objectAtIndex:0];
    Applicant *secondApplicant =[self.agendaArray objectAtIndex:1];
    
    NSInteger index1= [self.applicants indexOfObject:firstApplicant];
    NSInteger index2= [self.applicants indexOfObject:secondApplicant];

    Applicant *winner;
    for(int index3 = 1;index3<n;index3++){
        secondApplicant = [self.agendaArray objectAtIndex:index3];
        index1= [self.applicants indexOfObject:firstApplicant];
         index2= [self.applicants indexOfObject:secondApplicant];
        if (index1<index2){
            NSInteger index=0;
            for (int i = 0; i<n-1 ; i++){
                for (int j= i+1; j<n; j++) {
                    if(i==index1 && j==index2  ){
                        if ([[self.mark objectAtIndex:index]integerValue]>0) {
                            winner=firstApplicant;
                        }
                        else
                        {
                            winner=secondApplicant;
                            firstApplicant = secondApplicant;
                        }
                        result = [result stringByAppendingFormat:@"Election %d:\nThe winner is %@.\n\n", index3,winner.aname];
                    }
                    index++;
                }
            }
        }
        else{
            NSInteger index=0;
            for (int i = 0; i<n-1 ; i++){
                for (int j= i+1; j<n; j++) {
                    if(i==index2 && j==index1  ){
                        if ([[self.mark objectAtIndex:index]integerValue]<0) {
                            winner=firstApplicant;
                        }
                        else
                        {
                            winner=secondApplicant;
                            firstApplicant = secondApplicant;
                        }
                        result = [result stringByAppendingFormat:@"Election %d:\nThe winner is %@.\n\n", index3,winner.aname];
                    }
                  index++;

                    }
                }
            }
        }
    self.winner =winner;
    BOOL a=true;
    
    for(int m=0; m<self.nameArray.count-1; m++){
        NSString *name = [self.nameArray objectAtIndex:m];
        for (int j=m+1; j<self.nameArray.count; j++) {
            NSString *anotherName =[self.nameArray objectAtIndex:j];
            if([name isEqualToString:anotherName]){
                NSString *message= [NSString stringWithFormat: @"Wrong arrangement. Please check the agenda again."];
                [self displayErrorMessage:message :sender];
                a=false;
            }
        }
    }

    for (NSString *name in self.nameArray) {
        if([[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
            NSString *message= [NSString stringWithFormat: @"You need to complete the agenda!"];
            [self displayErrorMessage:message :nil];
            a=false;
        }
    }
    if(a)
        [self.ResultText setText:result];
    }

- (IBAction)determine:(id)sender {
    NSString *finalResult= [NSString stringWithFormat: @"The final winner is: %@",self.winner.aname];
}

- (IBAction)CallGraph:(id)sender {
    
    Model2ViewController *graph=[[Model2ViewController alloc]init];
    [graph setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    CGRect frame;
    frame.size.width = 100;
    frame.size.height = 30;
    frame.origin.x = 768 / 2 - 50;
    frame.origin.y = 899;
    [button setFrame:frame];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [[button titleLabel]setFont:[UIFont systemFontOfSize:20]];
    [button addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];

    [[graph view]addSubview:button];
    [self presentViewController:graph animated:YES completion:nil];

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


-(void)Back:(id)sender{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Model2OutcomeViewController *VC = segue.destinationViewController;
    NSString *finalResult= [NSString stringWithFormat: @"The final winner is: %@",self.winner.aname];
    VC.result = finalResult;
}
@end
