//
//  BFSellerInfoVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFSellerInfoVC.h"
#import "BFRecipesListCollectionCell.h"
#import "BFRecipeDetailVC.h"
#import "BFRecipe.h"
#import "BFShareMenuVC.h"
#import "UIImage+ImageUtils.h"


@interface BFSellerInfoVC () <UICollectionViewDataSource, UICollectionViewDelegate,  UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

@property (strong, atomic) NSMutableArray *recipeSets;
@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) IBOutlet UIImageView *sellerProfileBackground;
@property (strong, nonatomic) IBOutlet UIImageView *sellerPictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellerLocationLabel;
@property (strong, nonatomic) IBOutlet UITextView *sellerCareersTextView;
@property (strong, nonatomic) IBOutlet UIImageView *sellerRatingImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerReviewsLabel;

@end


@implementation BFSellerInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.sellerProfileBackground.image = [UIImage imageNamed:self.sellerInfo.sellerProfileBackground];
//    self.sellerPictureImageView.image = [UIImage imageNamed:self.sellerInfo.sellerPictureURL];
//    self.sellerRatingImageView.image = [UIImage imageNamed:self.sellerInfo.sellerRating];
//    self.sellerReviewsLabel.text = [self.sellerInfo.sellerReviews stringByAppendingString:@" reviews"];
//    self.sellerNameLabel.text = [self.sellerInfo.sellerFirstName stringByAppendingString:self.sellerInfo.sellerLastName];
//    self.sellerLocationLabel.text = self.sellerInfo.sellerLocation;
//    self.sellerCareersTextView.text = self.sellerInfo.sellerCareers;
    
    self.recipeSets = [[NSMutableArray alloc] init];
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

- (void)getRecipes
{
    // API call
    NSArray *result = @[@{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$25",
                            @"prepareTime": @"45",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img0",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"46",
                                    }
                            },
                        @{
                            @"name": @"Scallop noodles",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img1",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$35",
                            @"prepareTime": @"55",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img0",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"46",
                                    }
                            },
                        @{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$25",
                            @"prepareTime": @"45",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img1",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"43",
                                    }
                            },
                        @{
                            @"name": @"Scallop noodles",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img1",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$35",
                            @"prepareTime": @"55",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img1",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"43",
                                    }
                            }
                        ];
    
    // recipeSets
    // using recipe
    for (NSDictionary *dict in result)
    {
        BFRecipe *recipe = [[BFRecipe alloc] initWithDictionary:dict];
        [self.recipeSets addObject:recipe];
    }
}

- (IBAction)onClickTakeProfileBackground:(id)sender
{
    if ([UIAlertController class])
    {
        // iOS 8.3 later
        UIAlertController *photoAction = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              [self takePhoto:nil];
                                          }];
        
        UIAlertAction *selectPhotoAction =[UIAlertAction actionWithTitle:@"Choose Existing"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                               [self selectPhoto:nil];
                                           }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) { }];
        
        [photoAction addAction:takePhotoAction];
        [photoAction addAction:selectPhotoAction];
        [photoAction addAction:cancelAction];
        
        [self presentViewController:photoAction animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        
        [actionSheet showInView:self.view];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    self.sellerProfileBackground.image = [UIImage imageWithImage:img scaledToSize:CGSizeMake(self.sellerProfileBackground.frame.size.width, self.sellerProfileBackground.frame.size.height)];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto:nil];
            break;
            
        case 1:
            [self selectPhoto:nil];
            break;
    }
}

- (void)takePhoto:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"No Camera Available");
    }
}

- (void)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onClickAddToFavs:(id)sender
{
}

- (IBAction)onClickContact:(id)sender
{
}


#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.recipeSets count];
}

-(BFRecipesListCollectionCell *)collectionView:(UICollectionView *)collectionView
                cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BFRecipesListCollectionCell";
    BFRecipesListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    BFRecipe *recipe = self.recipeSets[indexPath.row];
    
    cell.recipeNameLabel.text = recipe.recipeName;
    cell.priceLabel.text = recipe.recipePrice;
    
    cell.recipeButton.tag = indexPath.row;
    [cell.recipeButton addTarget:self action:@selector(displayRecipeDetail:) forControlEvents:UIControlEventTouchUpInside];
    
//    [user retrieveProfileImageWithCompletionHandler:^(NSError error, UIImage image, id key)
//     {
//         imgPhoto.image = image;
//         
//     } andKey:@"userpicture"];
    cell.recipeImageView.image = [UIImage imageNamed:recipe.recipeImageURL];
    
    return cell;
}

- (void)displayRecipeDetail:(id)sender
{
    self.selectedIndex = 0;
    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:sender];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:nil];
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
}

@end
