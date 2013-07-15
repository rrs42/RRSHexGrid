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


// RSHexViewDelegate

@protocol RRSHexViewDelegate <NSObject>

@optional

-(void)setVisual;

-(void)drawDefaultCellAtRow:(NSInteger)row
                      column:(NSInteger)col
                      center:(NSPoint)c
                        path:(NSBezierPath *)path;

-(BOOL)drawCellAtRow:(NSInteger)row
               column:(NSInteger)col
               center:(NSPoint)c
                 path:(NSBezierPath *)path;

@end



@interface RRSHexGrid : NSView {
    RRSHexGeometry *geometry;
    NSMutableDictionary *cellLabelAttrs;

    __weak id<RRSHexViewDelegate> _delegate;
    float _gridSize;
    BOOL _isVertical;
    
}

@property (assign) float gridSize;
@property (assign) NSInteger rows;
@property (assign) NSInteger columns;
@property (assign) BOOL isVertical;
@property (weak)   IBOutlet id<RRSHexViewDelegate> delegate;

@end
