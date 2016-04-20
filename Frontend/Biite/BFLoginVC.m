//
//  BFLoginVC.m
//  Biite
//
//  Created by JRRJ on 3/29/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFLoginVC.h"
#import "BFSignupVC.h"
#import "BFAPI.h"
#import "BFMyUser.h"
#import "BFFacebookUtils.h"
#import <SVProgressHUD.h>


@interface BFLoginVC () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *signinView;
@property (strong, nonatomic) IBOutlet UIView *signupView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *singinImageView;
@property (strong, nonatomic) IBOutlet UIImageView *signupImageView;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UIView *loginWithEmailButtonView;

@property (strong, nonatomic) IBOutlet UIView *loginWithFbButtonView;

@property (nonatomic) BOOL isSelectedSignIn;

@property (nonatomic) BOOL isEditingTextField;

@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) NSString *signupType;

@end


@implementation BFLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.singinImageView.layer.cornerRadius = 5.0;
    self.singinImageView.layer.masksToBounds = YES;
    self.signupImageView.layer.cornerRadius = 5.0;
    self.signupImageView.layer.masksToBounds = YES;
    
    self.isSelectedSignIn = true;
    self.singinImageView.image = [UIImage imageNamed:@"signin_sel_img"];
    self.signupImageView.image = [UIImage imageNamed:@"signup_desel_img"];
    
    self.titleLabel.text = @"Sign in for food with no boundaries";
    
    self.signinView.hidden = false;
    self.signupView.hidden = true;
    
    self.loginWithFbButtonView.hidden = false;
    self.loginWithEmailButtonView.hidden = true;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchOverlayView:)];
    gestureRecognizer.delegate = self;
    [self.backView addGestureRecognizer:gestureRecognizer];
    [self.titleView addGestureRecognizer:gestureRecognizer];
    
    self.isEditingTextField = false;
}

- (void)viewWillAppear:(BOOL)animated
{
    //    if (animated)
    {
        CGRect orign1 = self.titleView.frame;
        orign1.origin.y = -(self.titleView.frame.size.height + self.signinView.frame.size.height);
        self.titleView.frame = orign1;
        
        CGRect orign2 = self.buttonView.frame;
        orign2.origin.y = -(self.buttonView.frame.size.height + self.signinView.frame.size.height);
        self.buttonView.frame = orign2;
        
        CGRect orign3 = self.signinView.frame;
        orign3.origin.y = -(self.signinView.frame.size.height);
        self.signinView.frame = orign3;
        
        CGRect orign4 = self.signupView.frame;
        orign4.origin.y = -(self.signupView.frame.size.height);
        self.signupView.frame = orign4;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect new1 = self.titleView.frame;
            new1.origin.y = 0;
            self.titleView.frame = new1;
            
            CGRect new2 = self.buttonView.frame;
            new2.origin.y = (self.titleView.frame.size.height - self.buttonView.frame.size.height);
            self.buttonView.frame = new1;
            
            CGRect new3 = self.signinView.frame;
            new3.origin.y = self.titleView.frame.size.height;
            self.signinView.frame = new3;

            CGRect new4 = self.signupView.frame;
            new4.origin.y = self.titleView.frame.size.height;
            self.signupView.frame = new4;
        } completion:nil];
    }
}

- (void)dismissLoginViewController
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGFloat height;
        if (self.isSelectedSignIn)
        {
            height = self.signinView.frame.size.height;
        }
        else
        {
            height = self.signupView.frame.size.height;
        }
        
        CGRect new1 = self.titleView.frame;
        new1.origin.y = -(self.titleView.frame.size.height + height);
        self.titleView.frame = new1;
        
        CGRect new2 = self.buttonView.frame;
        new2.origin.y = -(self.buttonView.frame.size.height + height);
        self.buttonView.frame = new2;
        
        CGRect new3 = self.signinView.frame;
        new3.origin.y = -(self.signinView.frame.size.height);
        self.signinView.frame = new3;
        
        CGRect new4 = self.signupView.frame;
        new4.origin.y = -(self.signupView.frame.size.height);
        self.signupView.frame = new4;
    } completion:^(BOOL finished)
     {
         [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchOverlayView:(UITapGestureRecognizer *)gestureRecognizer
{
    if (!self.isEditingTextField)
    {
        [self dismissLoginViewController];
    }
    else
    {
        [self hideKeyboard];
        self.isEditingTextField = false;
    }
}

- (IBAction)onClickSignInView:(id)sender
{
    self.signinView.hidden = false;
    self.signupView.hidden = true;
    
    self.titleLabel.text = @"Sign in for food with no boundaries";
    
    self.isSelectedSignIn = true;
    self.singinImageView.image = [UIImage imageNamed:@"signin_sel_img"];
    self.signupImageView.image = [UIImage imageNamed:@"signup_desel_img"];
}

- (IBAction)onClickSignUpView:(id)sender
{
    self.signinView.hidden = true;
    self.signupView.hidden = false;
    
    self.titleLabel.text = @"Sign up for food with no boundaries";
    
    self.isSelectedSignIn = false;
    self.singinImageView.image = [UIImage imageNamed:@"signin_desel_img"];
    self.signupImageView.image = [UIImage imageNamed:@"signup_sel_img"];
}


#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isEditingTextField = true;
}

- (IBAction)userCreditenlChanged:(id)sender
{
    if ([self.usernameTextField.text isEqualToString:@""] && [self.passwordTextField.text isEqualToString:@""])
    {
        self.loginWithFbButtonView.hidden = false;
        self.loginWithEmailButtonView.hidden = true;
    }
    else
    {
        self.loginWithFbButtonView.hidden = true;
        self.loginWithEmailButtonView.hidden = false;
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}


/**
    Signin / Signup
**/

- (IBAction)onClickLoginWithFB:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbLoginSucceeded:)
                                                 name:BFFacebookUserDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFailed:)
                                                 name:BFFacebookSessionErrorNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFailed:)
                                                 name:BFFacebookUserDidCancelNotification
                                               object:nil];
    
    [BFFacebookUtils openSession];
}

- (void)loginFailed:(NSNotification*)notification
{
    
}

- (void)fbLoginSucceeded:(NSNotification*)notification
{
    [SVProgressHUD show];
    
    [BFMyUser fbLoginwithCompletionHandler:^(NSError *error, BFMyUser *sharedUser)
     {
         [SVProgressHUD dismiss];
         
         NSLog(@"fb aerrror: %@",error);
         if(!error)
         {
//             [self performSegueWithIdentifier:@"GoTo" sender:self];
             [self dismissLoginViewController];
         }
         else if(error.code == NETWORK_NOT_AUTHORIZED_ERROR_CODE ||
                 error.code == BFNETWORK_REJECT_ERROR_CODE ||
                 error.code == BFNETWORK_VALIDATION_ERROR_CODE ||
                 error.code == BFNETWORK_FACEBOOK_REJECT)
         {
             NSLog(@"NEWUSER");
             
             [BFFacebookUtils getMeInfoWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *fbError)
              {
                  NSLog(@"FACEBOOK ERROR %@",fbError);
                  
                  if(!fbError)
                  {
                      NSLog(@"Facebook Login results: %@", result);
                      
                      self.userInfo = [NSMutableDictionary dictionary];
                      
                      self.userInfo[@"firstName"] = result[@"first_name"];
                      self.userInfo[@"lastName"] = result[@"last_name"];
                      self.userInfo[@"extID"] = result[@"id"];
                      self.userInfo[@"profileLink"] = result[@"link"];
                      self.userInfo[@"email"] = result[@"email"];
                      self.userInfo[@"profileImageURL"] = result[@"picture"][@"data"][@"url"];
                      self.userInfo[@"fbToken"] = [FBSDKAccessToken currentAccessToken].tokenString;
                      
                      self.signupType=@"facebook";
                      
                      [self performSegueWithIdentifier:@"GoToSignup" sender:self];
                  }
                  else
                  {
                      [BFMyUser clearAllTokens];
                      [BFFacebookUtils clearAccessToken];
                  }
              }];
         }
         else
         {
             NSString* alertStr = nil;
             NSString* alertMsg = nil;
             if(error.code == NETWORK_NO_INTERNET)
             {
                 alertStr = @"No Internet";
                 alertMsg = @"Try again when there is an internet connection";
             }
             else
             {
                 alertStr = @"Error!";
             }
             
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertStr
                                                                            message:alertMsg
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             [BFFacebookUtils clearAccessToken];
             [BFMyUser clearAllTokens];
         }
     }];
    
    //    NSLog(@"GETTING LOGIN INFORMATION DURING LOGIN PROCESS");
    //Put VCMyuser into persistence.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BFFacebookUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BFFacebookSessionErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BFFacebookUserDidCancelNotification object:nil];
}

- (IBAction)onClickSignInAction:(id)sender
{
    if (![self.usernameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""])
    {
        [self.view endEditing:YES];

        [SVProgressHUD show];
        
        [BFMyUser usernameLogin:self.usernameTextField.text password:self.passwordTextField.text withCompletionHandler:^(NSError *error, BFMyUser *sharedUser)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                if (!error)
                {
                    //                [self performSegueWithIdentifier:@"GoTo" sender:self];
                    [self dismissLoginViewController];
                }
                else
                {
                    NSString* alertStr = nil;
                    NSString* alertMsg = nil;
                    if(error.code == NETWORK_NOT_AUTHORIZED_ERROR_CODE)
                    {
                        alertStr = @"Try Again!";
                        alertMsg = @"The login credentials are incorrect";
                    }
                    else if(error.code == NETWORK_NO_INTERNET)
                    {
                        alertStr = @"No Internet";
                        alertMsg = @"Try again when there is an internet connection";
                    }
                    else
                    {
                        alertStr = @"Error!";
                    }
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertStr
                                                                                   message:alertMsg
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
    else
    {
        if (!self.isEditingTextField)
        {
            [self dismissLoginViewController];
        }
        else
        {
            [self hideKeyboard];
            self.isEditingTextField = false;
        }
    }
}

- (IBAction)onClickSignupNext:(id)sender
{
    self.emailTextField.text = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.emailTextField.text.length!=0)
    {
        [SVProgressHUD show];
        
        [BFAPI emailValidation:self.emailTextField.text withCompletionHandler:^(NSError *error, id result)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                if (!error)
                {
                    if([result[@"isTaken"] boolValue])
                    {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Try Again"
                                                                                       message:@"The email has already been taken!"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        self.userInfo = [NSMutableDictionary dictionary];
                        self.userInfo[@"email"] = self.emailTextField.text;
                        
                        self.signupType = @"username";
                        
                        [self performSegueWithIdentifier:@"GoToSignup" sender:self];
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
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please enter an email address"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onClickForgotPassword:(id)sender
{
    if (self.usernameTextField.text.length>0)
    {
        [SVProgressHUD show];
        
        [BFAPI forgotPasswordWithEmail:self.usernameTextField.text withCompletionHandler:^(NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 NSString *alertStr = nil;
                 NSString *alertMsg = nil;
                 
                 if (error)
                 {
                     if(error.code==500)
                     {
                         alertStr = error.userInfo[BFNetworkErrorMessageKey];
                         alertMsg = @"Could not find user with that email! Please enter valid email address.";
                     }
                     else if (error.code == NETWORK_NO_INTERNET)
                     {
                         alertStr = @"Try Again";
                         alertMsg = @"Try again when there is cellular network";
                     }
                     else
                     {
                         alertStr=@"Error";
                     }
                 }
                 else
                 {
                     alertStr = @"Sent!";
                     alertMsg = @"A reset password email has been sent to your email address";
                 }
                 
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertStr
                                                                                message:alertMsg
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action) {}];
                 
                 [alert addAction:defaultAction];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             });
         }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You need to fill in your email."
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"GoToSignup"])
    {
        BFSignupVC *vc = segue.destinationViewController;
        vc.userInfo = self.userInfo;
        vc.signupType = self.signupType;
    }
}

@end
