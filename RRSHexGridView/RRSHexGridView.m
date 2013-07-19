//
//  RSHexGrid.m
//  HexGrid
//
//  Created by Russell Steffen on 6/1/13.
//  Copyright (c) 2013 Russell Steffen. All rights reserved.
//

#import "RRSHexGridView.h"

#pragma mark -
#pragma mark Constants

//**********************************************************
// Useful constants for building hexagons
static const double COSINE_30   = 0.866025403784; // cosine( 30deg )
static const double COSINE_30_2 = 1.73205080757;  // 2 * cosine( 30deg )
static const double COSINE_30_4 = 3.46410161514;  // 4 * cosine( 30deg )
static const double SQRT_3      = 1.732050807568877;

static const float DEFAULT_SIZE = 25.0;


#pragma mark -
#pragma mark Utility Functions

static inline NSPoint NSAddPoints(NSPoint firstPoint, NSPoint secondPoint)
{
	return NSMakePoint(firstPoint.x+secondPoint.x, firstPoint.y+secondPoint.y);
}

static inline NSPoint NSSubtractPoints(NSPoint firstPoint, NSPoint secondPoint)
{
	return NSMakePoint(firstPoint.x-secondPoint.x, firstPoint.y-secondPoint.y);
}


static BOOL RRSHexhitTest( NSPointArray vertex, NSPoint point )
{
    BOOL miss;
    
    miss = FALSE;
    
    for( int j = 0; j < 6 && !miss; j++ ) {
        NSPoint v, v1, c;
        double norm_v, norm_v1, norm_c;
        double dot1, dot2;
        double angle1, angle2;
        
        v = NSSubtractPoints(vertex[(j+5 % 6)], vertex[j]);
        v1 = NSSubtractPoints(vertex[(j+1 % 6)], vertex[j]);
        c = NSSubtractPoints(point, vertex[j]);

        norm_v = sqrt( pow(v.x,2) + pow(v.y,2) );
        norm_v1 = sqrt( pow(v1.x,2) + pow(v1.y,2) );
        norm_c = sqrt( pow(c.x,2) + pow(c.y,2) );

        dot1 = (v.x * v1.x) + (v.y * v1.y);
        dot2 = (v.x * c.x) + (v.y * c.y);
        
        angle1 = acos(dot1 / ( norm_v * norm_v1 ));
        angle2 = acos(dot2 / ( norm_v * norm_c ));
        
        if( angle2 > angle1 ) {
            miss = true;
        }

        
    }

    return !miss;
}

#pragma mark -
#pragma mark RRSHexGeometry

@implementation RRSHexGeometry

@synthesize isVertical = _isVertical;
@synthesize R = _R;
@synthesize H = _H;
@synthesize W = _W;
@synthesize S = _S;
@synthesize horizontalIncrement = _horizontalIncrement;
@synthesize verticalIncrement = _verticalIncrement;

#pragma mark -
#pragma mark RRSHexGeometry - init

-(id)initWithRadius:(float)radius isVertical:(BOOL)vert
{
    self = [super init];
    if( self ) {
        _isVertical = vert;
        _R = radius;
        
        _W = _R * 2.0;
        _S = (3.0/2.0) * _R;
        _H = _R * SQRT_3;
        
        if( _isVertical ) {
            _horizontalIncrement = _W/4.0;
            _verticalIncrement = _H/2;
        } else {
            _verticalIncrement = _W/4.0;
            _horizontalIncrement = _H/2;
        }
    }
    return self;
}

-(NSPoint)centerWithRow:(NSInteger)row withColumn:(NSInteger)column
{
    float x, y;
    
    x = ((column+1) * 3) - 1;
    
    if( (column % 2) == 0 ) {
        // Even col, flush the top
        y = ( (2 * row) + 1 );
    } else {
        // Odd col, inset from top by 1/2 hex size
        y = ( (2 * (row)) + 2 );
    }
    
    if (_isVertical) {
        return NSMakePoint(x * _horizontalIncrement, y * _verticalIncrement);
    } else {
        return NSMakePoint(y * _horizontalIncrement, x * _verticalIncrement);
    }
    
}

-(void)hexPointsWithRow:(NSInteger)row withColumn:(NSInteger)column points:(NSPoint *)points
{
    NSPoint center = [self centerWithRow:row withColumn:column];
    
    if (_isVertical) {
            points[0] = NSMakePoint(center.x - (_horizontalIncrement*2), center.y);
            
            points[1] = NSMakePoint(center.x - _horizontalIncrement, center.y + _verticalIncrement);
            
            points[2] = NSMakePoint(center.x + _horizontalIncrement, center.y + _verticalIncrement);
            
            points[3] = NSMakePoint(center.x + (_horizontalIncrement*2), center.y );
            
            points[4] = NSMakePoint(center.x + _horizontalIncrement, center.y -_verticalIncrement );
            
            points[5] = NSMakePoint(center.x - _horizontalIncrement, center.y -_verticalIncrement );
    } else {
            points[0] = NSMakePoint(center.x - _horizontalIncrement, center.y - _verticalIncrement);

            points[1] = NSMakePoint(center.x, center.y - (_verticalIncrement *2));

            points[2] = NSMakePoint(center.x + _horizontalIncrement, center.y - _verticalIncrement);

            points[3] = NSMakePoint(center.x + _horizontalIncrement, center.y + _verticalIncrement);
            
            points[4] = NSMakePoint(center.x, center.y + (_verticalIncrement*2));
            
            points[5] = NSMakePoint(center.x - _horizontalIncrement, center.y + _verticalIncrement);
    }
}

-(NSBezierPath *)hexPathWithRow:(NSInteger)row withColumn:(NSInteger)column
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    NSPoint points[6];
    
    [self hexPointsWithRow:row withColumn:column points:points];
    [path appendBezierPathWithPoints:points count:6];
    [path closePath];
    
    return path;
}

-(void)findCell:(NSPoint)point
           atRow:(NSInteger *)row
        atColumn:(NSInteger *)column
{
    NSInteger estimate_row, estimate_column;

    if( !_isVertical) {
        point = NSMakePoint(point.y, point.x);
    }
    
    NSInteger ci = (int)floorf(point.x / _S);
    NSInteger cx = point.x - _S*ci;
    
    NSInteger ty = point.y - (ci % 2) * _H / 2;
    NSInteger cj = (int)floorf(ty/_H);
    NSInteger cy = ty - _H*cj;
    
    if (cx > abs(_R/2 - _R * cy / _H)) {
        estimate_row = cj;
        estimate_column = ci;
    } else {
        estimate_column = ci - 1;
        estimate_row = cj + (ci % 2) - ((cy < _H/2)? 1 : 0);
    }
    
    if( !_isVertical ) {
        *row = estimate_column;
        *column = estimate_row;
    } else {
        *row = estimate_row;
        *column = estimate_column;
    }
}

@end

#pragma mark -
#pragma mark RRSHexGrid
@implementation RRSHexGridView


#pragma mark -
#pragma mark init

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _isVertical = TRUE;
        [self setGridSize:DEFAULT_SIZE];

        [self setRows:frameRect.size.height / geometry.H];
        [self setColumns:frameRect.size.width / geometry.W];

        [self setCellBorderColor:[NSColor blackColor]];
        [self setCellFillColor:[NSColor whiteColor]];
        [self setViewBgColor:[NSColor blackColor]];
        [self setLabelColor:[NSColor blackColor]];

        [self prepLabelAttributes];
        
        [self translateOriginToPoint:NSMakePoint(1.5, 1.5)];
    }
    return self;
}

-(void)prepLabelAttributes
{
    cellLabelAttrs = [@{ NSFontAttributeName : [NSFont userFontOfSize:8],
                      NSForegroundColorAttributeName : _labelColor } mutableCopy];
}

#pragma mark -
#pragma mark Accessors

@synthesize rows = _rows;

@synthesize columns = _columns;

-(void)setDelegate:(id<RRSHexViewDelegate>)delegate
{
    _delegate = delegate;

    _delegateFlags.drawCellContentsAtRow =
        [delegate respondsToSelector:@selector(drawCellContentsAtRow:column:center:path:)];

    [self setNeedsDisplay:YES];
}

-(id<RRSHexViewDelegate>)delegate
{
    return _delegate;
}

-(float)gridSize{
    return _gridSize;
}

-(void)setGridSize:(float)gridSize
{
    _gridSize = gridSize;
    geometry = [[RRSHexGeometry alloc] initWithRadius:_gridSize
                                          isVertical:_isVertical];
    
    [self setNeedsDisplay:YES];
}

-(BOOL)isVertical
{
    return _isVertical;
}

-(void)setIsVertical:(BOOL)isVertical
{
    _isVertical = isVertical;
    geometry = [[RRSHexGeometry alloc] initWithRadius:_gridSize
                                          isVertical:_isVertical];
    
    [self setNeedsDisplay:YES];
}

@synthesize cellBorderColor = _cellBorderColor;
@synthesize cellFillColor = _cellFillColor;
@synthesize viewBgColor = _viewBgColor;

-(NSColor *)labelColor
{
    return _labelColor;
}

-(void)setLabelColor:(NSColor *)labelColor
{
    _labelColor = labelColor;
    [self prepLabelAttributes];
    [self setNeedsDisplay:YES];
}


#pragma mark -
#pragma mark drawing

-(void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    
    //NSLog(@"drawRect : bounds (%f,%f), (%f,%f)", bounds.origin.x,
    //      bounds.origin.y, bounds.size.height, bounds.size.width);

    [_viewBgColor set];

    NSBezierPath *bound_path = [NSBezierPath bezierPathWithRect:bounds];
    [bound_path fill];

    [_cellBorderColor setStroke];
    [_cellFillColor setFill];


    for( NSInteger i = 0; i < self.rows; i++ ) {
        for( NSInteger j = 0; j < self.columns; j++) {

            [NSGraphicsContext saveGraphicsState];
            NSPoint p = [geometry centerWithRow:i withColumn:j];
            NSBezierPath *path = [geometry hexPathWithRow:i withColumn:j];
            BOOL continueDrawing = YES;

            [path fill];

            if( _delegateFlags.drawCellContentsAtRow ) {
                [NSGraphicsContext saveGraphicsState];
                continueDrawing = [_delegate drawCellContentsAtRow:i
                                                            column:j
                                                            center:p
                                                              path:path];
                [NSGraphicsContext restoreGraphicsState];
            }

            if (continueDrawing) {
                [path setLineWidth:1.5];
                [path stroke];

                NSString *string = [NSString stringWithFormat:@"%02ld%02ld", i, j];
                NSSize stringBox = [string sizeWithAttributes:cellLabelAttrs];

                p.x -= stringBox.width/2;
                p.y += geometry.H/4;

                [string drawAtPoint:p withAttributes:cellLabelAttrs];
            }

            [NSGraphicsContext restoreGraphicsState];
        }
    }
    
}

// Use flipped coordinates for now.
// Eventually could make this independent
-(BOOL)isFlipped
{
    return TRUE;
}


#pragma mark -
#pragma mark Event handlers
-(void)mouseUp:(NSEvent *)theEvent
{
    NSInteger row, column;
    NSPoint p = [theEvent locationInWindow];							
    
    [geometry findCell:[self convertPoint:p fromView:nil]
                 atRow:&row
              atColumn:&column];
    
    if ( row < 0 || column < 0 || row >= _rows || column >= _columns ){
        NSLog(@"Click outside of bounds");
    } else {
        NSLog(@"Clicked cell (%ld,%ld)", row, column);
    }
}

@end
