//
//  MegaZoomer+Exclusions.h
//  megazoomer
//
//  Created by Daniel Brunet on 4/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

//  Category to add functionality to MegaZoomer for loading an exclusion NSSet of bundleIdentifiers
//  which is cross referenced when loading to prevent MegaZoomer from loading in specified apps.
//
//  Comma separated "ExcludedBundleIdentifiers" string property added to Info.plist 
//  in the megazoomer.bundle;
//  
//  Exclusion list example: com.apple.finder, com.apple.calculator, com.floodgap.tenfourfox
//
//  Call example: NSSet *doesntWork = [[self class] loadExcludedBundleIdentiferSet];

#import <Cocoa/Cocoa.h>
#import "MegaZoomer.h"

@interface MegaZoomer(Exclusions)

+ (NSDictionary *) loadMegaZoomerInfoDictionary;
+ (NSSet *) loadExcludedBundleIdentiferSet;

@end
