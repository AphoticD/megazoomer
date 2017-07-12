//
//  MegaZoomer+MenuInsert.m
//  megazoomer
//
//  Created by Daniel Brunet on 5/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

#import "MegaZoomer.h"
#import "MegaZoomer+MenuInsert.h"
#import "MegaZoomer+KeyEquiv.h"
#import "MegaZoomer+UserOptions.h"

@implementation MegaZoomer(MenuInsert)

+ (NSMenu *) menuWithTitle:(NSString *) menuTitle
{
	NSMenuItem *menuItem = [[[NSApplication sharedApplication] mainMenu] itemWithTitle:menuTitle];
	
	if([menuItem hasSubmenu])
		return [menuItem submenu];
	
	return nil;
	
} //menuWithTitle


+ (NSMenuItem *) menuItem: (NSString *) menuItem
				   inMenu: (NSString *) menuTitle
{
	//refer to @"@firstItem" or @"@lastItem" string constants 
	//to define top or bottom item in the menu
	
	NSMenu *menu = [self menuWithTitle:menuTitle];
	
	if(menu != nil) {		
		if([menuItem isEqualToString:@"@firstItem"])
			return (NSMenuItem *)[menu itemAtIndex:0];
			
		if([menuItem isEqualToString:@"@lastItem"])
			return (NSMenuItem *)[menu itemAtIndex:[[menu itemArray] count] - 1];
		
		return (NSMenuItem *)[menu itemWithTitle:menuItem];
	}
	
	return nil;
	
} //menuItem:inMenu


- (void) createMenu: (NSString *) menuTitle
		 beforeMenu: (NSString *) menuAfterTitle
	orBeforeAltMenu: (NSString *) altMenuAfterTitle
{
	NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
	int insertionIndex = 0;
	
	//work out insertion index
	if([mainMenu itemWithTitle:menuAfterTitle]) {
		insertionIndex = [mainMenu indexOfItemWithTitle:menuAfterTitle];

	} else if([mainMenu itemWithTitle:altMenuAfterTitle]) {
		insertionIndex = [mainMenu indexOfItemWithTitle:altMenuAfterTitle];
		
	} else { //neither menus were found, so add the new menu to the end
		insertionIndex = [[mainMenu itemArray] count] - 1;
	}
		
	//prepare new menu item and submenu
	NSMenuItem *item = [[[NSMenuItem  alloc] initWithTitle: menuTitle
													action: NULL
											 keyEquivalent: @""] autorelease];
	
	NSMenu *subMenu = [[[NSMenu alloc] initWithTitle:menuTitle] autorelease];
	[mainMenu setSubmenu:subMenu forItem:item];
	[mainMenu insertItem:item atIndex:insertionIndex];
	
} //createMenu:beforeMenu:orBeforeAltMenu:


- (NSMenuItem *) insertMenuItem: (NSString *) menuItem 
						 inMenu: (NSString *) menuTitle
				afterItemTitled: (NSString *) precedingMenuItemTitle
					 withAction: (SEL) menuAction
				  keyEquivelant: (NSString *) keyEquivelant
				   usingKeyMask: (unsigned int) keyMask
			       addSeparator: (int) signedSeparatorPosition
{
	NSMenu *menu = [[self class] menuWithTitle:menuTitle];
	
	if(menu != nil) {
		
		int insertionIndex = 0;
		NSMenuItem *item = [[[NSMenuItem  alloc] initWithTitle: menuItem
														action: menuAction
												 keyEquivalent: keyEquivelant] autorelease];
		[item setKeyEquivalentModifierMask:keyMask];
		[item setTarget:self];
		[item setRepresentedObject:self];
		
		if(precedingMenuItemTitle != nil) { //if not nil, search for the preceding menu item
			NSMenuItem *precedingMenuItem = [[self class] menuItem: precedingMenuItemTitle inMenu: menuTitle];
			
			if(precedingMenuItem != nil) { //the item exists, grab it's index
				int indexOfPrecedingMenuItem = [menu indexOfItem:precedingMenuItem];
				
				if(signedSeparatorPosition == -1) //add a separator line before the new menu item
					[menu insertItem: [NSMenuItem separatorItem] atIndex: ++indexOfPrecedingMenuItem ];

				//set the insertion index to be after the preceding item
				insertionIndex = ++indexOfPrecedingMenuItem;
			}
		}
		
		//if precedingMenuItem was sent through as nil, then the insertionIndex will be zero (top of the menu)
		[menu insertItem:item atIndex:insertionIndex];
		
		if(signedSeparatorPosition == 1) //add a separator line after the new menu item
			[menu insertItem: [NSMenuItem separatorItem] atIndex: ++insertionIndex ];

		return item; //success
	}
	
	return nil; //the menuTitle was not found
	
} //insertMenuItem:::::::


- (BOOL) insertMenuItemOfType: (MenuItemType) menuItemType
{
	NSMenuItem *menuItem;
	NSString *menuItemTitle, *menuTitle, *precedingItem, *keyEquiv;
	unsigned int keyMask;
	int signedSeparatorPosition;
	
	switch (menuItemType) {
		case menuItemMegaZoom:
			//insert "Mega Zoom" below "Zoom" in the Window menu with shortcut cmd-Enter
			menuItemTitle = @"Mega Zoom";
			menuTitle = @"Window";
			precedingItem = @"Zoom";
			keyEquiv = @"\n";
			keyMask = NSCommandKeyMask;
			signedSeparatorPosition = 0; //none
			break;
			
		case menuItemFullScreen:
			//insert "Enter Full Screen" with a separator at the end of the View menu with shortcut ctrl-cmd-F
			menuItemTitle = @"Enter Full Screen";
			menuTitle = @"View";
			precedingItem = @"@lastItem";
			keyEquiv = @"f";
			keyMask = (NSCommandKeyMask|NSControlKeyMask);
			signedSeparatorPosition = -1; //before new item
			break;
	}
	
	//check the WindowMenuBundleIdentifiers (in Info.plist) to determine if the new menuItem will be
	//explicitly inserted into the Window Menu, and if so, place it at the top.
	//(this check is ignored in "Legacy" mode).
	if(menuItemType != menuItemMegaZoom && [[[self class] loadWindowMenuBundleIdentiferSet] 
											containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
		menuTitle = @"Window";
		precedingItem = nil;
	}
	
	//confirm the target menu exists, if not, create it, placing it before Window or Help
	if([[self class] menuWithTitle:menuTitle] == nil) { 
		[self createMenu:menuTitle
			  beforeMenu:@"Window" 
		 orBeforeAltMenu:@"Help"];
		precedingItem = nil; //put the new menuItem at the top of the new menu (addSeparator flag will be ignored)

	} else { //the menu does already exist
	
		//add a separator line after the new item if not empty and nothing precedes it.
		if([[[[self class] menuWithTitle:menuTitle] itemArray] count] > 0 && precedingItem == nil)
			signedSeparatorPosition = 1; //after the new item
	}
	
	//check if the menu item title already exists and append "(Zoom)" to title if so
	if([[self class] menuItem:menuItemTitle inMenu:menuTitle])
		menuItemTitle = [NSString stringWithFormat:@"%@ (Zoom)", menuItemTitle];

	//scan all menus via the +KeyEquiv category class method to determine if the key equivalent is in use
	if([[self class] mainMenuHasKeyEquivalent: keyEquiv withModifierFlags: keyMask]) {
		keyMask |= NSAlternateKeyMask; //bitwise add the option key
		
		//test again for keyEquiv uniqueness
		if([[self class] mainMenuHasKeyEquivalent: keyEquiv withModifierFlags: keyMask]) {
			keyMask |= NSShiftKeyMask; //bitwise add the shift key
			keyMask ^= NSControlKeyMask; //and remove the control key

			//final test...
			if([[self class] mainMenuHasKeyEquivalent: keyEquiv withModifierFlags: keyMask])
				keyMask |= NSControlKeyMask; //bitwise add the control key again (it's a bit awkward though)
		}
	}	
	
	//create the new menu item
	menuItem = [self insertMenuItem: menuItemTitle
							 inMenu: menuTitle
					afterItemTitled: precedingItem
						 withAction: @selector(megaZoom:)
					  keyEquivelant: keyEquiv
					   usingKeyMask: keyMask
				       addSeparator: signedSeparatorPosition];	
	
	if(menuItem != nil) { //log the insertion

		[self setZoomerMenuItem:menuItem]; //save menuItem to zoomer ivar
		
		if([[self class] useMenuInsertionLogging] == YES)
			NSLog(@"%@ %@ '%@' in %@ OK.", NSStringFromClass([self class]), 
				  NSStringFromSelector(_cmd), [menuItem title], 
				  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]);
		
		return YES;
	}
	
	return NO;
	
} //insertMenuItemOfType:


- (void)toggleMenuItemTitle
{
	NSString *menuTitle = [[self zoomerMenuItem] title];
	
	if([menuTitle rangeOfString:@"Enter"].length > 0) {
		menuTitle = [[menuTitle componentsSeparatedByString:@"Enter"] componentsJoinedByString:@"Exit"];
		
	} else if([menuTitle rangeOfString:@"Exit"].length > 0) {
		menuTitle = [[menuTitle componentsSeparatedByString:@"Exit"] componentsJoinedByString:@"Enter"];
	}
	
	if([[[self zoomerMenuItem] title] isEqualToString:menuTitle] == NO)
		[[self zoomerMenuItem] setTitle: menuTitle];

} //toggleMenuItemTitle

@end
