///
/// @file RRSHexGridView.h
/// @author Russell Steffen
/// @date 12 July 2013
/// @copyright Copyright (c) 2013 Russell Steffen. All rights reserved.
///

#import <Cocoa/Cocoa.h>

#pragma mark RRSHexGeometry
/*!
 * Calculates the geometric properties of a given
 * size hexagon and where their centers would be in
 * a grid.
 *
 * This class is a legacy from the Qt version of this control
 * and a future TODO is to remove it and merge this into
 * the main RRSHexView class.
 */
@interface RRSHexGeometry : NSObject

/*! Orientation of the Hex Grid */
@property (readonly) BOOL isVertical;

/*! @name Hexagon Attributes
 *  @image html "Hex Diagram 1.png" "Hex Geometry Diagram"
 */
//!@{
/*! Cell radius */
@property (readonly) float R;
/*! Cell height */
@property (readonly) float H;
/*! Cell width */
@property (readonly) float W;
/*! Cell size */
@property (readonly) float S;
//!@}

/*! Horizontal offset between cell centers */
@property (readonly) float horizontalIncrement;
/*! Vertical offset between cell centers */
@property (readonly) float verticalIncrement;

/*! @defgroup Init */
/*!
 * Initalize with given cell size and orientation
 */
- (id)initWithRadius:(float)radius isVertical:(BOOL)vert;

/*! @defgroup Cell Geometry */
/*!
 * return the center point of a given cell
 * @return cell center point
 * @param row Row index of target cell
 * @param column Column index of target cell
 */
- (NSPoint)centerWithRow:(NSInteger)row withColumn:(NSInteger)column;

/*!
 * Return the points that form the border of a target hex cell
 */
- (void)hexPointsWithRow:(NSInteger)row
              withColumn:(NSInteger)column
                  points:(NSPoint *)points;

/*!
 * Return an NSBezierPath object that defines the border of a target cell
 */
- (NSBezierPath *)hexPathWithRow:(NSInteger)row
                      withColumn:(NSInteger)column;

/*!
 * Return the row and column index of the cell at the
 * target point
 */
- (void)findCell:(NSPoint)point atRow:(NSInteger *)row
        atColumn:(NSInteger *)column;

@end

@class RRSHexGridView;


#pragma mark RRSHexViewDelegate protocol
/*!
 * Delegate class the controls behavior of the grid view.
 */
@protocol RRSHexViewDelegate <NSObject>
@optional

/*!
 * Method the HexGridView uses to draw the contents of a hex
 * @param gridView The specific grid view object calling
 * @param row Draw cell at row
 * @param column Draw cell at col
 * @param center Center point of the cell being drawn
 * @param path NSBezierPath object of the cell border
 */
- (BOOL)hexGridView:(RRSHexGridView *)gridView
drawCellContentsAtRow:(NSInteger)row
            column:(NSInteger)column
            center:(NSPoint)center
              path:(NSBezierPath *)path;

/*!
 * Called when the user clicks in the border area
 * @param gridView The specific grid view object calling
 */
- (void)hexGridViewClickedBorder:(RRSHexGridView *)gridView;

/*!
 * Called when the user clicks in a hex cell
 * @param gridView The specific grid view object calling
 * @param row The clicked cell's row
 * @param column THe clicked cell's column
 */
- (void)hexGridView:(RRSHexGridView *)gridView
  cellClickedAtRow:(NSInteger)row
            column:(NSInteger)column;

@end


#pragma mark RRSHexGridView

/*!
 * A grid of hexagons
 */
@interface RRSHexGridView : NSView {
    RRSHexGeometry *geometry; ///< Reference tothe current geometery object
    NSDictionary *cellLabelAttrs; ///< Dictionary of label text attributes

    __weak id<RRSHexViewDelegate> _delegate; ///< Reference to the delegate object

    /// Keep track of which methods are impelented by the delegate
    struct {
        unsigned int drawCellContentsAtRow:1;
        unsigned int clickedBorder:1;
        unsigned int clickedAtRowCol:1;
    } _delegateFlags;


    float _gridSize; ///< Grid size
    BOOL _isVertical; ///< Oriantation flag
    NSColor *_labelColor; ///< label color
    
}

/*! size of the grid */
@property (readwrite) float gridSize;
/*! number of rows in the grid */
@property (assign) NSInteger rows;
/*! number of colums in the grid */
@property (assign) NSInteger columns;
/*! grid orientation */
@property (assign) BOOL isVertical;
/*! cell border color */
@property (assign) NSColor *cellBorderColor;
/*! cell fill color */
@property (assign) NSColor *cellFillColor;
/*! view background color */
@property (assign) NSColor *viewBgColor;
/*! cell label text color */
@property (assign) NSColor *labelColor;
/*! set/fetch delegate object */
@property (weak)   IBOutlet id<RRSHexViewDelegate> delegate;

@end
