/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiDoubleclickModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation TiDoubleclickModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"e35390af-1aa9-4416-ba22-88a3b1a50108";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.doubleclick";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
    TiThreadPerformOnMainThread(^{

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error: nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
 
       [GADMobileAds sharedInstance].audioVideoManager.audioSessionIsApplicationManaged = YES;
        NSLog(@"[INFO] Setting audiovideomanager");

    }, NO);
    
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

@end
