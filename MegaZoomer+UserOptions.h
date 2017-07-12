//
//  MegaZoomer+UserOptions.h
//  megazoomer
//
//  Created by Daniel Brunet on 12/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

//  Category to add functionality to MegaZoomer for loading user options, such as the exclusion
//  NSSet of bundleIdentifiers which is cross referenced when loading to prevent MegaZoomer from
//  loading in specified apps.
//
//  Comma separated "ExcludedBundleIdentifiers" string property added to Info.plist 
//  in the megazoomer.bundle;
//  
//  Exclusion list example: com.apple.finder, com.apple.calculator, com.floodgap.tenfourfox
//
//  Call example: NSSet *doesntWork = [[self class] loadExcludedBundleIdentiferSet];

//  Adding bundle identifiers to the "WindowMenuBundleIdentifers" will force megazoomer to
//  insert into the Window menu on these specified apps. (Some apps do tricky stuff to their
//  menus after load, such as Safari 1.3.2 (Panther) flushing and reinstating it's View menu)

#import <Cocoa/Cocoa.h>
#import "MegaZoomer.h"

@interface MegaZoomer(UserOptions)

//user option class methods
+ (BOOL) useLegacyMenuItem;
+ (BOOL) useMenuInsertionLogging;
+ (NSSet *) loadExcludedBundleIdentiferSet;
+ (NSSet *) loadWindowMenuBundleIdentiferSet;

@end
