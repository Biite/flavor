//
//  BFNewFoodVC.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFNewFoodVC.h"
#import "UIImage+ImageUtils.h"

@interface BFNewFoodVC () <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *postView;

@property (strong, nonatomic) IBOutlet UIView *recipeView;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (strong, nonatomic) IBOutlet UIButton *recipeNewButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeNewLabel;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UIView *ingredientsView;
@property (strong, nonatomic) IBOutlet UITextField *ingredientsTextField;

@property (strong, nonatomic) IBOutlet UITextField *portionTextField;
@property (strong, nonatomic) IBOutlet UITextField *prepTimeTextField;

@property (strong, nonatomic) IBOutlet UIView *takeoutView;
@property (strong, nonatomic) IBOutlet UIView *deliveryView;
@property (strong, nonatomic) IBOutlet UIView *cookhereView;
@property (strong, nonatomic) IBOutlet UIView *eatView;

@property (nonatomic, strong) UIColor *selectedBtnColor;
@property (nonatomic, strong) UIColor *deselectedBtnColor;

@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) IBOutlet UIButton *addMoreButton;
@property (strong, nonatomic) IBOutlet UIButton *checkTermsButton;
@property (strong, nonatomic) IBOutlet UILabel *checkTermsLabel;
@property (nonatomic) BOOL isCheckedTerms;

@property (strong, nonatomic) IBOutlet UIImageView *progressImage;
@property (strong, nonatomic) IBOutlet UIButton *postFoodButton;

@end

@implementation BFNewFoodVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.recipeView.layer.cornerRadius = 6.0;
    self.recipeImageView.layer.cornerRadius = 6.0;
    self.recipeImageView.layer.masksToBounds = NO;
    self.titleView.layer.cornerRadius = 6.0;
    self.ingredientsView.layer.cornerRadius = 6.0;
    
    self.takeoutView.layer.cornerRadius = 6.0;
    self.deliveryView.layer.cornerRadius = 6.0;
    self.cookhereView.layer.cornerRadius = 6.0;
    self.eatView.layer.cornerRadius = 6.0;
    
    self.selectedBtnColor = [UIColor colorWithRed:122.0/255.0 green:189.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.deselectedBtnColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    self.addMoreButton.layer.cornerRadius = 6.0;
    self.checkTermsButton.layer.cornerRadius = 6.0;
    
    self.recipeNewButton.hidden = false;
    self.recipeNewLabel.hidden = false;
    
    self.isCheckedTerms = false;
}

- (void)viewDidLayoutSubviews
{
    CGRect contentRect = self.scrollView.frame;
    contentRect.size.height = self.postView.frame.origin.y + self.postView.frame.size.height + self.postFoodButton.frame.size.height;
    self.scrollView.contentSize = contentRect.size;
    self.contentHeightConstraint.constant = contentRect.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickTakeFoodPhoto:(id)sender
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
    
    self.recipeImageView.image = [UIImage imageWithImage:img scaledToSize:CGSizeMake(self.recipeImageView.frame.size.width, self.recipeImageView.frame.size.height)];
    
    self.recipeNewButton.hidden = true;
    self.recipeNewLabel.hidden = true;
    
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

- (IBAction)onClickBtnTakeOut:(id)sender
{
    self.takeoutView.backgroundColor = self.selectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
}

- (IBAction)onClickBtnDelivery:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.selectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
}

- (IBAction)onClickBtnCookHere:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.selectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
}

- (IBAction)onClickBtnEatThere:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.selectedBtnColor;
}

- (IBAction)onClickAddMoreInformation:(id)sender
{
}

- (IBAction)onClickCheckTerms:(id)sender
{
    if (self.isCheckedTerms == false)
    {
        [self.checkTermsButton setImage:[UIImage imageNamed:@"check_img"] forState:UIControlStateNormal];
        self.isCheckedTerms = true;
    }
    else
    {
        [self.checkTermsButton setImage:nil forState:UIControlStateNormal];
        self.isCheckedTerms = false;
    }
}

- (IBAction)onClickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickNewFoodPost:(id)sender
{
    // API Call
    // Post New Food
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"GoToNewFood"])
//    {
//    }
}

@end
