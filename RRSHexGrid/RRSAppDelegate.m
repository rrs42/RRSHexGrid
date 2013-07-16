//
//  RRSAppDelegate.m
//  RRSHexGrid
//
//  Created by Russell Steffen on 7/12/13.
//  Copyright (c) 2013 Russell Steffen. All rights reserved.
//

#import "RRSAppDelegate.h"
#import "RRSHexGridView.h"

@implementation RRSAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


-(IBAction)scaleGrid:(NSSegmentedCell *)sender
{
    NSInteger tag = [sender selectedSegment];

    switch (tag) {
            case 0 : self.hexGridView.gridSize -= 0.25;
            break;

            case 1 : self.hexGridView.gridSize += 0.25;
            break;
    }

}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

-(void)setupDrawingDefaults
{
    [[NSColor blackColor] setFill];
    [[NSColor whiteColor] setStroke];
}

@end
