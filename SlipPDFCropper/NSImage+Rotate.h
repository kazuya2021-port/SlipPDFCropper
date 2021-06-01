//
//  NSImage+Rotate.h
//  ProjectDB
//
//  Created by uchiyama_Macmini on 2017/06/22.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface NSImage (Rotate)
- (NSImage*)verticalFlip;
- (NSImage*)horizontalFlip;
- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end
