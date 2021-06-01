//
//  NSImage+Rotate.m
//  ProjectDB
//
//  Created by uchiyama_Macmini on 2017/06/22.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//

#import "NSImage+Rotate.h"

@implementation NSImage (Rotate)

- (NSImage*)verticalFlip
{
    NSRect curRect = {NSZeroPoint, [self size]};
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    NSRect imageBounds = {NSZeroPoint, rep.pixelsWide, rep.pixelsHigh};
    NSAffineTransform* transform = [NSAffineTransform transform];
    NSImage* rotatedImage = [[NSImage alloc] initWithSize:imageBounds.size] ;
    NSAffineTransformStruct flip = {1.0, 0.0, 0.0, -1.0, 0.0,
        imageBounds.size.height};
    [transform setTransformStruct:flip];
    
    [rotatedImage lockFocus];
    [transform concat];
    [self drawInRect:curRect fromRect:imageBounds operation:NSCompositingOperationCopy fraction:1.0] ;
    [rotatedImage unlockFocus];
    return rotatedImage;
}

- (NSImage*)horizontalFlip
{
    NSRect curRect = {NSZeroPoint, [self size]};
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    NSRect imageBounds = {NSZeroPoint, rep.pixelsWide, rep.pixelsHigh};
    NSAffineTransform* transform = [NSAffineTransform transform];
    NSImage* rotatedImage = [[NSImage alloc] initWithSize:imageBounds.size] ;
    NSAffineTransformStruct flip = {-1.0, 0.0, 0.0, 1.0,
        imageBounds.size.width, 0.0 };
    [transform setTransformStruct:flip];
    
    [rotatedImage lockFocus];
    [transform concat];
    [self drawInRect:curRect fromRect:imageBounds operation:NSCompositingOperationCopy fraction:1.0] ;
    [rotatedImage unlockFocus];
    return rotatedImage;
}

- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees {
    NSRect curRect = {NSZeroPoint, [self size]};
    // Calculate the bounds for the rotated image
    // We do this by affine-transforming the bounds rectangle
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    NSRect imageBounds = {NSZeroPoint, rep.pixelsWide, rep.pixelsHigh};
    NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform rotateByDegrees:-1.0 * degrees];// we want clockwise angles
    [boundsPath transformUsingAffineTransform:transform];
    NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};
    NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedBounds.size] ;
    
    // Center the image within the rotated bounds
    imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2);
    imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2);
    
    // Start a new transform, to transform the image
    transform = [NSAffineTransform transform];
    
    // Move coordinate system to the center
    // (since we want to rotate around the center)
    [transform translateXBy:+(NSWidth(rotatedBounds) / 2)
                        yBy:+(NSHeight(rotatedBounds) / 2)];
    // Do the rotation
    [transform rotateByDegrees:-1.0 * degrees];
    // Move coordinate system back to normal (bottom, left)
    [transform translateXBy:-(NSWidth(rotatedBounds) / 2)
                        yBy:-(NSHeight(rotatedBounds) / 2)];
    
    // Draw the original image, rotated, into the new image
    // Note: This "drawing" is done off-screen.
    [rotatedImage lockFocus];
    [transform concat];
    [self drawInRect:imageBounds fromRect:curRect operation:NSCompositingOperationCopy fraction:1.0] ;
    [rotatedImage unlockFocus];
    
    return rotatedImage;
    
}

@end
