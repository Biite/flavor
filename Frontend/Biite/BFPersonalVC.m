//
//  BFPersonalVC.m
//  Biite
//
//  Created by JRRJ on 4/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFPersonalVC.h"
#import "BFAPI.h"
#import "BFMyUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageUtils.h"
#import <SVProgressHUD.h>

NSString* const textViewPlaceholder = @"Short Description";

@interface BFPersonalVC () <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;

@end


@implementation BFPersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.profileImageView.image = self.userInfo[@"pfImage"];
    self.coverImageView.image = self.userInfo[@"cvImage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBackNav:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)validateInputs
{
    NSArray *textField = @[self.firstNameTextField,self.lastNameTextField];
    
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
    
    if ([self.bioTextView.text isEqualToString:textViewPlaceholder])
    {
        isEmpty=YES;
        self.bioTextView.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        self.bioTextView.layer.borderColor = [UIColor whiteColor].CGColor;
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
        else
        {
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

- (IBAction)completeProfile:(UIButton*)sender
{
    [self hideKeyboard];
    
    sender.enabled=NO;
    
    if (![self validateInputs])
    {
        sender.enabled=YES;
        return;
    }
    
    [self updateProfileImage:self.userInfo[@"pfImage"] withCompletionHandler:^(NSError *error, NSString *imageURL) {
        if (!error)
        {
            self.userInfo[@"profileImageURL"] = imageURL;
            
            [self updateCoverImage:self.userInfo[@"cvImage"] withCompletionHandler:^(NSError *error, NSString *imageURL) {
                if (!error)
                {
                    self.userInfo[@"coverImageURL"] = imageURL;
                    
                    self.userInfo[@"firstName"] = [[self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] capitalizedString];
                    self.userInfo[@"lastName"] = [[self.lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] capitalizedString];
                    self.userInfo[@"gender"] = @"";
                    self.userInfo[@"biography"] = self.bioTextView.text;

                    [SVProgressHUD show];
                    
                    [BFAPI signupWithUsername:self.userInfo[@"username"]
                                        email:self.userInfo[@"email"]
                                     password:self.userInfo[@"password"]
                                    firstName:self.userInfo[@"firstName"]
                                     lastName:self.userInfo[@"lastName"]
                                       gender:self.userInfo[@"gender"]
                                    biography:self.userInfo[@"biography"]
                              profileImageURL:self.userInfo[@"profileImageURL"]
                                coverImageURL:self.userInfo[@"coverImageURL"]
                        withCompletionHandler:^(NSError *error, id result)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            
                            if (!error)
                            {
                                //result doesn't have accessToken inside dictionary.
                                NSLog(@"user %@",result[@"user"]);
                                [BFMyUser createNewSharedUserWithDict:result[@"user"]];
                                
                                sender.enabled=YES;
                                
//                                [self.navigationController popToRootViewControllerAnimated:true];
                                [self performSegueWithIdentifier:@"GoToRecipesExplore" sender:sender];
                            }
                            else
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
                                
                                sender.enabled=YES;
                            }
                        });
                    }];
                }
                else {
                    sender.enabled = YES;
                    [self showErrorMessage];
                }
            }];
        }
        else {
            sender.enabled = YES;
            [self showErrorMessage];
        }
    }];
}

- (void)showErrorMessage
{
    NSString *alertString = @"Error";
    NSString *msgString = nil;
    
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

- (void)updateProfileImage:(UIImage*)image withCompletionHandler:(void (^)(NSError*error,NSString *imageURL))completionHandler
{
    [SVProgressHUD show];
    
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
        [SVProgressHUD dismiss];
        
        if (successResult) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:[successResult valueForKey:@"secure_url"]];
            [self.userInfo removeObjectForKey:@"pfImage"];
            
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
        NSLog(@"Block upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
    }];
}

- (void)updateCoverImage:(UIImage*)image withCompletionHandler:(void (^)(NSError*error,NSString *imageURL))completionHandler
{
    [SVProgressHUD show];
    
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
        [SVProgressHUD dismiss];
        
        if (successResult) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:[successResult valueForKey:@"secure_url"]];
            [self.userInfo removeObjectForKey:@"cvImage"];
            
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
        NSLog(@"Block upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
    }];
}


#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewPlaceholder])
    {
        textView.selectedTextRange = [textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.beginningOfDocument];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0 && ![textView.text isEqualToString:textViewPlaceholder])
    {
        NSString *firstLetter = [textView.text substringToIndex:1];
        NSString *newText = [NSString stringWithFormat:@"%@%@",firstLetter,textViewPlaceholder];
        
        if([newText isEqualToString:textView.text])
        {
            textView.text = firstLetter;
            textView.textColor = [UIColor blackColor];
        }
    }
    else
    {
        textView.text=textViewPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
        
        textView.selectedTextRange = [textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.beginningOfDocument];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewPlaceholder])
    {
        textView.selectedTextRange = [textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.beginningOfDocument];
    }
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
