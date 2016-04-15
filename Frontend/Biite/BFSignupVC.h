//
//  BFSignupVC.h
//  Biite
//
//  Created by JRRJ on 4/12/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFSignupVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableDictionary *userInfo;
@property (nonatomic,strong) NSString *signupType;

@end
