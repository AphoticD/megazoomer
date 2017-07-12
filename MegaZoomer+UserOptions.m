//
//  MegaZoomer+UserOptions.m
//  megazoomer
//
//  Created by Daniel Brunet on 12/07/17.
//  Copyright 2017 Daniel Brunet. All rights reserved.
//

#import "MegaZoomer+UserOptions.h"
#import <TargetConditionals.h>

@implementation MegaZoomer(UserOptions)

+ (NSDictionary *) loadMegaZoomerInfoDictionary
{
	int searchDomains[] = { NSUserDomainMask, NSLocalDomainMask };
	
	int i = 0;
	do {
		//locate ourself in ~/Library/Application Support/SIMBL/Plugins/megazoomer.bundle
		//if not found, look in system-wide domain for /Library/Application Support/...

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_3
		NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, 
																searchDomains[i], YES) objectAtIndex:0];
		NSString *bundlePath = [NSString stringWithFormat:@"%@/SIMBL/Plugins", appSupportDir];
#else
		NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, 
																searchDomains[i], YES) objectAtIndex:0];
		NSString *bundlePath = [NSString stringWithFormat:@"%@/Application Support/SIMBL/Plugins", appSupportDir];
#endif

		NSBundle *bundle = [NSBundle bundleWithPath:
							[bundlePath stringByAppendingPathComponent:@"megazoomer.bundle"]];
		
		if(bundle != nil)
			return [bundle infoDictionary];
	} while (i++ < sizeof(searchDomains));
	
	return nil;
} //loadMegaZoomerInfoDictionary


+ (NSSet *) parseCommaSeparatedStringAsSet: (NSString *) string
{
	//splits a string, separated by commas, into an NSSet of unique records

	NSArray *records;
	NSMutableSet *returnSet = [NSMutableSet set]; //create empty mutable set

	if(string != nil && [string isEqualToString:@""] == NO) { //ignores an empty string
	
		if([string rangeOfString:@","].length == 0) { //equals one or zero records, return the whole string
			records = [NSArray arrayWithObject:string];
			
		} else { //string contains one or more comma separated items, so split it up
			records = [string componentsSeparatedByString:@","];
		}
		
		//trim whitespace and newlines from each record as needed
		int i;
		for(i = 0; i < [records count]; i++) {
			NSString *record = [[records objectAtIndex:i] stringByTrimmingCharactersInSet:
								[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			//add non-null records to the mutable set
			if([record isEqualToString:@""] == NO)
				[returnSet addObject: record];
		}
	}

	//return the set as immutable
	return [NSSet setWithSet:returnSet];
	
} //parseCommaSeparatedStringAsSet:


+ (NSString *) infoDictionaryKey: (NSString *) key
{
	//gather string record from Info.plist in the bundle
	NSDictionary *infoDictionary = [self loadMegaZoomerInfoDictionary];
	
	if([infoDictionary valueForKey: key])
		return [infoDictionary valueForKey: key];
	
	return nil;
	
} //infoDictionaryKey:


+ (NSSet *) setFromInfoDictionaryKey: (NSString *) key
{
	return [self parseCommaSeparatedStringAsSet: [self infoDictionaryKey: key]];
	
} //setFromInfoDictionaryKey


+ (BOOL) boolValueOfInfoDictionaryKey: (NSString *) key
{
	if([[[self infoDictionaryKey: key] uppercaseString] isEqualToString: @"YES"])
		return YES;
	
	return NO;
	
} //boolValueOfInfoDictionaryKey:


#pragma mark + User Option Class Methods

+ (BOOL) useLegacyMenuItem
{
	return [self boolValueOfInfoDictionaryKey:@"LegacyMegaZoomInWindowMenu"];
	
} //useLegacyMenuItem


+ (BOOL) useMenuInsertionLogging
{
	return [self boolValueOfInfoDictionaryKey:@"LogMenuInsertion"];
	
} //useMenuInsertionLogging


+ (NSSet *) loadExcludedBundleIdentiferSet
{
	//gather bundle identifiers which are excluded / blacklisted from megazoomer loading
	return [self setFromInfoDictionaryKey: @"ExcludedBundleIdentifiers"];
	
} //loadExcludedBundleIdentiferSet


+ (NSSet *) loadWindowMenuBundleIdentiferSet
{
	//gather bundle identifiers which have been defined to load into the Window menu explicitly
	return [self setFromInfoDictionaryKey: @"WindowMenuBundleIdentifiers"];
	
} //loadWindowMenuBundleIdentiferSet


@end
