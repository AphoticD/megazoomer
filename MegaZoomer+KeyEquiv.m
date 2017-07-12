//
//  MegaZoomer+KeyEquiv.m
//  megazoomer
//
//  Created by Daniel Brunet on 4/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_3
#define kDeviceIndependentModifierFlagsMask &NSDeviceIndependentModifierFlagsMask
#else
#define kDeviceIndependentModifierFlagsMask
#endif

#import "MegaZoomer+KeyEquiv.h"

@implementation MegaZoomer(KeyEquiv)

+ (BOOL) compareKeyEquivalentOfMenuItem: (NSMenuItem *) menuItem 
							  withEvent: (NSEvent *) theEvent
{
	NSString *menuItemKeyEquivalent = [menuItem keyEquivalent];
	unsigned int menuItemModifierFlags = [menuItem keyEquivalentModifierMask] kDeviceIndependentModifierFlagsMask;
	
	NSString *eventKeyEquivalent = [theEvent charactersIgnoringModifiers];
	unsigned int eventModifierFlags = [theEvent modifierFlags] kDeviceIndependentModifierFlagsMask;

	if([eventKeyEquivalent isEqualTo:menuItemKeyEquivalent] &&
	   eventModifierFlags == menuItemModifierFlags)
		return YES; //we found a matching menu item using this keyboard shortcut
	
	return NO;
	
} //compareKeyEquivalentOfMenuItem:withEvent:


+ (BOOL) recursivelyScanMenus: (NSMenu *) menu 
		performingTruthAction: (SEL) action
				   withObject: (id) object
{
	NSArray *menuItemArray = [menu itemArray];
	int i;
	for(i = 0; i < [menuItemArray count]; i++) {
		NSMenuItem *menuItem = [menuItemArray objectAtIndex:i];
		if([self performSelector:action 
					  withObject:menuItem 
					  withObject:object])
			return YES; //a truth was found
		
		//if menuItem has a submenu, call this method again to scan infinitely deep into submenus
		if([menuItem hasSubmenu])
			if([self recursivelyScanMenus: [menuItem submenu]
					performingTruthAction: action
							   withObject: object])
				return YES; //a truth was found within the recursive call
	}
	
	return NO; //no truth was found in the menus
	
} //recursivelyScanMenus:performingTruthAction:withObject:


+ (BOOL) mainMenuHasKeyEquivalent: (NSString *) keyEquivalent 
				withModifierFlags: (unsigned int) modifierFlags
{
	//synthesize a keyDown event to send as an object for comparison 
	NSEvent *theEvent = [NSEvent keyEventWithType:NSKeyDown
										 location:NSMakePoint(0,0)
									modifierFlags:modifierFlags
										timestamp:0
									 windowNumber:0
										  context:nil
									   characters:keyEquivalent
					  charactersIgnoringModifiers:keyEquivalent
										isARepeat:NO
										  keyCode:0];
	
	NSMenu *menu = [[NSApplication sharedApplication] mainMenu];
	
	//scan through each submenu recursively searching for a match
	if([self recursivelyScanMenus:menu 
			performingTruthAction:@selector(compareKeyEquivalentOfMenuItem:withEvent:)
					   withObject:theEvent])
		return YES; //truth action returned YES; the key equivalent was found in the menu

	return NO; //key equivalent not found, which means it is safe to assign
	
} //mainMenuHasKeyEquivalent:withModifierFlags:

@end
