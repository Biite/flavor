//
//  BFRecipesExploreVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipesExploreVC.h"
#import "BFRecipesTableCell.h"
#import "BFRecipe.h"
#import "BFMyUser.h"
#import "BFUser.h"
#import "BFAPI.h"
#import "BFSellerRecipesVC.h"
#import "BFSellerInfoVC.h"
#import "BFLoginVC.h"
#import "BFUserVC.h"
#import "BFOrderMenuVC.h"
#import "BFSearchFilterVC.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SVProgressHUD.h>


@interface BFRecipesExploreVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, atomic) NSMutableArray *recipeSets;

@property (strong, nonatomic) IBOutlet UITableView *recipesTableView;
@property (nonatomic) NSInteger selectedIndex;

@end


@implementation BFRecipesExploreVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recipeSets = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getRecipes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getRecipes
{
    [SVProgressHUD show];
    
    [self.recipeSets removeAllObjects];
    
    [BFAPI getAllRecipesWithCompletionHandler:^(NSError *error, id result)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if (!error)
            {
                for (NSDictionary *dict in result[@"posts"])
                {
                    BFRecipe *recipe = [[BFRecipe alloc] initWithDictionary:dict];
                    [self.recipeSets addObject:recipe];
                }
                
                [self.recipesTableView reloadData];
            }
            else
            {                
            }
        });
    }];
}

- (IBAction)showSetting:(id)sender
{
    if (![BFMyUser isLoggedIn])
    {
        [self performSegueWithIdentifier:@"GoToLogin" sender:sender];
    }
    else
    {
        [self performSegueWithIdentifier:@"GoToUserMenu" sender:sender];
    }
}

- (IBAction)showOrderedMenu:(id)sender
{
    [self performSegueWithIdentifier:@"GoToOrderMenu" sender:sender];
}

- (IBAction)showSearchFilter:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSearchFilter" sender:sender];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeSets count];
}

- (BFRecipesTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForRecipes";
    BFRecipesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[BFRecipesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BFRecipe *recipe = [self.recipeSets objectAtIndex:indexPath.row];
    
    cell.recipeName.text = recipe.recipeName;
    cell.prepareTime.text = [recipe.prepareTime stringByAppendingString:@" mins"];
    cell.ingredients.text = recipe.ingredients;
    
    NSString *price = @"$";
    cell.price.text = [price stringByAppendingString:recipe.price];
    
    cell.btnRecipe.tag = indexPath.row;
    [cell.btnRecipe addTarget:self action:@selector(displaySellerRecipes:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnProfile.tag = indexPath.row;
    [cell.btnProfile addTarget:self action:@selector(displaySellerInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *recipeImageURL = recipe.imageURL;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:recipeImageURL]
                                                    options:SDWebImageRefreshCached
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image != NULL)
         {
             cell.recipeImage.image = image;
         }
     }];
    
    cell.profileImageView.image = recipe.owner.profileImage;
//    [recipe.owner retrieveProfileImageWithCompletionHandler:^(NSError *error, UIImage *image, id result) {
//        cell.profileImageView.image = image;
//    } andKey:nil];
    
    return cell;
}

- (void)displaySellerRecipes:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
    [self performSegueWithIdentifier:@"GoToSellerRecipes" sender:sender];
}

- (void)displaySellerInfo:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
    [self performSegueWithIdentifier:@"GoToSellerInfo" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToSearchFilter"])
    {
//        CATransition* transition = [CATransition animation];
//        transition.duration = 1;
//        transition.type = kCATransitionFade;
//        transition.subtype = kCATransitionFromBottom;
//        
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        BFSearchFilterVC * searchFilterVC = [segue destinationViewController];
        searchFilterVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:searchFilterVC animated:YES completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToLogin"])
    {
        BFLoginVC *vc = [segue destinationViewController];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToUserMenu"])
    {
        BFUserVC *vc = [segue destinationViewController];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToOrderMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerRecipes"])
    {
        BFSellerRecipesVC *detailVC = [segue destinationViewController];
        BFRecipe *recipe = [self.recipeSets objectAtIndex:self.selectedIndex];
        [detailVC setRecipeInfo:recipe];
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
        BFRecipe *recipe = [self.recipeSets objectAtIndex:self.selectedIndex];
        [sellerVC setSellerInfo:recipe.owner];
    }
}

@end
