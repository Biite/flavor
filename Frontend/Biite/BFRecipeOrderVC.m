//
//  BFRecipeOrderVC.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipeOrderVC.h"
#import "BFMyUser.h"
#import "BFShareMenuVC.h"
#import "BFPaymentLinkVC.h"


@interface BFRecipeOrderVC ()

@property (strong, nonatomic) IBOutlet UILabel *recipePortionSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipePrepareTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *takeOutView;
@property (strong, nonatomic) IBOutlet UIView *deliveryView;
@property (strong, nonatomic) IBOutlet UIView *cookHereView;
@property (strong, nonatomic) IBOutlet UIView *eatThereView;

@property (strong, nonatomic) IBOutlet UIImageView *imgTakeOut;
@property (strong, nonatomic) IBOutlet UIImageView *imgDelivery;
@property (strong, nonatomic) IBOutlet UIImageView *imgCookHere;
@property (strong, nonatomic) IBOutlet UIImageView *imgEatThere;

@property (strong, nonatomic) IBOutlet UILabel *lblTakeOut;
@property (strong, nonatomic) IBOutlet UILabel *lblDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblEatThere;
@property (strong, nonatomic) IBOutlet UILabel *lblCookHere;

@property (nonatomic, strong) UIColor *selectedBtnColor;
@property (nonatomic, strong) UIColor *deselectedBtnColor;
@property (nonatomic, strong) UIColor *deselectedLblColor;

@end


@implementation BFRecipeOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.takeOutView.layer.cornerRadius = 5.0;
    self.deliveryView.layer.cornerRadius = 5.0;
    self.cookHereView.layer.cornerRadius = 5.0;
    self.eatThereView.layer.cornerRadius = 5.0;
    
    self.selectedBtnColor = [UIColor colorWithRed:122.0/255.0 green:189.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.deselectedBtnColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.deselectedLblColor = [UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.recipePortionSizeLabel.text = self.recipeInfo.portionSize;
    self.recipePrepareTimeLabel.text = self.recipeInfo.prepareTime;
    
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    self.imgTakeOut.image = [UIImage imageNamed:@"takeout_img"];
    self.imgDelivery.image = [UIImage imageNamed:@"delivery_img"];
    self.imgCookHere.image = [UIImage imageNamed:@"cookhere_img"];
    self.imgEatThere.image = [UIImage imageNamed:@"eat_img"];
    
    self.lblTakeOut.textColor = self.deselectedLblColor;
    self.lblDelivery.textColor = self.deselectedLblColor;
    self.lblCookHere.textColor = self.deselectedLblColor;
    self.lblEatThere.textColor = self.deselectedLblColor;
    
    NSString *orderMode = self.recipeInfo.orderMode;
    if ([orderMode isEqualToString:@"TakeOut"])
    {
        self.takeOutView.backgroundColor = self.selectedBtnColor;
        self.imgTakeOut.image = [UIImage imageNamed:@"takeout_sel_img"];
        self.lblTakeOut.textColor = [UIColor whiteColor];
    }
    else if ([orderMode isEqualToString:@"Delivery"])
    {
        self.deliveryView.backgroundColor = self.selectedBtnColor;
        self.imgDelivery.image = [UIImage imageNamed:@"delivery_sel_img"];
        self.lblDelivery.textColor = [UIColor whiteColor];
    }
    else if ([orderMode isEqualToString:@"CookHere"])
    {
        self.cookHereView.backgroundColor = self.selectedBtnColor;
        self.imgCookHere.image = [UIImage imageNamed:@"cookhere_sel_img"];
        self.lblCookHere.textColor = [UIColor whiteColor];
    }
    else if ([orderMode isEqualToString:@"EatThere"])
    {
        self.eatThereView.backgroundColor = self.selectedBtnColor;
        self.imgEatThere.image = [UIImage imageNamed:@"eat_sel_img"];
        self.lblEatThere.textColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBtnTakeOut:(id)sender
{
    self.takeOutView.backgroundColor = self.selectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    self.imgTakeOut.image = [UIImage imageNamed:@"takeout_sel_img"];
    self.imgDelivery.image = [UIImage imageNamed:@"delivery_img"];
    self.imgCookHere.image = [UIImage imageNamed:@"cookhere_img"];
    self.imgEatThere.image = [UIImage imageNamed:@"eat_img"];
    
    self.lblTakeOut.textColor = [UIColor whiteColor];
    self.lblDelivery.textColor = self.deselectedLblColor;
    self.lblCookHere.textColor = self.deselectedLblColor;
    self.lblEatThere.textColor = self.deselectedLblColor;
}

- (IBAction)onClickBtnDelivery:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.selectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    self.imgTakeOut.image = [UIImage imageNamed:@"takeout_img"];
    self.imgDelivery.image = [UIImage imageNamed:@"delivery_sel_img"];
    self.imgCookHere.image = [UIImage imageNamed:@"cookhere_img"];
    self.imgEatThere.image = [UIImage imageNamed:@"eat_img"];
    
    self.lblTakeOut.textColor = self.deselectedLblColor;
    self.lblDelivery.textColor = [UIColor whiteColor];
    self.lblCookHere.textColor = self.deselectedLblColor;
    self.lblEatThere.textColor = self.deselectedLblColor;
}

- (IBAction)onClickBtnCookHere:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.selectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    self.imgTakeOut.image = [UIImage imageNamed:@"takeout_img"];
    self.imgDelivery.image = [UIImage imageNamed:@"delivery_img"];
    self.imgCookHere.image = [UIImage imageNamed:@"cookhere_sel_img"];
    self.imgEatThere.image = [UIImage imageNamed:@"eat_img"];
    
    self.lblTakeOut.textColor = self.deselectedLblColor;
    self.lblDelivery.textColor = self.deselectedLblColor;
    self.lblCookHere.textColor = [UIColor whiteColor];
    self.lblEatThere.textColor = self.deselectedLblColor;
}

- (IBAction)onClickBtnEatThere:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.selectedBtnColor;
    
    self.imgTakeOut.image = [UIImage imageNamed:@"takeout_img"];
    self.imgDelivery.image = [UIImage imageNamed:@"delivery_img"];
    self.imgCookHere.image = [UIImage imageNamed:@"cookhere_img"];
    self.imgEatThere.image = [UIImage imageNamed:@"eat_sel_img"];
    
    self.lblTakeOut.textColor = self.deselectedLblColor;
    self.lblDelivery.textColor = self.deselectedLblColor;
    self.lblCookHere.textColor = self.deselectedLblColor;
    self.lblEatThere.textColor = [UIColor whiteColor];
}

- (IBAction)onClickBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSocialShare:(id)sender
{
    [self performSegueWithIdentifier:@"GoToShareMenu" sender:sender];
}

- (IBAction)onClickBtnOrder:(id)sender
{
    // check if I have credit card
//    if ([BFMyUser sharedUser])
    {
        
    }
//    else
    {
        [self performSegueWithIdentifier:@"GoToPaymentLink" sender:sender];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToShareMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToPaymentLink"])
    {
    }
}

@end
