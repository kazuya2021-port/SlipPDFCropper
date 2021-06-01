//
//  tesseractOCR.cpp
//  KZOCR
//
//  Created by uchiyama_Macmini on 2017/07/18.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//

#include "tesseractOCR.hpp"
#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>
#include <iostream>

char* recognizeImage(unsigned char* imageData, int imageW, int imageH, int bytesPerLine, int bitsPerPixel)
{
    char *outText;
    
    tesseract::TessBaseAPI *api = new tesseract::TessBaseAPI();
    
    if(api->Init(NULL, "eng"))
    {
        return NULL;
    }
    api->SetVariable("tessedit_char_whitelist", "ISBN0123456789- ");
    
    outText = api->TesseractRect((const unsigned char*)imageData,
                                 (int)(bitsPerPixel/8),
                                 bytesPerLine,
                                 0, 0,
                                 imageW,
                                 imageH);
    delete(api);
    return outText;
}
