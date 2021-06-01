//
//  AppDelegate.m
//  SlipPDFCropper
//
//  Created by uchiyama_Macmini on 2018/08/16.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "AppDelegate.h"
#import "NSImage+Rotate.h"
#import <KZOCR/KZOCR.h>
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    fileData = [NSMutableArray array];
    resultData = [NSMutableArray array];
    [fileTable registerForDraggedTypes:ARRAY(NSFilenamesPboardType)];
    [fileTable setTarget:self];
    [fileTable setDelegate:self];
    [resultTable setTarget:self];
    [resultTable setDelegate:self];
    [resultTable setDoubleAction:@selector(onDoubleClickResult:)];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

-(void)windowWillClose:(NSNotification *)notification
{
    resultData = [NSMutableArray array];
}

- (void)onDoubleClickResult:(id)sender
{
    if([sender clickedRow] == -1) return;
    NSArray* selData = [resultData objectAtIndex:[sender clickedRow]];
    NSURL* fileURL = [NSURL fileURLWithPath:[selData objectAtIndex:1]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:ARRAY(fileURL)];
}
//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark MainProcess
//----------------------------------------------------------------------------//
- (NSString*) convertStart:(NSSize)targetSize
               processFile:(NSString*)oPath

{
    NSString* resPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"tmp.pdf"];
    NSString* ret = @"";
    NSDictionary  *asErrDic = nil;
    NSString* isCenter = @"NO";
    if([center state] == NSOnState)
    {
        isCenter = @"YES";
    }
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    set ofile to \"%@\"\n"
                     "    set pH to \"%.2lf mm\"\n"
                     "    set pW to \"%.2lf mm\"\n"
                     "    set isC to \"%@\"\n"
                     "    set ofile to ofile as POSIX file\n"
                     "    tell application \"%@\"\n"
                     "        set myDoc to make document\n"
                     "        tell PDF place preferences\n"
                     "            set PDF crop to crop media\n"
                     "        end tell\n"
                     "        tell document preferences of myDoc\n"
                     "            set page height to pH\n"
                     "            set page width to pW\n"
                     "            set pages per document to 1\n"
                     "            set page binding to right to left\n"
                     "            set facing pages to false\n"
                     "        end tell\n"
                     "        tell myDoc\n"
                     "            tell page (1)\n"
                     "                set myRect to make rectangle\n"
                     "                tell myRect\n"
                     "                    set geometric bounds to {\"0mm\", \"0mm\", pH, pW}\n"
                     "                    set stroke color to swatch \"None\" of myDoc\n"
                     "                    set fill color to swatch \"None\" of myDoc\n"
                     "                    place alias ofile\n"
                     "                    if isC is \"YES\" then\n"
                     "                        fit given center content\n"
                     "                    end if\n"
                     "                end tell\n"
                     "            end tell\n"
                     "        end tell\n"
                     "        if isC is \"NO\" then\n"
                     "            do script(\"\n"
                     "                var d = app.activeDocument;\n"
                     "                var obj = d.allGraphics[0];\n"
                     "                var b = obj.geometricBounds;\n"
                     "                if((b[3]-b[1]) > 200)\n"
                     "                    obj.move([\\\"-%@mm\\\", \\\"-%@mm\\\"]);\n"
                     "                else\n"
                     "                    obj.move([\\\"-13.2mm\\\", \\\"-%@mm\\\"]);\n"
                     "            \") language javascript\n"
                     "        end if\n"
                     "        do script(\"\n"
                     "                with(app.pdfExportPreferences){\n"
                     "                    acrobatCompatibility = AcrobatCompatibility.ACROBAT_5;\n"
                     "                    pageRange = PageRange.allPages;\n"
                     "                    exportGuidesAndGrids = false;\n"
                     "                    exportLayers = false;\n"
                     "                    exportNonPrintingObjects = false;\n"
                     "                    exportReaderSpreads = false;\n"
                     "                    generateThumbnails = false;\n"
                     "                    try{ ignoreSpreadOverrides = false; } catch(e){}\n"
                     "                    includeBookmarks = false;\n"
                     "                    includeHyperlinks = false;\n"
                     "                    includeICCProfiles = false;\n"
                     "                    includeSlugWithPDF = false;\n"
                     "                    includeStructure = false;\n"
                     "                    subsetFontsBelow = 100;\n"
                     "                    colorBitmapCompression = BitmapCompression.zip;\n"
                     "                    colorBitmapQuality = CompressionQuality.eightBit;\n"
                     "                    colorBitmapSampling = Sampling.NONE;\n"
                     "                    grayscaleBitmapCompression = BitmapCompression.zip;\n"
                     "                    grayscaleBitmapQuality = CompressionQuality.eightBit;\n"
                     "                    grayscaleBitmapSampling = Sampling.NONE;\n"
                     "                    monochromBitmapCompression = MonoBitmapCompression.CCIT4;\n"
                     "                    monochromBitmapSampling = Sampling.NONE;\n"
                     "                    compressTextAndLineArt = true;\n"
                     "                    cropImagesToFrames = true;\n"
                     "                    colorBars = false;\n"
                     "                    cropMarks = false;\n"
                     "                    bleedMarks = false;\n"
                     "                    registrationMarks = false;\n"
                     "                    pageInformationMarks = false;\n"
                     "                    useDocumentBleedWithPDF = false;\n"
                     "                    bleedBottom = 0;\n"
                     "                    bleedTop = 0;\n"
                     "                    bleedInside = 0;\n"
                     "                    bleedOutside = 0;\n"
                     "                    compressionType = PDFCompressionType.COMPRESS_NONE;\n"
                     "                    pdfColorSpace = PDFColorSpace.UNCHANGED_COLOR_SPACE;\n"
                     "                    try { simulateOverprint = false; } catch(e){}\n"
                     "                    omitBitmaps = false;\n"
                     "                    omitEPS = false;\n"
                     "                    omitPDF = false;\n"
                     "                    viewPDF = false;\n"
                     "                    optimizePDF = false;\n"
                     "                    interactiveElements = false;\n"
                     "                }\n"
                     "                app.activeDocument.exportFile(ExportFormat.pdfType,\n"
                     "                File(\\\"%@\\\", false));\n"
                     "        \") language javascript\n"
                     "        close active document saving no\n"
                     "    end tell\n"
                     "end timeout\n",
                     oPath,targetSize.height ,targetSize.width, isCenter,
                     INDESIGN,
                     [offsetX stringValue],[offsetY stringValue],[offsetY stringValue],
                     resPath];
    NSString* dbgPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"test.applescript"];
    [ass writeToFile:dbgPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSAppleScript* as = [[NSAppleScript alloc] initWithSource:ass];
    [as executeAndReturnError : &asErrDic ];
    if ( asErrDic ) {
        ret = [asErrDic objectForKey:NSAppleScriptErrorMessage];
        return ret;
    }
    
    return ret;
}

-(IBAction)toggleCenter:(id)sender
{
    if([center state] == NSOnState)
    {
        [offsetX setEnabled:NO];
        [offsetY setEnabled:NO];
    }
    else
    {
        [offsetX setEnabled:YES];
        [offsetY setEnabled:YES];
    }
}


-(IBAction)clearList:(id)sender
{
    [fileData removeAllObjects];
    [fileTable reloadData];
}
-(IBAction)open:(id)sender
{
    NSArray* p = [Macros openFileDialog:@"保存フォルダを選んで下さい" multiple:NO selectFile:NO selectDir:YES];
    [savePath setStringValue:[p objectAtIndex:0]];
}

-(IBAction)go:(id)sender
{
    NSAlert* al = [[NSAlert alloc] init];
    NSString* saveP = [savePath stringValue];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if([saveP compare:@""] == NSOrderedSame)
    {
        [savePath setStringValue:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]];
        saveP = [savePath stringValue];
    }
    NSSize tsize = NSMakeSize([outW floatValue], [outH floatValue]);
    for(int i = 0; i < [fileData count]; i++)
    {
        NSError* error = NULL;
        NSString* resPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"tmp.pdf"];
        if([fm fileExistsAtPath:resPath]) [fm removeItemAtPath:resPath error:nil];
            
        NSString* ret = [self convertStart:tsize processFile:[fileData objectAtIndex:i]];
        if([ret compare:@""] != NSOrderedSame)
        {
            [al setInformativeText:ret];
            [al setMessageText:@"エラー"];
            [al runModal];
            break;
        }
        
        NSArray* isbn = [self getISBN:resPath];
        NSString* toPath = @"";
        if(isbn  != nil)
        {
            toPath = [saveP stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[isbn objectAtIndex:0]]];
            [fm moveItemAtPath:resPath toPath:toPath error:&error];
            if(error != nil)
            {
                [resultData addObject:ARRAY(@"重複ファイルエラー",[fileData objectAtIndex:i], [isbn objectAtIndex:1])];
            }
            else
            {
                [resultData addObject:ARRAY(@"OK",[fileData objectAtIndex:i],[isbn objectAtIndex:1])];
            }
        }
        else
        {
            [resultData addObject:ARRAY(@"ISBN取得エラー",[fileData objectAtIndex:i],@"")];
        }
    }
    [resultWin makeKeyAndOrderFront:self];
    [resultTable noteNumberOfRowsChanged];
    [resultTable reloadData];
}

-(NSImage*)cropImage:(NSImage*)img
{
    NSImage* newImg = [[NSImage alloc] init];
    [newImg setSize:NSMakeSize(50, 468)];
    [newImg lockFocus];
    
    [img drawAtPoint:NSZeroPoint fromRect:NSMakeRect(275, 279, 50, 461) operation:NSCompositingOperationCopy fraction:1.0];
    [newImg unlockFocus];
    return newImg;
}

-(NSImage*)cropImage2:(NSImage*)img
{
    NSImage* newImg = [[NSImage alloc] init];
    [newImg setSize:NSMakeSize(66, 564)];
    [newImg lockFocus];
    
    [img drawAtPoint:NSZeroPoint fromRect:NSMakeRect(126, 744, 66, 564) operation:NSCompositingOperationCopy fraction:1.0];
    [newImg unlockFocus];
    return newImg;
}

-(NSArray*)getISBN:(NSString*)path
{
    NSString* resPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"tmp.jpg"];
    NSString* isbn = @"";
    NSString* fullisbn = @"";
    NSURL* pdfPath = [NSURL fileURLWithPath:path];
    PDFDocument* doc = [[PDFDocument alloc] initWithURL:pdfPath];
    PDFPage* p = [doc pageAtIndex:0];
    CGRect rc = CGPDFPageGetBoxRect([p pageRef], kCGPDFArtBox);
    [Macros pdf2jpg:[p dataRepresentation] path:resPath x:0 y:0 w:rc.size.width h:rc.size.height ratio:6];
    NSImage* img = [[NSImage alloc] initWithContentsOfFile:resPath];
    
    NSString* orgimgPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"org.tif"];
    [[img TIFFRepresentation] writeToFile:orgimgPath atomically:YES];
    
    [[NSFileManager defaultManager] removeItemAtPath:resPath error:nil];
    NSImage* n = [self cropImage:img];
    n = [n imageRotatedByDegrees:270];
    orgimgPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"rot.tif"];
    [[n TIFFRepresentation] writeToFile:orgimgPath atomically:YES];
    
    NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:[n TIFFRepresentation]];
    
    unsigned char* imageData = [imageRep bitmapData];
    
    NSString* ocrTxt = [KZOCR recogImage:imageData
                              pixelsWide:(int)imageRep.pixelsWide
                              pixelsHigh:(int)imageRep.pixelsHigh
                             bytesPerRow:(int)imageRep.bytesPerRow
                            bitsPerPixel:(int)imageRep.bitsPerPixel];
    
    NSAlert* al = [[NSAlert alloc] init];
    [al setInformativeText:ocrTxt];
    [al runModal];
    if([ocrTxt compare:@""] == NSOrderedSame)
    {
        n = [self cropImage2:img];
        n = [n imageRotatedByDegrees:270];
        
        orgimgPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"rot.tif"];
        [[n TIFFRepresentation] writeToFile:orgimgPath atomically:YES];
        imageRep = [NSBitmapImageRep imageRepWithData:[n TIFFRepresentation]];
        
        imageData = [imageRep bitmapData];
        
        ocrTxt = [KZOCR recogImage:imageData
                                  pixelsWide:(int)imageRep.pixelsWide
                                  pixelsHigh:(int)imageRep.pixelsHigh
                                 bytesPerRow:(int)imageRep.bytesPerRow
                                bitsPerPixel:(int)imageRep.bitsPerPixel];
        //ocrTxt = [KZOCR recogImage:n];
    }
    ocrTxt = [ocrTxt stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"([0-9X])*"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    if (error == nil) {
        NSArray *arr = [regex matchesInString:ocrTxt options:0 range:NSMakeRange(0, ocrTxt.length)];
        isbn = [ocrTxt substringWithRange:[[arr objectAtIndex:1] range]];
        if([isbn compare:@""] == NSOrderedSame)
        {
            isbn = [ocrTxt substringWithRange:[[arr objectAtIndex:0] range]];
        }
        fullisbn = isbn;
        if([isbn compare:@""]==NSOrderedSame) return nil;
        isbn = [isbn substringWithRange:NSMakeRange([isbn length] - 7, 6)];
    }
    else
    {
        NSLog(@"正規表現エラー,元のファイル名を使用");
        return nil;
    }
    return ARRAY(isbn,fullisbn);
}

-(IBAction)goOCR:(id)sender
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSAlert* al = [[NSAlert alloc] init];
    NSString* saveP = [savePath stringValue];
    if([saveP compare:@""] == NSOrderedSame)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        [savePath setStringValue:documentsDirectory];
        saveP = [savePath stringValue];
    }
    NSString* resPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"tmp.jpg"];
    
    for(int i = 0; i < [fileData count]; i++)
    {
        NSError* error = NULL;
        if([fm fileExistsAtPath:resPath]) [fm removeItemAtPath:resPath error:nil];
        
        if([[fileData objectAtIndex:i] hasSuffix:@"pdf"])
        {
            NSArray* isbn = [self getISBN:[fileData objectAtIndex:i]];
            NSString* toPath = @"";
            if(isbn != nil)
            {
                toPath = [saveP stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[isbn objectAtIndex:0]]];
                [fm moveItemAtPath:[fileData objectAtIndex:i] toPath:toPath error:&error];
                if (error != nil)
                {
                    [resultData addObject:ARRAY(@"同名ファイルエラー",[fileData objectAtIndex:i],[isbn objectAtIndex:1])];
                }
                else
                {
                    [resultData addObject:ARRAY(@"OK",[fileData objectAtIndex:i],[isbn objectAtIndex:1])];
                }
            }
            else
            {
                [resultData addObject:ARRAY(@"ISBN取得エラー",[fileData objectAtIndex:i],@"")];
                toPath = [saveP stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[Macros getFileName:[fileData objectAtIndex:i]]]];
                [fm moveItemAtPath:[fileData objectAtIndex:i] toPath:toPath error:&error];
            }
        }
        else
        {
            [al setInformativeText:@"PDF以外のファイルです"];
            [al setMessageText:@"エラー"];
            [al runModal];
            break;
        }
    }
    [resultWin makeKeyAndOrderFront:self];
    [resultTable noteNumberOfRowsChanged];
    [resultTable reloadData];
}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark InternalFuncs
//----------------------------------------------------------------------------//
-(void)setDataToTable:(NSArray*)arrfile table:(NSTableView*)aTable
{
    arrfile = [arrfile sortedArrayUsingComparator:^(id o1, id o2){
        return [o1 compare:o2];
    }];
    if(aTable == fileTable)
    {
        fileData = [arrfile mutableCopy];
    }
    [aTable reloadData];
}


#pragma mark -
#pragma mark TableView DataSource
- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    /*if (aTableView == resultTable)
    {
        NSMutableArray* arTmp = [[NSMutableArray alloc] initWithArray:resultData];
        NSMutableArray* rowData = [[resultData objectAtIndex:rowIndex] mutableCopy];
        NSMutableArray* setData = [[NSMutableArray alloc] initWithCapacity:0];
        
        if([[aTableColumn identifier] compare:@"res"] == NSOrderedSame)
        {
            [setData addObject:anObject];
            [setData addObject:[rowData objectAtIndex:1]];
        }
        else if([[aTableColumn identifier] compare:@"path"] == NSOrderedSame)
        {
            [setData addObject:[rowData objectAtIndex:0]];
            [setData addObject:anObject];
        }
        
        [arTmp replaceObjectAtIndex:rowIndex withObject:setData];
        resultData = arTmp;
    }*/
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if(aTableView == fileTable)
    {
        return [fileData count];
    }
    else if (aTableView == resultTable)
    {
        return [resultData count];
    }
    return 0;
}

- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
forTableColumn:(NSTableColumn *)tableColumn
row:(NSInteger)row
{
    if(tableView == resultTable)
    {
        if([Macros isExistString:[[resultData objectAtIndex:row] objectAtIndex:0] searchStr:@"エラー"])
        {
            NSTextFieldCell* c = cell;
            [c setBackgroundColor:[NSColor redColor]];
            [c setDrawsBackground:YES];
        }
        else
        {
            NSTextFieldCell* c = cell;
            [c setBackgroundColor:[NSColor whiteColor]];
            [c setDrawsBackground:YES];
        }
    }
    
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    if(aTableView == fileTable)
    {
        return [[fileData objectAtIndex:rowIndex] lastPathComponent];
    }
    else if (aTableView == resultTable)
    {
        if([[aTableColumn identifier] compare:@"res"] == NSOrderedSame)
        {
            return [[resultData objectAtIndex:rowIndex] objectAtIndex:0];
        }
        else if([[aTableColumn identifier] compare:@"path"] == NSOrderedSame)
        {
            return [[resultData objectAtIndex:rowIndex] objectAtIndex:1];
        }
        else
        {
            return [[resultData objectAtIndex:rowIndex] objectAtIndex:2];
        }
    }
    
    return nil;
}

- (NSString*)searchType:(NSArray*)types
{
    for(int i = 0; i < [types count]; i++)
    {
        if ([[types objectAtIndex:i] compare:NSFilenamesPboardType] == NSOrderedSame)
        {
            return NSFilenamesPboardType;
        }
    }
    return nil;
}

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id <NSDraggingInfo>)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)op
{
    NSDragOperation retOperation = NSDragOperationNone;
    NSArray* dataTypes = [[info draggingPasteboard] types];
    
    if ([[self searchType:dataTypes] compare:NSFilenamesPboardType] == NSOrderedSame)
    {
        // ファイル／フォルダドロップ時
        retOperation = NSDragOperationCopy;
    }
    return retOperation;
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id )info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation
{
    
    NSPasteboard* pboard = [info draggingPasteboard];
    NSArray* dataTypes = [pboard types];
    
    
    if ([[self searchType:dataTypes] compare:NSFilenamesPboardType] == NSOrderedSame)
    {
        // ファイル／フォルダドロップ時
        NSData* data = [pboard dataForType:NSFilenamesPboardType];
        NSError *error;
        NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
        NSArray* theFiles = [NSPropertyListSerialization propertyListWithData:data options:(NSPropertyListReadOptions)NSPropertyListImmutable format:&format error:&error];
        //NSMutableArray* setData = [NSMutableArray array];
        
        for(id file in theFiles)
        {
            if(![Macros isDirectory:file])
            {
                [fileData addObject:file];
            }
            else
            {
                NSArray* arFiles = [Macros getFileList:file deep:NO onlyDir:NO];
                for(id f in arFiles)
                {
                    [fileData addObject:[file stringByAppendingPathComponent:f]];
                }
            }
        }
        [self setDataToTable:[fileData copy] table:aTableView];
        return YES;
        
    }
    return NO;
}


#pragma mark -
#pragma mark NSTableView Delegate
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return YES;
}
@end
