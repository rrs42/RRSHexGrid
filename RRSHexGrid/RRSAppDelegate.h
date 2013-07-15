//
//  RRSAppDelegate.h
//  RRSHexGrid
//
//  Created by Russell Steffen on 7/12/13.
//  Copyright (c) 2013 Russell Steffen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RRSHexGrid;

@interface RRSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet RRSHexGrid *hexGridView;
- (IBAction)scaleGrid:(NSSegmentedCell *)sender;

@end
