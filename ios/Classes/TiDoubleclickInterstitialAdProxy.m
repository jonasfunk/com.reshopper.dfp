/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiDoubleclickInterstitialAdProxy.h"
#import "TiApp.h"

@implementation TiDoubleclickInterstitialAdProxy

-(void)dealloc
{
    // Release objects and memory allocated
    [self releaseAd];
    
    [super dealloc];
}

-(void)releaseAd
{
    if (_ad != nil) {
        _ad.delegate = nil;
        
        RELEASE_TO_NIL(_ad);
    }
}

-(void)requestAd
{
    ENSURE_UI_THREAD_0_ARGS
    
    // It does not appear that the Doubleclick for Publishers SDK
    // supports the ability to add targeting information. If it is
    // added in the future then it may be as simple as using the initWithProxy constructor.
    TiDoubleclickDFPAdRequest* adRequest = [[[TiDoubleclickDFPAdRequest alloc] init] autorelease];
    NSString* adUnitId = [TiDoubleclickDFPAdRequest setupAdUnitId:self];
    
    _ad = [[DFPInterstitial alloc] init];
    
    // Specify the ad's "unit identifier." This is your DFP ad unit ID.
    _ad.adUnitID = adUnitId;
    
    _ad.delegate = self;
    [_ad loadRequest:[adRequest getRequestWithExtras]];
}

-(void)_initWithProperties:(NSDictionary*)properties
{
    [super _initWithProperties:properties];
    [self requestAd];
}

-(void)presentAd:(id)args
{
    // Interstitials MUST be displayed on the UI thread or else an
    // exception will occur. The interstitial is created on the UI thread.
    ENSURE_UI_THREAD_1_ARG(args);
    
    [_ad presentFromRootViewController:[[TiApp app] controller]];
}

-(void)dissmissAd
{
    [_ad dismissViewControllerAnimated:YES completion:NULL];
}


-(NSNumber*)isReady
{
    return NUMBOOL([_ad isReady]);
}

#pragma mark interstitialAd Delegate

- (void)interstitialDidReceiveAd:(DFPInterstitial *)interstitial
{
    [self fireEvent:@"didReceiveAd"];
    BOOL autoPresent = [TiUtils boolValue:[self valueForKey:@"presentAd"] def:YES];
    if (autoPresent) {
        [self presentAd:nil];
    }
}

- (void)interstitial:(DFPInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           [error localizedDescription], @"error",
                           nil];
    [self fireEvent:@"didFailToReceiveAd" withObject:event];
}

- (void)interstitialWillPresentScreen:(DFPInterstitial *)interstitial
{
    NSLog(@"Present interstitial");
    [self fireEvent:@"willPresentScreen"];
}

- (void)interstitialWillDismissScreen:(DFPInterstitial *)interstitial
{
    NSLog(@"Interstitial will dismiss");
    [self fireEvent:@"willDismissScreen"];
}

- (void)interstitialDidDismissScreen:(DFPInterstitial *)interstitial
{
     NSLog(@"Interstitial did dismiss");
    [self fireEvent:@"didDismissScreen"];
}

- (void)interstitialWillLeaveApplication:(DFPInterstitial *)interstitial
{
     NSLog(@"Interstitial will leave app");
    [self fireEvent:@"willLeaveApplication"];
}

@end
