//
//  BFNewFoodVC.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFNewFoodVC.h"
#import "BFAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageUtils.h"
#import <SVProgressHUD.h>

@interface BFNewFoodVC () <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *postView;

@property (strong, nonatomic) IBOutlet UIView *recipeView;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (strong, nonatomic) IBOutlet UIButton *recipeNewButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeNewLabel;
@property (nonatomic) BOOL isImageSet;

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

@property (strong, nonatomic) NSString *orderMode;

@property (strong, nonatomic) UIColor *selectedBtnColor;
@property (strong, nonatomic) UIColor *deselectedBtnColor;

@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) IBOutlet UIButton *addMoreButton;
@property (strong, nonatomic) IBOutlet UIButton *checkTermsButton;
@property (strong, nonatomic) IBOutlet UILabel *checkTermsLabel;
@property (nonatomic) BOOL isShowTerms;
@property (nonatomic) BOOL isCheckedTerms;

@property (strong, nonatomic) IBOutlet UIImageView *progressImage;
@property (strong, nonatomic) IBOutlet UIButton *postFoodButton;

@property (nonatomic) CGRect activeRect;

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
    self.isImageSet = false;
    
    self.titleView.layer.cornerRadius = 6.0;
    self.ingredientsView.layer.cornerRadius = 6.0;
    
    UIColor *color = [UIColor lightGrayColor];
    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(ex: Spaghetti with Crab Sauce)" attributes:@{NSForegroundColorAttributeName: color}];
    self.ingredientsTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(ex: Flour, eggs, oil, etc)" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.takeoutView.layer.cornerRadius = 6.0;
    self.deliveryView.layer.cornerRadius = 6.0;
    self.cookhereView.layer.cornerRadius = 6.0;
    self.eatView.layer.cornerRadius = 6.0;
    
    self.orderMode = @"TakeOut";
    
    self.selectedBtnColor = [UIColor colorWithRed:122.0/255.0 green:189.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.deselectedBtnColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    self.addMoreButton.layer.cornerRadius = 6.0;
    self.checkTermsButton.layer.cornerRadius = 6.0;
    
    self.recipeNewButton.hidden = false;
    self.recipeNewLabel.hidden = false;
    
    self.isShowTerms = false;
    self.checkTermsButton.hidden = true;
    self.checkTermsLabel.hidden = true;
    self.isCheckedTerms = false;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidLayoutSubviews
{
    CGRect contentRect = self.scrollView.frame;
    contentRect.size.height = self.postView.frame.origin.y + self.postView.frame.size.height + self.postFoodButton.frame.size.height;
    self.scrollView.contentSize = contentRect.size;
    self.contentHeightConstraint.constant = contentRect.size.height;
    
    CGRect rect = self.progressImage.frame;
    rect.size.width = 0;
    self.progressImage.frame = rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unRegisterForKeyboardNotifications];
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


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    self.recipeImageView.image = [UIImage imageWithImage:img scaledToSize:CGSizeMake(self.recipeImageView.frame.size.width, self.recipeImageView.frame.size.height)];
    
    self.recipeNewButton.hidden = true;
    self.recipeNewLabel.hidden = true;
    
    self.isImageSet = true;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -  UIActionSheetDelegate

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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _scrollView.contentInset = contentInsets;
    
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    kbSize = [self.view convertRect:kbSize toView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.size.height+2, 0.0);
    
    _scrollView.contentInset = contentInsets;
    
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.size.height;
    
    if (!CGRectContainsPoint(aRect, self.activeRect.origin) )
    {
        [_scrollView scrollRectToVisible:self.activeRect animated:YES];
    }
}


#pragma mark -  UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeRect = textField.frame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeRect = CGRectZero;
    
    [textField resignFirstResponder];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)onClickBtnTakeOut:(id)sender
{
    self.takeoutView.backgroundColor = self.selectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
    
    self.orderMode = @"TakeOut";
}

- (IBAction)onClickBtnDelivery:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.selectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
    
    self.orderMode = @"Delivery";
}

- (IBAction)onClickBtnCookHere:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.selectedBtnColor;
    self.eatView.backgroundColor = self.deselectedBtnColor;
    
    self.orderMode = @"CookHere";
}

- (IBAction)onClickBtnEatThere:(id)sender
{
    self.takeoutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookhereView.backgroundColor = self.deselectedBtnColor;
    self.eatView.backgroundColor = self.selectedBtnColor;
    
    self.orderMode = @"EatThere";
}

- (IBAction)onClickAddMoreInformation:(id)sender
{
    if (self.isShowTerms == false)
    {
        self.isShowTerms = true;
        [self.addMoreButton setImage:[UIImage imageNamed:@"triangle_down_img"] forState:UIControlStateNormal];
        self.checkTermsButton.hidden = false;
        self.checkTermsLabel.hidden = false;
    }
    else
    {
        self.isShowTerms = false;
        [self.addMoreButton setImage:[UIImage imageNamed:@"triangle_arrow_img"] forState:UIControlStateNormal];
        self.checkTermsButton.hidden = true;
        self.checkTermsLabel.hidden = true;
    }
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

- (BOOL)validateInputs
{
    NSArray *textField = @[self.titleTextField,self.ingredientsTextField,self.portionTextField,self.prepTimeTextField,self.priceTextField];
    
    BOOL isEmpty = NO;
    
    for (UITextField* tf in textField)
    {
        NSString *str = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (str.length == 0)
        {
            isEmpty = YES;
            tf.layer.borderColor = [UIColor redColor].CGColor;
        }
        else
        {
            tf.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
    
    if (!self.isImageSet)
    {
        if([UIAlertController class])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Don't forget to add a recipe image"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) { }];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView* popMessageError = [[UIAlertView alloc] initWithTitle:@"Don't forget to add a recipe image."
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:@"", nil];
            [popMessageError show];
        }
        
        return false;
    }
    
    if (isEmpty)
    {
        if([UIAlertController class])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You need to complete all fields."
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            UIAlertView* popMessageError = [[UIAlertView alloc] initWithTitle:@"You need to complete all fields."
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:@"", nil];
            [popMessageError show];
        }
        
        return false;
    }
    
    return true;
}

- (IBAction)onClickNewFoodPost:(id)sender
{
    if ([self validateInputs])
    {
        [self updateRecipeImage:self.recipeImageView.image withCompletionHandler:^(NSError *error, NSString *imageURL) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error)
                {
//                    [SVProgressHUD show];
                    
                    [BFAPI postNewRecipe:self.titleTextField.text
                             ingredients:self.ingredientsTextField.text
                             portionSize:self.portionTextField.text
                                prepTime:self.prepTimeTextField.text
                               orderMode:self.orderMode
                                   price:self.priceTextField.text
                            privacyTerms:@"true"
                                imageURL:imageURL
                              imageWidth:[NSString stringWithFormat:@"%f", self.recipeImageView.image.size.width]
                             imageHeight:[NSString stringWithFormat:@"%f", self.recipeImageView .image.size.width]
                   withCompletionHandler:^(NSError *error, id result)
                     {
//                         [SVProgressHUD dismiss];
                         
                         if (error)
                         {
                             NSLog(@"error %@",error);
                             
                             NSString *alertString = nil;
                             NSString *msgString = nil;
                             if(error.code==430)
                             {
                                 alertString = @"User has already been created with that email.";
                                 msgString = @"Please try again with another email address";
                             }
                             else if(error.code==NETWORK_NO_INTERNET)
                             {
                                 alertString = @"Please check your cellular connection and try again";
                             }
                             else
                             {
                                 alertString= @"Unknown Error";
                             }
                             
                             if([UIAlertController class])
                             {
                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertString
                                                                                                message:msgString
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * action) {}];
                                 
                                 [alert addAction:defaultAction];
                                 
                                 [self presentViewController:alert animated:YES completion:nil];
                             }
                             else
                             {
                                 UIAlertView* popMessageError = [[UIAlertView alloc] initWithTitle:alertString
                                                                                           message:msgString
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:@"", nil];
                                 [popMessageError show];
                             }
                         }
                         else
                         {
                             [self performSegueWithIdentifier:@"GoToRecipesExplore" sender:self];
                         }
                     }];
                }
//            });
        }];
    }
}

- (void)updateRecipeImage:(UIImage*)image withCompletionHandler:(void (^)(NSError*error,NSString *imageURL))completionHandler
{
//    [SVProgressHUD show];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: @".jpg" ];
    NSData* data = UIImageJPEGRepresentation(image, 0.95);
    [data writeToFile:path atomically:YES];
    
    // Perform upload to Cloudinary
    CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl:@"cloudinary://553385872447778:qZikdJ4B4UxoCJbaGpsGM_0ZZFo@dss4hjy9v"];
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    
    NSMutableDictionary *option = [NSMutableDictionary new];
    option[@"folder"] = @"biite";
    
    [uploader upload:path options:option withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
//        [SVProgressHUD dismiss];
        
        if (successResult) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:[successResult valueForKey:@"secure_url"]];
            
            completionHandler(nil,[successResult valueForKey:@"secure_url"]);
            
        } else {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(errorResult, nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                       };
            NSError *error = [NSError errorWithDomain:@"cloudinary-error"
                                                 code:code
                                             userInfo:userInfo];
            completionHandler(error,nil);
        }
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
        CGRect rect = self.progressImage.frame;
        rect.size.width = self.postFoodButton.frame.size.width / totalBytesExpectedToWrite * totalBytesWritten;
        self.progressImage.frame = rect;
        NSLog(@"Block upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
    }];
}

//
//#pragma mark - Navigation
//
// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"GoToNewFood"])
//    {
//    }
//}

@end
