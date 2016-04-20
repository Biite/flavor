//
//  BFSellerRecipesVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFSellerRecipesVC.h"
#import "BFRecipeDetailVC.h"
#import "BFSellerInfoVC.h"
#import "BFRecipeOrderVC.h"
#import "BFUser.h"
#import "BFAPI.h"
#import "BFShareMenuVC.h"
#import <SVProgressHUD.h>


@interface BFSellerRecipesVC ()

@property (strong, atomic) NSMutableArray *recipeSets;
@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) IBOutlet UIImageView *recipeListImageView;
@property (strong, nonatomic) IBOutlet UILabel *recipePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeDescLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sellerPictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sellerRatingImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerReviewsLabel;

@property (strong, nonatomic) BFUser *seller;

@end


@implementation BFSellerRecipesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.seller = self.recipeInfo.owner;
    
    self.recipeSets = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.selectedIndex = 0;
    
    [self getRecipes];
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

- (void)showRecipeInfo
{
    BFRecipe *selected = [self.recipeSets objectAtIndex:self.selectedIndex];

    BFUser *seller = self.recipeInfo.owner;
    self.sellerPictureImageView.image = seller.profileImage;
    self.sellerNameLabel.text = [NSString stringWithFormat:@"@%@ is a chef", seller.username];
    
    self.recipeListImageView.image = selected.image;
    
    NSString *price = @"$";
    self.recipeNameLabel.text = selected.recipeName;
    self.recipePriceLabel.text = [price stringByAppendingString:selected.price];
    self.recipeDescLabel.text = selected.ingredients;
    
    self.recipeCountLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(self.selectedIndex + 1), (long)[self.recipeSets count]];
}

- (void)getRecipes
{
    [SVProgressHUD show];
    
    [self.recipeSets removeAllObjects];
    [self.recipeSets addObject:self.recipeInfo];
    
    [BFAPI getSellerRecipes:self.seller.userID withCompletionHandler:^(NSError *error, id result)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
             
             if (!error)
             {
                 for (NSDictionary *dict in result[@"posts"])
                 {
                     BFRecipe *recipe = [BFRecipe recipeWithDictionary:dict];
                     if (![recipe.recipeName isEqualToString:self.recipeInfo.recipeName])
                     {
                         [self.recipeSets addObject:recipe];
                     }
                 }
                 
                 [self showRecipeInfo];
             }
             else
             {
             }
         });
     }];
}

- (IBAction)onClickPrevRecipeDisplay:(id)sender
{
    if (self.selectedIndex == 0)
    {
        self.selectedIndex = [self.recipeSets count];
    }

    self.selectedIndex = self.selectedIndex - 1;
    
    [self showRecipeInfo];
}

- (IBAction)onClickNextRecipeDisplay:(id)sender
{
    if (self.selectedIndex == ([self.recipeSets count] - 1))
    {
        self.selectedIndex = -1;
    }
 
    self.selectedIndex = self.selectedIndex + 1;
    
    [self showRecipeInfo];
}

- (IBAction)onClickDisplayRecipeDetail:(id)sender
{
    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:sender];
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
    else if ([segue.identifier isEqualToString:@"GoToRecipeDetail"])
    {
        BFRecipeDetailVC *detailVC = [segue destinationViewController];
        BFRecipe *info = [self.recipeSets objectAtIndex:self.selectedIndex];
        [detailVC setRecipeInfo:info];
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
        [sellerVC setSellerInfo:self.seller];
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipeOrder"])
    {
        BFRecipeOrderVC *orderVC = [segue destinationViewController];
        BFRecipe *info = [self.recipeSets objectAtIndex:self.selectedIndex];
        [orderVC setRecipeInfo:info];
    }
}

@end
