//
//  BFShareMenuVC.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFShareMenuVC.h"

@interface BFShareMenuVC ()

@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *smsButton;
@property (strong, nonatomic) IBOutlet UIButton *copylinkButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *whatsappButton;

@end


@implementation BFShareMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize frameSize = self.view.frame.size;
    self.preferredContentSize = CGSizeMake(frameSize.width, frameSize.height);
    
    self.emailButton.layer.cornerRadius = 5.0;
    self.smsButton.layer.cornerRadius = 5.0;
    self.copylinkButton.layer.cornerRadius = 5.0;
    self.facebookButton.layer.cornerRadius = 5.0;
    self.twitterButton.layer.cornerRadius = 5.0;
    self.whatsappButton.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
