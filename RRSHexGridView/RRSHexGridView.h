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


#pragma mark RRSHexViewDelegate protocol
/*
 RRSHexViewDelegate :
 Delegate class the controls behavior of the grid view.
 */
@protocol RRSHexViewDelegate <NSObject>
@optional

-(void)setupDrawingDefaults;

-(void)drawDefaultCellAtRow:(NSInteger)row
                      column:(NSInteger)col
                      center:(NSPoint)c
                        path:(NSBezierPath *)path;

-(BOOL)drawCellAtRow:(NSInteger)row
               column:(NSInteger)col
               center:(NSPoint)c
                 path:(NSBezierPath *)path;

@end


#pragma mark RRSHexGridView

@interface RRSHexGridView : NSView {
    RRSHexGeometry *geometry;
    NSMutableDictionary *cellLabelAttrs;

    // Delegate
    __weak id<RRSHexViewDelegate> _delegate;

    struct {
        unsigned int setupDrawingDefaults;
        unsigned int drawDefaultCellAtRow;
        unsigned int drawCellAtRow;
    } _delegateFlags;


    float _gridSize;
    BOOL _isVertical;
    
}

@property (assign) float gridSize;
@property (assign) NSInteger rows;
@property (assign) NSInteger columns;
@property (assign) BOOL isVertical;
@property (weak)   IBOutlet id<RRSHexViewDelegate> delegate;

@end
