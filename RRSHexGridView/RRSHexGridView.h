//
//  RSHexGrid.h
//  HexGrid
//
//  Created by Russell Steffen on 6/1/13.
//  Copyright (c) 2013 Russell Steffen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef  NS_ENUM(NSInteger, RRSHexOrientation) {
    RRSHexGeometryVertical    = 0,
    RRSHexGeometryHorizontal  =  1,
};

#pragma mark RRSHexGeometry
/*********************************
 RRSHexGeometry :
   calculates the geometric properties of a given
   size hexagon and where their centers would be in
   a grid.
 
   This class is a legacy from the Qt version of this control
   and a future TODO is to remove it and merge this into
   the main RRSHexView class.
 */
@interface RRSHexGeometry : NSObject
{

}

@property (readonly) BOOL isVertical;
@property (readonly) float R;
@property (readonly) float H;
@property (readonly) float W;
@property (readonly) float S;
@property (readonly) float horizontalIncrement;
@property (readonly) float verticalIncrement;

-(id)initWithRadius:(float)radius isVertical:(BOOL)vert;

-(NSPoint)centerWithRow:(NSInteger)row withColumn:(NSInteger)column;

-(void)hexPointsWithRow:(NSInteger)row
              withColumn:(NSInteger)column
                  points:(NSPoint *)points;

-(NSBezierPath *)hexPathWithRow:(NSInteger)row
                      withColumn:(NSInteger)column;

-(void)findCell:(NSPoint)point atRow:(NSInteger *)row
        atColumn:(NSInteger *)column;

@end

@class RRSHexGridView;


#pragma mark RRSHexViewDelegate protocol
/*
 RRSHexViewDelegate :
 Delegate class the controls behavior of the grid view.
 */
@protocol RRSHexViewDelegate <NSObject>
@optional

-(BOOL)hexGridView: (RRSHexGridView *)gridView
drawCellContentsAtRow:(NSInteger)row
            column:(NSInteger)col
            center:(NSPoint)c
              path:(NSBezierPath *)path;

-(void)hexGridViewClickedBorder:(RRSHexGridView *)gridView;

-(void)hexGridView: (RRSHexGridView *)gridView
  cellClickedAtRow:(NSInteger)row
            column:(NSInteger)col;

@end


#pragma mark RRSHexGridView

@interface RRSHexGridView : NSView {
    RRSHexGeometry *geometry;
    NSMutableDictionary *cellLabelAttrs;

    // Delegate
    __weak id<RRSHexViewDelegate> _delegate;

    struct {
        unsigned int drawCellContentsAtRow:1;
        unsigned int clickedBorder:1;
        unsigned int clickedAtRowCol:1;
    } _delegateFlags;


    float _gridSize;
    BOOL _isVertical;
    NSColor *_labelColor;
    
}

@property (assign) float gridSize;
@property (assign) NSInteger rows;
@property (assign) NSInteger columns;
@property (assign) BOOL isVertical;
@property (assign) NSColor *cellBorderColor;
@property (assign) NSColor *cellFillColor;
@property (assign) NSColor *viewBgColor;
@property (assign) NSColor *labelColor;
@property (weak)   IBOutlet id<RRSHexViewDelegate> delegate;

@end
