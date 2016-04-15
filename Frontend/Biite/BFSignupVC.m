//
//  BFSignupVC.m
//  Biite
//
//  Created by JRRJ on 4/12/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFSignupVC.h"
#import "BFPersonalVC.h"
#import "BFAPI.h"
#import "BFMyUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageUtils.h"
#import <SVProgressHUD.h>


@interface BFSignupVC () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIButton *editProfileImageButton;
@property (strong, nonatomic) IBOutlet UIButton *editCoverImageButton;

@property (strong, nonatomic) IBOutlet UIImageView *emailCheckimageView;
@property (strong, nonatomic) IBOutlet UIImageView *usernameCheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *passwordCheckImageView;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic) BOOL isAddProfileImage;

@property (nonatomic) CGRect activeRect;

@property (strong, nonatomic) IBOutlet UIButton *nextStageButton;

@property (nonatomic) BOOL isPfImageSet;
@property (nonatomic) BOOL isCvImageSet;

@end


@implementation BFSignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    _isPfImageSet = NO;
    _isCvImageSet = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    if ([self.signupType isEqualToString:@"facebook"])
    {
        [self facebookView];
    }
    
    self.nextStageButton.hidden = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupPreviousInfo];
}

- (IBAction)onClickBackNav:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookView
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.userInfo[@"profileImageURL"]]
                                                    options:SDWebImageRefreshCached
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if(error)
         {
             return;
         }
         else
         {
             _isPfImageSet=YES;
             [self.profileImageView setImage:image];
         }
     }];
}

- (void)setupPreviousInfo
{
    if ([self.signupType isEqualToString:@"facebook"])
    {
        if (self.userInfo)
        {
            self.emailCheckimageView.hidden = false;
            self.emailTextField.text = self.userInfo[@"email"];
        }
    }
    else if([self.signupType isEqualToString:@"username"])
    {
        if (self.userInfo)
        {
            self.emailCheckimageView.hidden = false;
            self.emailTextField.text = self.userInfo[@"email"];
        }
    }
    
    self.usernameCheckImageView.hidden = true;
    if (![self.usernameTextField.text isEqualToString:@""])
    {
        self.usernameCheckImageView.hidden = false;
    }
    
    self.passwordCheckImageView.hidden = true;
    self.nextStageButton.hidden = true;
    if (![self.passwordTextField.text isEqualToString:@""])
    {
        self.passwordCheckImageView.hidden = false;
        self.nextStageButton.hidden = false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editPhoto:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button == self.editProfileImageButton)
    {
        self.isAddProfileImage = true;
    }
    else
    {
        self.isAddProfileImage = false;
    }
    
    if ([UIAlertController class])
    {
        UIAlertController *photoAction = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              [self takePhoto];
                                          }];
        
        UIAlertAction *selectPhotoAction =[UIAlertAction actionWithTitle:@"Choose Existing"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                               [self selectPhoto];
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


#pragma mark -  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self selectPhoto];
            break;
    }
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (self.isAddProfileImage)
    {
        [self.profileImageView setImage:[UIImage imageWithImage:image scaledToSize:CGSizeMake(250, 250)]];
        _isPfImageSet = YES;
    }
    else
    {
        [self.coverImageView setImage:[UIImage imageWithImage:image scaledToSize:CGSizeMake(300, 150)]];
//        [self.coverImageView setImage:image];
        _isCvImageSet = YES;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^ { }];
}

- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.navigationBar.barTintColor = [UIColor blackColor];
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

- (void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barTintColor = [UIColor blackColor];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)emailTextFieldEditing:(id)sender {
    if ([self.emailTextField.text isEqualToString:@""])
    {
        self.emailCheckimageView.hidden = true;
    }
    else
    {
        self.emailCheckimageView.hidden = false;
    }
}
- (IBAction)usernameTextFieldEditing:(id)sender {
    if ([self.usernameTextField.text isEqualToString:@""])
    {
        self.usernameCheckImageView.hidden = true;
    }
    else
    {
        self.usernameCheckImageView.hidden = false;
    }
}
- (IBAction)passwordTextFieldEditing:(id)sender {
    if ([self.passwordTextField.text isEqualToString:@""])
    {
        self.passwordCheckImageView.hidden = true;
        self.nextStageButton.hidden = true;
    }
    else
    {
        self.passwordCheckImageView.hidden = false;
        self.nextStageButton.hidden = false;
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)validateInputs
{
    NSArray *textField = @[self.emailTextField,self.usernameTextField,self.passwordTextField];
    
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
    
    if (!_isPfImageSet)
    {
        if([UIAlertController class])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Don't forget to add a profile image"
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
            UIAlertView* popMessageError = [[UIAlertView alloc] initWithTitle:@"Don't forget to add a profile image."
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:@"", nil];
            [popMessageError show];
        }
        
        return false;
    }
    
    if (!_isCvImageSet)
    {
        if([UIAlertController class])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Don't forget to add a cover image"
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
            UIAlertView* popMessageError = [[UIAlertView alloc] initWithTitle:@"Don't forget to add a cover image."
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

- (IBAction)nextProfileSegue:(id)sender
{
    if([self validateInputs])
    {
        self.userInfo[@"email"] = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.userInfo[@"username"] = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.userInfo[@"password"] = [BFMyUser hashPassword:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        self.userInfo[@"pfImage"] = self.profileImageView.image;
        self.userInfo[@"cvImage"] = self.coverImageView.image;
        
        [SVProgressHUD show];
        
        [BFAPI userValidation:self.userInfo[@"username"] withCompletionHandler:^(NSError *error, id result)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                if (!error)
                {
                    if([result[@"isTaken"] boolValue])
                    {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Try Again"
                                                                                       message:@"The username has already been taken!"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:@"GoToPersonal" sender:self];
                    }
                }
                else
                {
                    NSString *alertString = nil;
                    NSString *msgString = nil;
                    
                    if(error.code==NETWORK_NO_INTERNET)
                    {
                        alertString = @"Please check your cellular connection and try again";
                    }
                    else
                    {
                        alertString= @"Error!";
                    }
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertString
                                                                                   message:msgString
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BFPersonalVC *personalVC = (BFPersonalVC*)segue.destinationViewController;
    personalVC.userInfo = self.userInfo;
 
} 

@end
