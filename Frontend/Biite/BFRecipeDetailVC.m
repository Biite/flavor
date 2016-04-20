//
//  BFRecipeDetailVC.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipeDetailVC.h"
#import "BFUser.h"
#import "BFSellerInfoVC.h"
#import "BFShareMenuVC.h"
#import "BFRecipeOrderVC.h"


@interface BFRecipeDetailVC ()

@property (strong, nonatomic) IBOutlet UIImageView *sellerPictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sellerRatingImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerReviewsLabel;

@property (strong, nonatomic) IBOutlet UILabel *recipeIngredientsLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipePrepareTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipePortionSizeLabel;

@end


@implementation BFRecipeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    BFUser *seller = self.recipeInfo.owner;
    self.sellerPictureImageView.image = seller.profileImage;
    self.sellerNameLabel.text = [NSString stringWithFormat:@"@%@ is a chef", seller.username];

    self.recipeIngredientsLabel.text = self.recipeInfo.ingredients;
    self.recipePrepareTimeLabel.text = self.recipeInfo.prepareTime;
    self.recipePortionSizeLabel.text = self.recipeInfo.portionSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSocialShare:(id)sender
{
    [self performSegueWithIdentifier:@"GoToShareMenu" sender:sender];
}

- (IBAction)onClickDisplaySellerInfo:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSellerInfo" sender:sender];
}

- (IBAction)onClickRecipeOrder:(id)sender
{
    [self performSegueWithIdentifier:@"GoToRecipeOrder" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToShareMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
        [sellerVC setSellerInfo:self.recipeInfo.owner];
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipeOrder"])
    {
        BFRecipeOrderVC *orderVC = [segue destinationViewController];
        [orderVC setRecipeInfo:self.recipeInfo];
    }
}

@end
