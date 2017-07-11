//
//  MegaZoomer+KeyEquiv.h
//  megazoomer
//
//  Created by Daniel Brunet on 4/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

//  Category to add functionality to MegaZoomer for scanning the main menu of the
//  active application, searching for an existing keyboard shortcut (keyEquivalent with modifierKeys).
//  returns true (YES) if a menu item was found with a match.
//
//  Call example:	
//
//    if([[self class] mainMenuHasKeyEquivalent: keyEquiv withModifierFlags: keyMask])
//      NSLog(@"Keyboard shortcut match found");
//
//  This allows us to assign a unique (unused) keyboard shortcut

#import <Cocoa/Cocoa.h>
#import "MegaZoomer.h"

@interface MegaZoomer(KeyEquiv)

+ (BOOL) mainMenuHasKeyEquivalent: (NSString *) keyEquivalent 
				withModifierFlags: (unsigned int) modifierFlags;

@end
