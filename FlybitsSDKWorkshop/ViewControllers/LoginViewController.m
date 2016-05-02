//
//  LoginViewController.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-27.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

@import FlybitsSDK;

#import "LoginViewController.h"

@interface LoginViewController ()

#pragma mark - IBOutlets
@property (nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) IBOutlet UIButton *loginButton;

#pragma mark - NSLayoutConstraints
@property (nonatomic) IBOutlet NSLayoutConstraint *logoImageViewCenterConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopConstraint;

#pragma mark - Properties
// Tutorial Section 7.3 (Push Notifications)
@property (nonatomic) BOOL fromUnwindSegue;
@property (nonatomic) BOOL animateLogo;

@end

@implementation LoginViewController

#pragma mark - Constants
const NSString * const LoginSegue = @"LoginSegue";
const NSString * const RotationAnimation = @"Rotation";
const CGFloat LogoImageViewOffset = 75;

- (void)setAnimateLogo:(BOOL)animateLogo {
    _animateLogo = animateLogo;
    if(animateLogo) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = M_PI/2.0;
        animation.repeatCount = MAXFLOAT;
        animation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
        animation.fromValue = @0;
        [_logoImageView.layer addAnimation:animation forKey:[RotationAnimation copy]];
    } else {
        [_logoImageView.layer removeAnimationForKey:[RotationAnimation copy]];
    }
}

#pragma mark - View Lifecycle Functions
- (void)awakeFromNib {
    // Tutorial Section 7.6 (Push Notifications)
}

- (void)viewDidAppear:(BOOL)animated {
    if(_fromUnwindSegue) {
        _fromUnwindSegue = NO;
        [self reverseLogoAnimation];
    }
}

#pragma mark - Functions
- (void)animateLogoAndPerformSegue:(UIButton *)sender {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _emailTextField.hidden = YES;
        _passwordTextField.hidden = YES;
        _loginButton.hidden = YES;
        _logoImageViewTopConstraint.constant = self.view.frame.size.height / 2 - self.logoImageView.frame.size.height / 2 - self.topLayoutGuide.length;

        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _logoImageViewCenterConstraint.constant = self.view.frame.size.width;
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self performSegueWithIdentifier:[LoginSegue copy] sender:nil];
            [self setAnimateLogo:NO];
        }];
    }];
}

- (void)reverseLogoAnimation {
    [self setAnimateLogo:YES];
    [_logoImageViewCenterConstraint setConstant:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_logoImageViewTopConstraint setConstant:LogoImageViewOffset];
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_emailTextField setHidden:NO];
                [_passwordTextField setHidden:NO];
                [_loginButton setHidden:NO];
            } completion:^(BOOL finished) {
                [self setAnimateLogo:NO];
                [_loginButton setEnabled:YES];
            }];
        }];
    }];
}

#pragma mark - IBActions
- (IBAction)onLoginAction:(UIButton *)sender {
    sender.enabled = NO;
    [self setAnimateLogo:YES];

    NSString *email = _emailTextField.text ? _emailTextField.text : @"";
    NSString *password = _passwordTextField.text ? _passwordTextField.text : @"";

    // Tutorial Section 1.1 (Login / Logout)
    [self animateLogoAndPerformSegue:sender];
}

- (IBAction)onUnwindSegue:(UIStoryboardSegue *)segue {
    _fromUnwindSegue = YES;

    // Tutorial Section 1.2 (Login / Logout)
}

@end
