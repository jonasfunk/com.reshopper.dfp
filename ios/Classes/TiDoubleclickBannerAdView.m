/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiDoubleclickBannerAdView.h"
#import "TiDoubleclickDFPAdRequest.h"
#import "TiApp.h"



@implementation TiDoubleclickBannerAdView

-(void)dealloc
{
    // Release objects and memory allocated by the view
    [self releaseAd];
    
    [super dealloc];
}

-(id)init
{
    [super init];
    _adRequested = NO;
    //NSLog(@"[DEBUG] [TiDoubleClick] INIT FUNCTION CALLED");
    return self;
}


-(void)releaseAd
{
    if (_ad != nil) {
        _ad.delegate = nil;
        _ad.adSizeDelegate = nil;
        _ad.appEventDelegate = nil;
        NSLog(@"[DEBUG] [TiDoubleClick] Release ad");
        [_ad removeFromSuperview];
        RELEASE_TO_NIL(_ad);
    }
}

-(void)requestAd
{
    // NOTE: Must run on UI thread
    ENSURE_UI_THREAD_0_ARGS
    
    
    if([self.proxy valueForKey:@"adUnitId"] == nil){
        NSLog(@"[DEBUG] [TiDoubleClick] NO ADUNIT ID!");
        return;
    }
    
    BOOL debug = [TiUtils boolValue:[[self proxy] valueForKey:@"debug"] def:NO];
    
    // Release any existing ad
    [self releaseAd];
    
    // Build the adRequest
    // TiDoubleclickDFPAdRequest* adRequest = [[[TiDoubleclickDFPAdRequest alloc] initWithProxy:self.proxy] autorelease];
    
    if(debug){
        NSLog(@"[DEBUG] [AD SIZES] %@",[self.proxy valueForKey:@"adSizes"]);
    }
    
    NSArray *adSizes = [self.proxy valueForKey:@"adSizes"];
    NSMutableArray *validSizes = [NSMutableArray array];
    
    int width = [TiUtils intValue:[self.proxy valueForKey:@"adWidth"] def:0];
    int height = [TiUtils intValue:[self.proxy valueForKey:@"adHeight"] def:0];
    
    if(adSizes != nil)
    {
        if(debug){
            NSLog(@"[DEBUG] [TiDoubleClick] ad sizes is not null");
        }
        for (id object in adSizes) {
            // Create ad with first adSize
            if(_ad == nil) {
                if(debug){
                    NSLog(@"[DEBUG] [TiDoubleClick] multiple ad sizes");
                }
                
                GADAdSize adsize = GADAdSizeFromCGSize(CGSizeMake([[object objectForKey:@"width"] floatValue], [[object objectForKey:@"height"] floatValue]));
                _ad = [[DFPBannerView alloc] initWithAdSize:adsize];
            }
            
            GADAdSize adSize = GADAdSizeFromCGSize(CGSizeMake([[object objectForKey:@"width"] floatValue], [[object objectForKey:@"height"] floatValue]));
            
            [validSizes addObject:[NSValue valueWithBytes:&adSize objCType:@encode(GADAdSize)]];
        }
    }
    else if ((width > 0) && (height > 0))
    {
        if(debug){
            NSLog(@"[DEBUG] [TiDoubleClick] ad size: %dx%d", width, height);
        }
        GADAdSize adsize = GADAdSizeFromCGSize(CGSizeMake(width, height));
        _ad = [[DFPBannerView alloc] initWithAdSize:adsize];
    }
    else
    {
        NSLog(@"[DEBUG] [TiDoubleClick] ad size: SMART_BANNER");
        
        if (width>=height)
        {
            _ad = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        }
        else
        {
            _ad = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
        }
    }
    
    if(adSizes != nil)
    {
        _ad.validAdSizes = validSizes;
        
        [_ad setAdSizeDelegate:self];
    }
    
    // Specify the ad's "unit identifier." This is your DFP AdUnitId.
    _ad.adUnitID = [self.proxy valueForKey:@"adUnitId"];
    
    _ad.appEventDelegate = self;
    
    
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _ad.rootViewController = [[TiApp app] controller];
    
    // Tell continaer view to auto resize to ad dimensions
    //autoResize = [TiUtils boolValue:[self.proxy valueForKey:@"autoResize"]];
    
    //NSLog(@"[DEBUG] [TiDoubleClick] autoResize set %@", (autoResize ? @"Yes" : @"No"));
    
    // Initiate a generic request to load it with an ad.
    GADRequest* request = [GADRequest request];
    
    // Test devices
    NSArray *testDevices = [self.proxy valueForKey:@"testDevices"];
    if (testDevices != nil) {
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = testDevices;
    }
    
    NSString *contentURL = [self.proxy valueForKey:@"contentURL"];
    if (contentURL != nil) {
        if(debug){
            NSLog(@"[DEBUG] [TiDoubleClick] contentURL set: %@",contentURL);
        }
        request.contentURL = contentURL;
    }
    
    NSDictionary* location = [self.proxy valueForKey:@"location"];
    if (location != nil) {
        if(debug){
            NSLog(@"[DEBUG] [TiDoubleClick] location set:");
        }
        for (NSString* key in location)
        {
            if(debug){
                NSLog(@"[DEBUG] [TiDoubleClick]  - %@: %@", key, [location objectForKey:key]);
            }
        }
        [request setLocationWithLatitude:[[location valueForKey:@"latitude"] floatValue]
                               longitude:[[location valueForKey:@"longitude"] floatValue]
                                accuracy:[[location valueForKey:@"accuracy"] floatValue]];
    }
    
    bool has_extras = false;
    
    GADExtras *extras = [[[GADExtras alloc] init] autorelease];
    NSMutableDictionary *additionalParameters = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSDictionary* customTargeting = [self.proxy valueForKey:@"customTargeting"];
    if (customTargeting != nil)
    {
        for (NSString* key in customTargeting)
        {
            if(debug){
                NSLog(@"[DEBUG] [TiDoubleClick] custom targeting  - %@: %@", key, [customTargeting objectForKey:key]);
            }
        }
        [additionalParameters addEntriesFromDictionary: customTargeting];
        has_extras = true;
    }
    
    NSString* c;
    NSString *c2;
    c = [self.proxy valueForKey:@"adBackgroundColor"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_bg"];
        has_extras = true;
    }
    c = [self.proxy valueForKey:@"backgroundColorTop"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_bg_top"];
        has_extras = true;
    }
    c = [self.proxy valueForKey:@"borderColor"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_border"];
        has_extras = true;
    }
    c = [self.proxy valueForKey:@"linkColor"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_link"];
        has_extras = true;
    }
    c = [self.proxy valueForKey:@"textColor"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_text"];
        has_extras = true;
    }
    c = [self.proxy valueForKey:@"urlColor"];
    if (c != nil)
    {
        c2 = [c stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [additionalParameters setObject:c2 forKey:@"color_url"];
        has_extras = true;
    }
    
    if (has_extras)
    {
        
        for (NSString* key in additionalParameters)
        {
            if(debug){
                NSLog(@"[DEBUG] [TiDoubleClick]  - %@: %@", key, [additionalParameters objectForKey:key]);
            }
        }
        extras.additionalParameters = additionalParameters;
        [request registerAdNetworkExtras:extras];
    }
    
    [self addSubview:_ad];
    _ad.delegate = self;
    [_ad loadRequest:request];
    
}


-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if(!_adRequested){
        [self requestAd];
        _adRequested = YES;
    }
}


#pragma mark adSizeDelegate

// This method gets invoked when a DFPBannerView is about to change size.
// Only a multiple-sized DFPBannerView should implement this method.
-(void)adView:(DFPBannerView *)view willChangeAdSizeTo:(GADAdSize)size
{
    
    if (!GADAdSizeEqualToSize(_ad.adSize, size) && [self.proxy _hasListeners:@"willChangeAdSizeTo"]) {
        CGSize sizeOld = CGSizeFromGADAdSize(_ad.adSize);
        CGSize sizeNew = CGSizeFromGADAdSize(size);
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMINT(sizeOld.width), @"oldWidth",
                               NUMINT(sizeOld.height), @"oldHeight",
                               NUMINT(sizeNew.width), @"newWidth",
                               NUMINT(sizeNew.height), @"newHeight",
                               nil];
        [self.proxy fireEvent:@"willChangeAdSizeTo" withObject:event];
    }
}



#pragma mark appEventDelegate

// Called when a DFP creative invokes an app event. This method only
// needs to be implemented if your creative makes use of app events.
- (void)adView:(DFPBannerView*)view didReceiveAppEvent:(NSString *)name withInfo:(NSString *)info {
    if([self.proxy _hasListeners:@"appEvent"])
    {
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               info, name,
                               nil];
        NSLog(@"[DEBUG] Did receive app event");
        [self.proxy fireEvent:@"appEvent" withObject:event];
    }
}



#pragma mark bannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    
    NSString* adjustment = [self.proxy valueForKey:@"adjustment"];
    
    if(adjustment != nil && [adjustment isEqualToString: @"bottom"]){
        view.center = CGPointMake(roundf(self.frame.size.width / 2), self.frame.size.height - roundf(view.frame.size.height/ 2));
    }
    else if(adjustment != nil && [adjustment isEqualToString: @"top"]){
        view.center = CGPointMake(roundf(self.frame.size.width / 2), (view.frame.size.height/ 2));
    }
    else{
        view.center = CGPointMake(roundf(self.frame.size.width / 2), roundf(self.frame.size.height / 2));
    }
    
    NSLog(@"[DEBUG] Did receive add %@",view.responseInfo.adNetworkClassName);
    
    
    BOOL fadeIn = [TiUtils boolValue:[[self proxy] valueForKey:@"fadeIn"] def:NO];
    
    //    if (self && fadeIn)
    //    {
    //        self.alpha = 0.0;
    //
    //        [UIView animateWithDuration:0.2
    //                              delay:0.5
    //                            options:UIViewAnimationOptionCurveLinear
    //                         animations:^{
    //                             self.alpha = 1.0;
    //                         }
    //                         completion:nil];
    //    }
    
    
   
    
    if([[self proxy] _hasListeners:@"didReceiveAd"])
    {
        
        @try {
            [[self proxy] fireEvent:@"didReceiveAd"
                         withObject:@{
                             @"bannerWidth" : NUMFLOAT(view.frame.size.width),
                             @"bannerHeight" : NUMFLOAT(view.frame.size.height)             
                         }];
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            [self.proxy fireEvent:@"didReceiveAd"];
        }
        @finally {
            
        }
        
    }
    
}


- (void)adView:(DFPBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    if([self.proxy _hasListeners:@"didFailToReceiveAd"])
    {
        
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               [error localizedDescription], @"error",
                               nil];
        [self.proxy fireEvent:@"didFailToReceiveAd" withObject:event propagate:YES];
    }
}

- (void)adViewWillPresentScreen:(DFPBannerView *)adView
{
    [self.proxy fireEvent:@"willPresentScreen"];
}

- (void)adViewWillDismissScreen:(DFPBannerView *)adView
{
    [self.proxy fireEvent:@"willDismissScreen"];
}

- (void)adViewDidDismissScreen:(DFPBannerView *)adView
{
    [self.proxy fireEvent:@"didDismissScreen"];
}

- (void)adViewWillLeaveApplication:(DFPBannerView *)adView
{
    [self.proxy fireEvent:@"willLeaveApplication"];
}

@end
