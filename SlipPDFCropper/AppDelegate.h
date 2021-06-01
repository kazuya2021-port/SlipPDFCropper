//
//  AppDelegate.h
//  SlipPDFCropper
//
//  Created by uchiyama_Macmini on 2018/08/16.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>
{
    IBOutlet NSPanel* resultWin;
    IBOutlet NSTableView* resultTable;
    
    IBOutlet NSTableView* fileTable;
    IBOutlet NSTextField* savePath;
    IBOutlet NSTextField* outW;
    IBOutlet NSTextField* outH;
    
    IBOutlet NSTextField* offsetX;
    IBOutlet NSTextField* offsetY;
    IBOutlet NSButton* center;
    
    IBOutlet NSButton* openSave;
    IBOutlet NSButton* fire;
    
    NSMutableArray* fileData;
    NSMutableArray* resultData;
}
-(IBAction)toggleCenter:(id)sender;
-(IBAction)go:(id)sender;
-(IBAction)open:(id)sender;
-(IBAction)clearList:(id)sender;
-(IBAction)goOCR:(id)sender;
@end

