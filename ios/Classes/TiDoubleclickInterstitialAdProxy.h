/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "TiDoubleclickDFPAdRequest.h"

@interface TiDoubleclickInterstitialAdProxy : TiProxy
<GADInterstitialDelegate> {
    DFPInterstitial* _ad;
}

@end
