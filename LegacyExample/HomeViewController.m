//
//  HomeViewController.m
//  LegacyExample
//
//  Created by Jeff Kelley on 7/19/18.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

#import "HomeViewController.h"

@import BottomSheetPresentation;

@interface HomeViewController ()

@property (nonatomic, strong, readonly) BottomSheetPresentationManager
    *bottomSheetPresentationManager;

@end

@implementation HomeViewController

@synthesize bottomSheetPresentationManager = _bottomSheetPresentationManager;

- (BottomSheetPresentationManager *)bottomSheetPresentationManager
{
    if (_bottomSheetPresentationManager == nil) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 20.0f);
        
        CACornerMask maskedCorners = (kCALayerMinXMinYCorner |
                                      kCALayerMinXMaxYCorner |
                                      kCALayerMaxXMinYCorner |
                                      kCALayerMaxXMaxYCorner);

        _bottomSheetPresentationManager =
        [[BottomSheetPresentationManager alloc]
         initWithCornerRadius:20.0
         maskedCorners:maskedCorners
         dimmingViewAlpha:0.25
         edgeInsets:edgeInsets
         ignoredEdgesForMargins: BSPViewEdgeNone
         dimmingViewTapTarget:self
         dimmingViewTapAction:@selector(dismissChild:)];
    }

    return _bottomSheetPresentationManager;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)unwindToHome:(id)sender {
    NSLog(@"Dismissing child view controller from sender: %@", sender);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentChild"]) {
        segue.destinationViewController.transitioningDelegate =
        self.bottomSheetPresentationManager;

        segue.destinationViewController.modalPresentationStyle =
        UIModalPresentationCustom;
    }
}

- (void)dismissChild:(id)sender
{
    NSLog(@"Dismissing child view controller from sender: %@", sender);
    [self dismissViewControllerAnimated:true completion:NULL];
}

@end
