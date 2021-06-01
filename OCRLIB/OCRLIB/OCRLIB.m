//
//  OCRLIB.m
//  OCRLIB
//
//  Created by uchiyama_Macmini on 2018/09/11.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "OCRLIB.h"
#import "tessWraper.h"

@implementation OCRLIB
+(NSString*)recogImage:(NSImage*)img
{
    NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:[img TIFFRepresentation]];
    
    unsigned char* imageData = [imageRep bitmapData];
    
    char* retTxt = recognizeImage(imageData, (int)[imageRep pixelsWide], (int)[imageRep pixelsHigh], (int)[imageRep bytesPerRow], (int)[imageRep bitsPerPixel]);
    
    id displayString = [NSString stringWithCString:retTxt encoding:NSUTF8StringEncoding];
    
    return displayString;
}
@end
