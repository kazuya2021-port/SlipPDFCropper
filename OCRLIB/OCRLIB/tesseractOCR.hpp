//
//  tesseractOCR.hpp
//  KZOCR
//
//  Created by uchiyama_Macmini on 2017/07/18.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//

#ifndef tesseractOCR_hpp
#define tesseractOCR_hpp

#include <stdio.h>

char* recognizeImage(unsigned char* imageData, int imageW, int imageH, int bytesPerLine, int bitsPerPixel);

#endif /* tesseractOCR_hpp */
