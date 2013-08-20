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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    self.hexGridView.rows = 15;
    self.hexGridView.columns = 15;

    self.hexGridView.labelColor = [NSColor blackColor];

    selectionActive = NO;
    selectedRow = selectedColumn = -1;

    [_hexGridView setNeedsDisplay:YES];

}


- (IBAction)scaleGrid:(NSSegmentedCell *)sender
{
    NSInteger tag = [sender selectedSegment];

    switch (tag) {
            case 0 : self.hexGridView.gridSize -= 0.25;
            break;

            case 1 : self.hexGridView.gridSize += 0.25;
            break;
    }

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


- (BOOL)hexGridView:view drawCellContentsAtRow:(NSInteger)row column:(NSInteger)col
            center:(NSPoint)c path:(NSBezierPath *)path
{
    if (selectionActive) {
        if ((row == selectedRow) && (col == selectedColumn)) {
            [[NSColor grayColor] setFill];
            [path fill];
            return NO;
        }
    }

    return YES;
}

- (void)hexGridView:(RRSHexGridView *)gridView
   cellClickedAtRow:(NSInteger)row
             column:(NSInteger)col
{
    if (selectionActive && row == selectedRow && col == selectedColumn) {
        [self hexGridViewClickedBorder:gridView];
        return;
    }
    selectionActive = YES;
    selectedRow = row;
    selectedColumn = col;
    [_hexGridView setNeedsDisplay:YES];
}

- (void)hexGridViewClickedBorder:(RRSHexGridView *)gridView
{
    selectionActive = NO;
    selectedRow = selectedColumn = -1;
    [_hexGridView setNeedsDisplay:YES];
}

@end
