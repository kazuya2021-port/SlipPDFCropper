//
//  Macro.h
//  Macro
//
//  Created by uchiyama_Macmini on 2017/06/01.
//  Copyright © 2017年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <NetFS/NetFS.h>

#define ARRAY(first, ...) [NSArray arrayWithObjects: first, ##__VA_ARGS__ , nil]
#define APPEND_STR(first, ...) [[[NSArray arrayWithObjects: first, ##__VA_ARGS__ , nil] componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""]
#define RETCODE @"\r\n"
#define ANDP stringByAppendingPathComponent:
#define INT2STR(num) [NSString stringWithFormat:@"%d",num]

#define Log(...)                NSLog(@"[%s][%d] %@", (strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1, __LINE__,__VA_ARGS__);
#define LogC(str)	NSLog(@"[%s][%d] %@ \t %s", (strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1, __LINE__, str, __FUNCTION__);

#define L(...)                NSLog(@"[%s][%d] %@", (strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1, __LINE__,__VA_ARGS__)
#define LRect(title,rect)    NSLog(@"%@: (x, y) = (%.1f, %.1f) (width, height) = (%.1f, %.1f)",title, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define LSize(title,size)    NSLog(@"%@: (width, height) = (%.1f, %.1f)",title, size.width, size.height)
#define LPoint(title,p)        NSLog(@"%@: (x, y) = (%.1f, %.1f)",title, p.x, p.y)


//! Project version number for Macro.
FOUNDATION_EXPORT double MacroVersionNumber;

//! Project version string for Macro.
FOUNDATION_EXPORT const unsigned char MacroVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Macro/PublicHeader.h>

@interface Macros : NSObject
// date func
+(NSString*)getNowDate:(NSString*)format;
+(NSString*)getSeirekiString:(NSString*)wareki;

// string func
+ (NSString*)paddNumber:(int)keta num:(int)num;
+ (NSArray*)searchCharPosition:(NSString*)str searchChar:(NSString*)ch;
+ (BOOL)isExistString:(NSString*)str searchStr:(NSString*)searchStr;

// file func
+ (void)makeFolder:(NSString*)root folderName:(NSString*)name;
+ (NSString*)getFileExp:(NSString*)path;
+ (NSString*)getFileName:(NSString*)path;
+ (BOOL)isDirectory:(NSString *)path;
+ (BOOL)isFile:(NSString *)path;
+ (NSArray*)getFileList:(NSString *)path dirClass:(NSUInteger)dirClass onlyDir:(BOOL)onD;
+ (NSArray*)getFileList:(NSString *)path deep:(BOOL)deep onlyDir:(BOOL)onD;
+ (NSString*)getCurDir:(NSString*)path;

// script func
+ (NSString*)doShellScript:(NSArray*)command;

// dialog func
+(NSArray*)openFileDialog:(NSString*)title multiple:(BOOL)mp selectFile:(BOOL)selectFile selectDir:(BOOL)selectDir;

// FS func
+ (BOOL)mountServer:(NSString*)server userID:(NSString*)user PassWord:(NSString*)pw;
+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request error:(NSError **)error;

// Unit Func
+ (double)mmToPixcel:(double)m dpi:(double)dpi_;
+ (double)pixcelToMm:(double)p dpi:(double)dpi_;

// Other Func
+ (BOOL)checkRectIsZero:(NSRect)src;
+ (BOOL)isEqualToSize:(NSSize)src destination:(NSSize)dest;

// Image Func
+ (NSData*)cvtCGImage2Data:(CGImageRef)rep;
+ (NSImage *)resizeImage:(NSImage *)sourceImage width:(float)resizeWidth height:(float)resizeHeight;
+ (BOOL)pdf2jpg:(NSData*)page path:(NSString*)savePath x:(int)x y:(int)y w:(int)w h:(int)h ratio:(double)ratio;
+ (void)captScreen:(NSRect)rect savePath:(NSString*)savePath;
+ (NSSize)getImageSize:(NSString*)src;
@end

