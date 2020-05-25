/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"
#import "TiDoubleclickDFPAdRequest.h"
@import GoogleMobileAds;

@interface TiDoubleclickInterstitialAdView : TiUIView
<GADInterstitialDelegate> {
    DFPInterstitial* _ad;
}

@end
