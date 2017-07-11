//
//  MegaZoomer+MenuInsert.h
//  megazoomer
//
//  Created by Daniel Brunet on 5/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

//  Category to add functionality to MegaZoomer for setting up and inserting the menu commands.
//  Default option is to insert "Enter Full Screen" at the bottom of the View menu with keyboard
//  shortcut Ctrl-Cmd-F. Checks for uniqueness and changes shortcut modifier keys if required.
//
//  Adds routine to check whether to use the classic (Legacy) Mega Zoom (cmd-Enter) command in the 
//  Window menu (See Info.plist for settings). Methods specify type and specifics of the command.
//  Calls are made to +KeyEquiv category methods for scanning main menu for key equivalent uniqueness.
//
//  Call examples:
//
//    if([[self class] menuItem:@"Zoom" inMenu:@"Window"])
//      NSLog(@"Window menu has the Zoom command");
//
//    [self insertMenuItemOfType:menuItemMegaZoom]; //triggers the menu item insertion for the MegaZoom (legacy) type
//

#import <Cocoa/Cocoa.h>
#import "MegaZoomer.h"

typedef enum {
	menuItemMegaZoom = 1,
	menuItemFullScreen
} MenuItemType;

@interface MegaZoomer(MenuInsert)

+ (NSMenuItem *) menuItem: (NSString *) menuItem
				   inMenu: (NSString *) menuTitle;

- (BOOL) insertMenuItemOfType: (MenuItemType) menuItemType;
- (void) toggleMenuItemTitle;

@end
