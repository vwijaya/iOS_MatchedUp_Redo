//
//  VWLoginViewController.m
//  iOS_MatchedUp_Redo
//
//  Created by Valerino on 8/13/14.
//  Copyright (c) 2014 VW. All rights reserved.
//

#import "VWLoginViewController.h"

@interface VWLoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation VWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    NSArray *permissionArray = @[@"user_about_me",
                                 @"user_interests",
                                 @"user_relationships",
                                 @"user_birthday",
                                 @"user_location",
                                 @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        if(!user) {
            // No valid user is returned
            if(!error) {
                // No error: Cancel button is pressed
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                                   message:@"Facebook login was cancelled"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [alertView show];
            } else {
                // Error
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                                    message:[error description]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            // Valid login
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
        }
    }];
}

#pragma mark - helpers
-(void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSDictionary *userDictionary = (NSDictionary *)result;
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            
            if(userDictionary[kVWUserProfileNameKey])
                userProfile[kVWUserProfileNameKey] = userDictionary[kVWUserProfileNameKey];
            if(userDictionary[kVWUserProfileFirstNameKey])
                userProfile[kVWUserProfileFirstNameKey] = userDictionary[kVWUserProfileFirstNameKey];
            if(userDictionary[kVWUserProfileLocationKey][kVWUserProfileNameKey])
                userProfile[kVWUserProfileLocationKey] = userDictionary[kVWUserProfileLocationKey][kVWUserProfileNameKey];
            if(userDictionary[kVWUserProfileGenderKey])
                userProfile[kVWUserProfileGenderKey] = userDictionary[kVWUserProfileGenderKey];
            if(userDictionary[kVWUserProfileBirthdayKey])
                userProfile[kVWUserProfileBirthdayKey] = userDictionary[kVWUserProfileBirthdayKey];
            if(userDictionary[kVWUserProfileInterestedInKey])
                userProfile[kVWUserProfileInterestedInKey] = userDictionary[kVWUserProfileInterestedInKey];
            //if([pictureURL absoluteString])
            //    userProfile[kVWUserProfilePictureURL] = [pictureURL absoluteString];
            
            if(userDictionary[kVWUserProfileLocationKey][kVWUserProfileNameKey]) {
                userProfile[kVWUserProfileLocationKey] = userDictionary[kVWUserProfileLocationKey][kVWUserProfileNameKey];
            }

        } else {
            NSLog(@"Error in Facebook request %@", error);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
