//
//  MegaZoomer+Exclusions.m
//  megazoomer
//
//  Created by Daniel Brunet on 4/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

#import "MegaZoomer+Exclusions.h"


@implementation MegaZoomer(Exclusions)

+ (NSDictionary *) loadMegaZoomerInfoDictionary
{
	int searchDomains[] = { NSUserDomainMask, NSLocalDomainMask };
	
	int i = 0;
	do {
		//locate ourself in ~/Library/Application Support/SIMBL/Plugins/megazoomer.bundle
		//if not found, look in system-wide domain for /Library/Application Support/...
		NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, 
																searchDomains[i], YES) objectAtIndex:0];
		NSString *bundlePath = [NSString stringWithFormat:@"%@/SIMBL/Plugins", appSupportDir];
		NSBundle *bundle = [NSBundle bundleWithPath:
							[bundlePath stringByAppendingPathComponent:@"megazoomer.bundle"]];
		
		if(bundle != nil)
			return [bundle infoDictionary];
	} while (i++ < sizeof(searchDomains));
	
	return nil;
} //loadMegaZoomerInfoDictionary


+ (NSSet *) loadExcludedBundleIdentiferSet
{
	//gather excluded bundle identifiers string record from the Info.plist in the mainBundle
	//split the string into an array, separated by commas
	NSDictionary *infoDictionary = [self loadMegaZoomerInfoDictionary];
	NSArray *identifiers;
	NSMutableSet *returnSet = [NSMutableSet set];
	
	if([infoDictionary valueForKey:@"ExcludedBundleIdentifiers"]) {
		NSString *bundleList = [infoDictionary valueForKey:@"ExcludedBundleIdentifiers"];
		
		if([bundleList rangeOfString:@","].length == 0) { //equals one or zero records, pass the whole string
			identifiers = [NSArray arrayWithObject:bundleList];
			
		} else { //string contains one or more comma separated items, so split it up
			identifiers = [bundleList componentsSeparatedByString:@","];
		}
		
		//trim whitespace and newlines from each record as needed
		int i;
		for(i = 0; i < [identifiers count]; i++) {
			NSString *record = [[identifiers objectAtIndex:i] stringByTrimmingCharactersInSet:
								[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			//add non-null records to the mutable set
			if([record isEqualToString:@""] == NO)
				[returnSet addObject: record];
		}
	}
	
	//return the set as immutable
	return [NSSet setWithSet:returnSet];
	
} //loadExcludedBundleIdentiferSet

@end
