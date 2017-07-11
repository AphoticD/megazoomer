//
//  MegaZoomer.h
//  megazoomer
//
//  Created by Ian Henderson on 20.09.05.
//  Copyright 2005 Ian Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MegaZoomer : NSObject {

	NSMenuItem *zoomerMenuItem;
}

+ (NSMenuItem *) zoomMenuItem;

//user option class methods
+ (BOOL) useLegacyMenuItem;
+ (BOOL) useMenuInsertionLogging;

//ivar accessor methods
- (NSMenuItem *) zoomerMenuItem;
- (void) setZoomerMenuItem:(NSMenuItem *) aMenuItem;

@end
