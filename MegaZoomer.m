//
//  MegaZoomer.m
//  megazoomer
//
//  Created by Ian Henderson on 20.09.05.
//  Copyright 2005 Ian Henderson. All rights reserved.
//

#import "MegaZoomer.h"
#import "ZoomableWindow.h"
#import "MegaZoomer+KeyEquiv.h"
#import "MegaZoomer+UserOptions.h"
#import "MegaZoomer+MenuInsert.h"


@implementation MegaZoomer

+ (NSMenuItem *) zoomMenuItem
{
	return [self menuItem:@"Zoom" inMenu:@"Window"];
	
} //zoomMenuItem


- (BOOL) insertMenu
{
	if([[self class] useLegacyMenuItem] == YES) { //class method in +UserOptions category

		//MenuItemType typedef in +MenuInsert category header
		if([self insertMenuItemOfType: menuItemMegaZoom]) //instance method in +MenuInsert category
			return YES; //success
		
	} else {
		if([self insertMenuItemOfType: menuItemFullScreen])
			return YES;
	}
	
	return NO; //insertion failed

} //insertMenuItem:


+ (BOOL) megazoomerWorksHere
{	
	//check against the ExcludedBundleIdentifiers User Option to see if the current app bundle is listed
	//returns false if found in set as it has been 'blacklisted' by the user.
    return ![[self loadExcludedBundleIdentiferSet] containsObject:[[NSBundle mainBundle] bundleIdentifier]];
} //megazoomerWorksHere


+ (void) load
{
	static MegaZoomer *zoomer = nil;
	
	if (zoomer == nil) {
		zoomer = [[self alloc] init];
		
        if ([self megazoomerWorksHere])
			if ([zoomer insertMenu])
				[NSWindow swizzleZoomerMethods];
	}
} //load


- (BOOL) validateMenuItem:(id <NSMenuItem>)item
{
    return [[NSApp keyWindow] isMegaZoomable];
} //validateMenuItem


- (void) megaZoom:(id) sender
{
	[self toggleMenuItemTitle];
    [[NSApp keyWindow] toggleMegaZoom];
} //megaZoom:


#pragma mark - Instance Variable Accessor Methods


- (NSMenuItem *) zoomerMenuItem
{
	return zoomerMenuItem;
} //zoomerMenuItem


- (void) setZoomerMenuItem:(NSMenuItem *) aMenuItem
{
	[zoomerMenuItem release];
	[aMenuItem retain];
	zoomerMenuItem = aMenuItem;
} //setZoomerMenuItem:


@end
