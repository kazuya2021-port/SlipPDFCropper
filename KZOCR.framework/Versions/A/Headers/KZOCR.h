//
//  KZOCR.h
//  KZOCR
//
//  Created by uchiyama_Macmini on 2017/07/18.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for KZOCR.
FOUNDATION_EXPORT double KZOCRVersionNumber;

//! Project version string for KZOCR.
FOUNDATION_EXPORT const unsigned char KZOCRVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KZOCR/PublicHeader.h>

@interface KZOCR : NSObject
+(NSString*)recogImage:(unsigned char*)imageData pixelsWide:(int)pW pixelsHigh:(int)ph bytesPerRow:(int)bytesPerRow bitsPerPixel:(int)bitsPerPixel;
@end


