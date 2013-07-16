//
//  RRSAppDelegate.h
//  RRSHexGrid
//
//  Created by Russell Steffen on 7/12/13.
//  Copyright (c) 2013 Russell Steffen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RRSHexGridView.h"

@class RRSHexGridView;

@interface RRSAppDelegate : NSObject <NSApplicationDelegate,
                                        NSWindowDelegate,
                                        RRSHexViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet RRSHexGridView *hexGridView;
-(IBAction)scaleGrid:(NSSegmentedCell *)sender;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

@end
