#import "libsmsninja.h"

static LSStatusBarItem *centerItem;

NSString *CurrentTime(void)
{
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *dateString = [formatter stringFromDate:date];
	[formatter release];
	return dateString;
}

void LoadBlacklist(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[blackKeywordArray release];
	blackKeywordArray = nil;
	blackKeywordArray = [[NSMutableArray alloc] init];

	[blackTypeArray release];
	blackTypeArray = nil;
	blackTypeArray = [[NSMutableArray alloc] init];

	[blackNameArray release];
	blackNameArray = nil;
	blackNameArray = [[NSMutableArray alloc] init];

	[blackPhoneArray release];
	blackPhoneArray = nil;
	blackPhoneArray = [[NSMutableArray alloc] init];

	[blackSmsArray release];
	blackSmsArray = nil;
	blackSmsArray = [[NSMutableArray alloc] init];

	[blackReplyArray release];
	blackReplyArray = nil;
	blackReplyArray = [[NSMutableArray alloc] init];

	[blackMessageArray release];
	blackMessageArray = nil;
	blackMessageArray = [[NSMutableArray alloc] init];

	[blackForwardArray release];
	blackForwardArray = [[NSMutableArray alloc] init];

	[blackNumberArray release];
	blackNumberArray = nil;
	blackNumberArray = [[NSMutableArray alloc] init];

	[blackSoundArray release];
	blackSoundArray = nil;
	blackSoundArray = [[NSMutableArray alloc] init];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ([[NSFileManager defaultManager] fileExistsAtPath:DATABASE])
		{
			sqlite3 *database;
			sqlite3_stmt *statement;
			int openResult = sqlite3_open([DATABASE UTF8String], &database);
			if (openResult == SQLITE_OK)
			{
				NSString *sql = @"select keyword, type, name, phone, sms, reply, message, forward, number, sound from blacklist";
				int prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
				if (prepareResult == SQLITE_OK)
				{
					while (sqlite3_step(statement) == SQLITE_ROW)
					{
						char *keyword = (char *)sqlite3_column_text(statement, 0);
						[blackKeywordArray addObject:keyword ? @(keyword) : @""];

						char *type = (char *)sqlite3_column_text(statement, 1);
						[blackTypeArray addObject:type ? @(type) : @""];

						char *name = (char *)sqlite3_column_text(statement, 2);
						[blackNameArray addObject:name ? @(name) : @""];

						char *phone = (char *)sqlite3_column_text(statement, 3);
						[blackPhoneArray addObject:phone ? @(phone) : @""];

						char *sms = (char *)sqlite3_column_text(statement, 4);
						[blackSmsArray addObject:sms ? @(sms) : @""];

						char *reply = (char *)sqlite3_column_text(statement, 5);
						[blackReplyArray addObject:reply ? @(reply) : @""];

						char *message = (char *)sqlite3_column_text(statement, 6);
						[blackMessageArray addObject:message ? @(message) : @""];

						char *forward = (char *)sqlite3_column_text(statement, 7);
						[blackForwardArray addObject:forward ? @(forward) : @""];

						char *number = (char *)sqlite3_column_text(statement, 8);
						[blackNumberArray addObject:number ? @(number) : @""];

						char *sound = (char *)sqlite3_column_text(statement, 9);
						[blackSoundArray addObject:sound ? @(sound) : @""];
					}
					sqlite3_finalize(statement);
				}
				else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);

				sqlite3_close(database);
			}
			else NSLog(@"SMSNinja: Failed to open \"%@\", error %d", DATABASE, openResult);
		}
	});
}

void LoadWhitelist(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[whiteKeywordArray release];
	whiteKeywordArray = nil;
	whiteKeywordArray = [[NSMutableArray alloc] init];

	[whiteTypeArray release];
	whiteTypeArray = nil;
	whiteTypeArray = [[NSMutableArray alloc] init];

	[whiteNameArray release];
	whiteNameArray = nil;
	whiteNameArray = [[NSMutableArray alloc] init];

	[whitePhoneArray release];
	whitePhoneArray = nil;
	whitePhoneArray = [[NSMutableArray alloc] init];

	[whiteSmsArray release];
	whiteSmsArray = nil;
	whiteSmsArray = [[NSMutableArray alloc] init];

	[whiteReplyArray release];
	whiteReplyArray = nil;
	whiteReplyArray = [[NSMutableArray alloc] init];

	[whiteMessageArray release];
	whiteMessageArray = nil;
	whiteMessageArray = [[NSMutableArray alloc] init];

	[whiteForwardArray release];
	whiteForwardArray = [[NSMutableArray alloc] init];

	[whiteNumberArray release];
	whiteNumberArray = nil;
	whiteNumberArray = [[NSMutableArray alloc] init];

	[whiteSoundArray release];
	whiteSoundArray = nil;
	whiteSoundArray = [[NSMutableArray alloc] init];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ([[NSFileManager defaultManager] fileExistsAtPath:DATABASE])
		{
			sqlite3 *database;
			sqlite3_stmt *statement;
			int openResult = sqlite3_open([DATABASE UTF8String], &database);
			if (openResult == SQLITE_OK)
			{
				NSString *sql = @"select keyword, type, name, phone, sms, reply, message, forward, number, sound from whitelist";
				int prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
				if (prepareResult == SQLITE_OK)
				{
					while (sqlite3_step(statement) == SQLITE_ROW)
					{
						char *keyword = (char *)sqlite3_column_text(statement, 0);
						[whiteKeywordArray addObject:keyword ? @(keyword) : @""];

						char *type = (char *)sqlite3_column_text(statement, 1);
						[whiteTypeArray addObject:type ? @(type) : @""];

						char *name = (char *)sqlite3_column_text(statement, 2);
						[whiteNameArray addObject:name ? @(name) : @""];

						char *phone = (char *)sqlite3_column_text(statement, 3);
						[whitePhoneArray addObject:phone ? @(phone) : @""];

						char *sms = (char *)sqlite3_column_text(statement, 4);
						[whiteSmsArray addObject:sms ? @(sms) : @""];

						char *reply = (char *)sqlite3_column_text(statement, 5);
						[whiteReplyArray addObject:reply ? @(reply) : @""];

						char *message = (char *)sqlite3_column_text(statement, 6);
						[whiteMessageArray addObject:message ? @(message) : @""];

						char *forward = (char *)sqlite3_column_text(statement, 7);
						[whiteForwardArray addObject:forward ? @(forward) : @""];

						char *number = (char *)sqlite3_column_text(statement, 8);
						[whiteNumberArray addObject:number ? @(number) : @""];

						char *sound = (char *)sqlite3_column_text(statement, 9);
						[whiteSoundArray addObject:sound ? @(sound) : @""];
					}
					sqlite3_finalize(statement);
				}
				else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);

				sqlite3_close(database);
			}
			else NSLog(@"SMSNinja: Failed to open \"%@\", error %d", DATABASE, openResult);
		}
	});
}

void LoadPrivatelist(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[privateKeywordArray release];
	privateKeywordArray = nil;
	privateKeywordArray = [[NSMutableArray alloc] init];

	[privateTypeArray release];
	privateTypeArray = nil;
	privateTypeArray = [[NSMutableArray alloc] init];

	[privateNameArray release];
	privateNameArray = nil;
	privateNameArray = [[NSMutableArray alloc] init];

	[privatePhoneArray release];
	privatePhoneArray = nil;
	privatePhoneArray = [[NSMutableArray alloc] init];

	[privateSmsArray release];
	privateSmsArray = nil;
	privateSmsArray = [[NSMutableArray alloc] init];

	[privateReplyArray release];
	privateReplyArray = nil;
	privateReplyArray = [[NSMutableArray alloc] init];

	[privateMessageArray release];
	privateMessageArray = nil;
	privateMessageArray = [[NSMutableArray alloc] init];

	[privateForwardArray release];
	privateForwardArray = nil;
	privateForwardArray = [[NSMutableArray alloc] init];

	[privateNumberArray release];
	privateNumberArray = nil;
	privateNumberArray = [[NSMutableArray alloc] init];

	[privateSoundArray release];
	privateSoundArray = nil;
	privateSoundArray = [[NSMutableArray alloc] init];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ([[NSFileManager defaultManager] fileExistsAtPath:DATABASE])
		{
			sqlite3 *database;
			sqlite3_stmt *statement;
			int openResult = sqlite3_open([DATABASE UTF8String], &database);
			if (openResult == SQLITE_OK)
			{
				NSString *sql = @"select keyword, type, name, phone, sms, reply, message, forward, number, sound from privatelist";
				int prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
				if (prepareResult == SQLITE_OK)
				{
					while (sqlite3_step(statement) == SQLITE_ROW)
					{
						char *keyword = (char *)sqlite3_column_text(statement, 0);
						[privateKeywordArray addObject:keyword ? @(keyword) : @""];

						char *type = (char *)sqlite3_column_text(statement, 1);
						[privateTypeArray addObject:type ? @(type) : @""];

						char *name = (char *)sqlite3_column_text(statement, 2);
						[privateNameArray addObject:name ? @(name) : @""];

						char *phone = (char *)sqlite3_column_text(statement, 3);
						[privatePhoneArray addObject:phone ? @(phone) : @""];

						char *sms = (char *)sqlite3_column_text(statement, 4);
						[privateSmsArray addObject:sms ? @(sms) : @""];

						char *reply = (char *)sqlite3_column_text(statement, 5);
						[privateReplyArray addObject:reply ? @(reply) : @""];

						char *message = (char *)sqlite3_column_text(statement, 6);
						[privateMessageArray addObject:message ? @(message) : @""];

						char *forward = (char *)sqlite3_column_text(statement, 7);
						[privateForwardArray addObject:forward ? @(forward) : @""];

						char *number = (char *)sqlite3_column_text(statement, 8);
						[privateNumberArray addObject:number ? @(number) : @""];

						char *sound = (char *)sqlite3_column_text(statement, 9);
						[privateSoundArray addObject:sound ? @(sound) : @""];
					}
					sqlite3_finalize(statement);
				}
				else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);

				sqlite3_close(database);
			}
			else NSLog(@"SMSNinja: Failed to open \"%@\", error %d", DATABASE, openResult);
		}
	});
}

void LoadAllLists(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	LoadBlacklist(nil, nil, nil, nil, nil);
	LoadWhitelist(nil, nil, nil, nil, nil);
	LoadPrivatelist(nil, nil, nil, nil, nil);
}

void LoadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[settings release];
	settings = nil;
	settings = [[NSDictionary alloc] initWithContentsOfFile:SETTINGS];

	LoadAllLists(nil, nil, nil, nil, nil);	
}

void ReloadConversation(void)
{
	if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0)
	{
		if (![[[NSProcessInfo processInfo] processName] isEqualToString:@"MobileSMS"])
		{
			CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.mobilesms"];
			[messagingCenter sendMessageName:@"RefreshConversation" userInfo:nil];
		}
		else [(SMSApplication *)[UIApplication sharedApplication] snHandleMessageNamed:@"RefreshConversation" withUserInfo:nil];
	}
}

static NSString *CurrentCountryCode(void)
{
	CFStringRef myPhoneNumber = CTSettingCopyMyPhoneNumber(kCFAllocatorDefault);
	CFStringRef activeCountryCode = CPPhoneNumberCopyActiveCountryCode(kCFAllocatorDefault);
	CFStringRef formattedPhoneNumber = UIFormattedPhoneNumberFromStringWithCountry(myPhoneNumber, activeCountryCode);
	NSString *countryCode = @"";
	if ([(NSString *)formattedPhoneNumber hasPrefix:@"+"]) countryCode = [[(NSString *)formattedPhoneNumber substringToIndex:[(NSString *)formattedPhoneNumber rangeOfString:@" "].location] stringByReplacingOccurrencesOfString:@"+" withString:@""];
	if (myPhoneNumber != nil) CFRelease(myPhoneNumber);
	if (activeCountryCode != nil) CFRelease(activeCountryCode);
	return countryCode;
}

static NSString *LongestCommonSubstring(NSString *string1, NSString *string2)
{
	if (string1 == nil || string1.length == 0 || string2 == nil || string2.length == 0) return nil;
	NSMutableDictionary *map = [NSMutableDictionary dictionary];
	int maxlen = 0;
	int lastSubsBegin = 0;
	NSMutableString *sequenceBuilder = [NSMutableString string];

	for (int i = 0; i < string1.length; i++)
	{
		for (int j = 0; j < string2.length; j++)
		{
			unichar substringC = [[string1 lowercaseString] characterAtIndex:i];
			unichar stringC = [[string2 lowercaseString] characterAtIndex:j];

			if (substringC != stringC) {
				[map setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%i%i",i,j]];
			}
			else {
				if ((i == 0) || (j == 0)) {
					[map setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%i%i",i,j]];
				}
				else {
					int prevVal = [[map objectForKey:[NSString stringWithFormat:@"%i%i",i-1,j-1]] intValue];
					[map setObject:[NSNumber numberWithInt:1+prevVal] forKey:[NSString stringWithFormat:@"%i%i",i,j]];
				}
				int currVal = [[map objectForKey:[NSString stringWithFormat:@"%i%i",i,j]] intValue];
				if (currVal > maxlen) {
					maxlen = currVal;
					int thisSubsBegin = i - currVal + 1;
					if (lastSubsBegin == thisSubsBegin)
					{ // if the current LCS is the same as the last time this block ran
						NSString *append = [NSString stringWithFormat:@"%C",substringC];
						[sequenceBuilder appendString:append];
					}
					else // this block resets the string builder if a different LCS is found
					{
						lastSubsBegin = thisSubsBegin;
						NSString *resetStr = [string1 substringWithRange:NSMakeRange(lastSubsBegin, (i + 1) - lastSubsBegin)];
						sequenceBuilder = [NSMutableString stringWithFormat:@"%@",resetStr];
					}
				}
			}
		}
	}
	return sequenceBuilder;
}	

static void FinishedPlaying(SystemSoundID systemSoundID, void *clientData)
{
	AudioServicesRemoveSystemSoundCompletion(systemSoundID);    
	AudioServicesDisposeSystemSoundID(systemSoundID);
}

static void PlaySound(const char *type)
{
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"/var/mobile/Library/SMSNinja/%s.caf", type]];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID(url, &soundID);
	AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, FinishedPlaying, NULL);
	AudioServicesPlayAlertSound(soundID);
}

void PlayFilterSound(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) PlaySound("private");
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		[messagingCenter sendMessageName:@"PlayFilterSound" userInfo:nil];
	}
}

void PlayBlockSound(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) PlaySound("blocked");
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		[messagingCenter sendMessageName:@"PlayBlockSound" userInfo:nil];
	}
}

static void AnimatePurpleSquare(BOOL hide)
{
	if (hide) [(SpringBoard *)[UIApplication sharedApplication] removeStatusBarImageNamed:@"PurpleSquare"];
	else [(SpringBoard *)[UIApplication sharedApplication] addStatusBarImageNamed:@"PurpleSquare"];
}

void ShowPurpleSquare(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) AnimatePurpleSquare(NO);
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		[messagingCenter sendMessageName:@"ShowPurpleSquare" userInfo:nil];
	}
}

void HidePurpleSquare(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) AnimatePurpleSquare(YES);
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		[messagingCenter sendMessageName:@"HidePurpleSquare" userInfo:nil];
	}
}

static void AnimateIcon(BOOL hide)
{
	void* libHandle = dlopen("/usr/lib/hide.dylib", RTLD_LAZY);
	if (libHandle != NULL)
	{
		BOOL (*IsIconHiddenDisplayId)(NSString* Plist) = (BOOL (*)(NSString *))dlsym(libHandle, "IsIconHiddenDisplayId");
		BOOL (*HideIconViaDisplayId)(NSString* Plist) = (BOOL (*)(NSString *))dlsym(libHandle, "HideIconViaDisplayId");
		BOOL (*UnHideIconViaDisplayId)(NSString* Plist) = (BOOL (*)(NSString *))dlsym(libHandle, "UnHideIconViaDisplayId");
		if (IsIconHiddenDisplayId != NULL)
		{
			NSString *identifier = @"com.naken.smsninja";
			if ((!hide && IsIconHiddenDisplayId(identifier) && UnHideIconViaDisplayId != NULL)) UnHideIconViaDisplayId(identifier);
			else if (hide && HideIconViaDisplayId != NULL) HideIconViaDisplayId(identifier);
		}
		dlclose(libHandle);
	}
}

void HideIcon(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) AnimateIcon(YES);
	else
	{
			CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
			[messagingCenter sendMessageName:@"HideIcon" userInfo:nil];
	}
}

void ShowIcon(void)
{
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) AnimateIcon(NO);
	else
	{
			CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
			[messagingCenter sendMessageName:@"ShowIcon" userInfo:nil];
	}
}

void UpdateBadge(void)
{
	if ([[settings objectForKey:@"appIsOn"] boolValue])
	{
		if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"])
		{
			NSString *messageCount = @"";
			NSString *callCount = @"";

			sqlite3 *database;
			sqlite3_stmt *statement;	
			int openResult = sqlite3_open([DATABASE UTF8String], &database);
			if (openResult == SQLITE_OK)
			{
				NSString *sql = @"select count(*) from blockedsms where read = '0'";
				int prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
				if (prepareResult == SQLITE_OK)
				{
					while (sqlite3_step(statement) == SQLITE_ROW)
					{
						char *count = (char *)sqlite3_column_text(statement, 0);
						messageCount = count ? @(count) : @"";
					}
					sqlite3_finalize(statement);
				}
				else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);

				sql = @"select count(*) from blockedcall where read = '0'";
				prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
				if (prepareResult == SQLITE_OK)
				{
					while (sqlite3_step(statement) == SQLITE_ROW)
					{
						char *count = (char *)sqlite3_column_text(statement, 0);
						callCount = count ? @(count) : @"";
					}
					sqlite3_finalize(statement);
				}
				else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);
				
				SBIconModel *iconModel = nil;
				if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0) iconModel = [objc_getClass("SBIconModel") sharedInstance];
				else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) iconModel = [(SBIconController *)[objc_getClass("SBIconController") sharedInstance] model];
				SBIcon *icon;
				if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0) icon = [iconModel applicationIconForDisplayIdentifier:@"com.naken.smsninja"];
				else icon = [iconModel applicationIconForBundleIdentifier:@"com.naken.smsninja"];
				
				if ([messageCount intValue] + [callCount intValue] == 0)
				{
					[icon setBadge:nil];
					[centerItem release];
					centerItem = nil;
					centerItem = [[objc_getClass("LSStatusBarItem") alloc] initWithIdentifier:@"com.naken.smsninja.purplesquare" alignment:4];
					[centerItem setTitleString:nil];
				}
				else
				{
					NSFileManager *fileManager = [NSFileManager defaultManager];
					NSString *badge = nil;
					if ([[settings objectForKey:@"shouldShowSemicolon"] boolValue] && [fileManager fileExistsAtPath:@"/var/mobile/Library/SMSNinja/UnreadPrivateInfo"]) badge = [NSString stringWithFormat:@"%@;%@", callCount, messageCount];
					else badge = [NSString stringWithFormat:@"%@,%@", callCount, messageCount];
					if ([[settings objectForKey:@"shouldShowIconBadge"] boolValue]) [icon setBadge:badge];
					else [icon setBadge:nil];
					if ([[settings objectForKey:@"shouldShowStatusBarBadge"] boolValue])
					{
						[centerItem release];
						centerItem = nil;
						centerItem = [[objc_getClass("LSStatusBarItem") alloc] initWithIdentifier:@"com.naken.smsninja.purplesquare" alignment:4];
						[centerItem setTitleString:badge];
					}
					else
					{
						[centerItem release];
						centerItem = nil;
						centerItem = [[objc_getClass("LSStatusBarItem") alloc] initWithIdentifier:@"com.naken.smsninja.purplesquare" alignment:4];
						[centerItem setTitleString:nil];
					}
				}
				sqlite3_close(database);
			}
		}
		else
		{
			CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
			[messagingCenter sendMessageName:@"UpdateBadge" userInfo:nil];
		}
	}
	else if (![[settings objectForKey:@"appIsOn"] boolValue] && [[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"])
	{
		SBIconModel *iconModel = nil;
		if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0) iconModel = [objc_getClass("SBIconModel") sharedInstance];
		else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) iconModel = [(SBIconController *)[objc_getClass("SBIconController") sharedInstance] model];
		SBIcon *icon = nil;
		if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0) icon = [iconModel applicationIconForDisplayIdentifier:@"com.naken.smsninja"];
		else icon = [iconModel applicationIconForBundleIdentifier:@"com.naken.smsninja"];

		[icon setBadge:nil];
		[centerItem release];
		centerItem = nil;
		centerItem = [[objc_getClass("LSStatusBarItem") alloc] initWithIdentifier:@"com.naken.smsninja.purplesquare" alignment:4];
		[centerItem setTitleString:nil];
	}
}

static void PersistentSave(const char *actionType, const char *infoType, NSString *text, NSString *name, NSArray *addressArray, BOOL isFromMe, NSArray *pictureArray)
{
	sqlite3 *database;
	sqlite3_stmt *statement;
	int openResult = sqlite3_open([DATABASE UTF8String], &database);
	if (openResult == SQLITE_OK)
	{
		for (NSString *address in addressArray)
		{
			// update database
			NSString *sql = [NSString stringWithFormat:@"select max(cast(id as integer)) from %s%s", actionType, infoType];
			NSString *idString = @"1";
			int prepareResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
			if (prepareResult == SQLITE_OK)
			{
				while (sqlite3_step(statement) == SQLITE_ROW)
				{
					char *identifier = (char *)sqlite3_column_text(statement, 0);
					idString = identifier ? @(identifier) : @"";
					idString = [NSString stringWithFormat:@"%d", ([idString intValue] + 1)];
				}
				sqlite3_finalize(statement);
			}
			else NSLog(@"SMSNinja: Failed to prepare \"%@\", error %d", sql, prepareResult);

			if ([name length] == 0) name = [address nameInAddressBook];
			else if ([name hasSuffix:@"*"])
			{
				NSString *addressAsName = [name substringToIndex:([name length] - 1)];
				NSString *newName = [addressAsName nameInAddressBook];
				if ([newName length] != 0) name = [newName stringByAppendingString:@"*"];
			}

			sql = [NSString stringWithFormat:@"insert into %s%s (id, content, name, number, time, pictures, read) values ('%@', '%@', '%@', '%@', '%@', '%lu', '0')", actionType, infoType, idString, [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [name length] == 0 ? [address stringByReplacingOccurrencesOfString:@"'" withString:@"''"] : [name stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [address stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [CurrentTime() stringByAppendingString:isFromMe ? @" ↗" : @" ↙"], (unsigned long)[pictureArray count]];
			int execResult = sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
			if (execResult != SQLITE_OK) NSLog(@"SMSNinja: Failed to exec \"%@\", error %d", sql, execResult);

			// save attachments
			for (UIImage *image in pictureArray)
			{
				NSString *fileName = [NSString stringWithFormat:@"%@%@-%lu.png", strcmp(actionType, "blocked") == 0 ? PICTURES : PRIVATEPICTURES, idString, (unsigned long)[pictureArray indexOfObject:image]];
				[UIImagePNGRepresentation(image) writeToFile:fileName atomically:YES];
			}
		}
		sqlite3_close(database);

		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (!isFromMe && strcmp(actionType, "private") == 0 && ![fileManager fileExistsAtPath:@"/var/mobile/Library/SMSNinja/UnreadPrivateInfo"])
		{
			[fileManager createFileAtPath:@"/var/mobile/Library/SMSNinja/UnreadPrivateInfo" contents:nil attributes:nil];
			if ([[settings objectForKey:@"appIsOn"] boolValue] && [[settings objectForKey:@"shouldShowPurpleSquare"] boolValue]) ShowPurpleSquare();
		}
		UpdateBadge();
	}
	else NSLog(@"SMSNinja: Failed to open \"%@\", error %d", DATABASE, openResult);
}

NSUInteger ActionOfAudioFunctionWithInfo(NSArray *addressArray, BOOL isFromMe) // 0 for off, 1 for disconnect, 2 for ignore, 3 for let go
{
	if ([[settings objectForKey:@"appIsOn"] boolValue])
	{	
		NSString *text = isFromMe ? @"1" : @"0";
		NSString *time = CurrentTime();
		NSArray *pictureArray = [NSArray array];
		for (NSString *address in addressArray)
		{
			NSUInteger index = NSNotFound;

			if ((index = [address indexInPrivateListWithType:0]) != NSNotFound)
			{
				if (!isFromMe && [[privateReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[privateMessageArray objectAtIndex:index]];
				if (!isFromMe && [[privateSoundArray objectAtIndex:index] intValue] == 1) PlayFilterSound();
				if ([[privatePhoneArray objectAtIndex:index] intValue] != 0)
				{
					PersistentSave("private", "call", text, [privateNameArray objectAtIndex:index], addressArray, isFromMe, pictureArray);
					return [[privatePhoneArray objectAtIndex:index] intValue];
				}
			}
			else if ((index = [address indexInWhiteListWithType:0]) != NSNotFound)
			{
				return 0;
			}
			else if ([address isInAddressBook] && [[settings objectForKey:@"shouldIncludeContactsInWhitelist"] boolValue])
			{
				return 0;
			}
			else if ((index = [address indexInBlackListWithType:0]) != NSNotFound)
			{
				if (!isFromMe && [[blackReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[blackMessageArray objectAtIndex:index]];
				if (!isFromMe && [[blackSoundArray objectAtIndex:index] intValue] == 1) PlayBlockSound();
				if (!isFromMe && [[blackPhoneArray objectAtIndex:index] intValue] != 0) PersistentSave("blocked", "call", text, blackNameArray[index], addressArray, isFromMe, pictureArray);
				if ([[blackPhoneArray objectAtIndex:index] intValue] != 0) return [[blackPhoneArray objectAtIndex:index] intValue];
			}
			else if ((index = [time indexInBlackListWithType:2]) != NSNotFound)
			{
				if (!isFromMe && [[blackReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[blackMessageArray objectAtIndex:index]];
				if (!isFromMe && [[blackSoundArray objectAtIndex:index] intValue] == 1) PlayBlockSound();
				if (!isFromMe && [[blackPhoneArray objectAtIndex:index] intValue] != 0) PersistentSave("blocked", "call", text, blackNameArray[index], addressArray, isFromMe, pictureArray);
				if ([[blackPhoneArray objectAtIndex:index] intValue] != 0) return [[blackPhoneArray objectAtIndex:index] intValue];
			}
			else if ((index = [address indexInWhiteListWithType:0]) == NSNotFound && ([[settings objectForKey:@"whitelistCallsOnlyWithBeep"] boolValue] || [[settings objectForKey:@"whitelistCallsOnlyWithoutBeep"] boolValue]))
			{
				if (!isFromMe && [[settings objectForKey:@"whitelistCallsOnlyWithBeep"] boolValue]) PlayBlockSound();
				if (!isFromMe) PersistentSave("blocked", "call", text, [address stringByAppendingString:@"*"], addressArray, isFromMe, pictureArray);
				return 1;
			}
		}
	}
	return 0;
}

NSUInteger ActionOfTextFunctionWithInfo(NSArray *addressArray, NSString *text, NSArray *pictureArray, BOOL isFromMe) // 0 for off, 1 for filter, 2 for block
{
	if ([[settings objectForKey:@"appIsOn"] boolValue])
	{
		NSString *time = CurrentTime();
		for (NSString *address in addressArray)
		{
			NSUInteger index = NSNotFound;

			if ((index = [address indexInPrivateListWithType:0]) != NSNotFound)
			{
				if (!isFromMe && [[privateReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[privateMessageArray objectAtIndex:index]];
				if (!isFromMe && [[privateForwardArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] forward:text to:[privateNumberArray objectAtIndex:index]];
				if (!isFromMe && [[privateSoundArray objectAtIndex:index] intValue] == 1) PlayFilterSound();
				if ([[privateSmsArray objectAtIndex:index] intValue] != 0)
				{
					PersistentSave("private", "sms", text, [privateNameArray objectAtIndex:index], addressArray, isFromMe, pictureArray);
					return [[privateSmsArray objectAtIndex:index] intValue];
				}
			}
			else if ((index = [text indexInPrivateListWithType:1]) != NSNotFound)
			{
				if (!isFromMe && [[privateReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[privateMessageArray objectAtIndex:index]];
				if (!isFromMe && [[privateForwardArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] forward:text to:[privateNumberArray objectAtIndex:index]];
				if (!isFromMe && [[privateSoundArray objectAtIndex:index] intValue] == 1) PlayFilterSound();
				if ([[privateSmsArray objectAtIndex:index] intValue] != 0)
				{
					PersistentSave("private", "sms", text, [privateNameArray objectAtIndex:index], addressArray, isFromMe, pictureArray);
					return [[privateSmsArray objectAtIndex:index] intValue];
				}
			}
			else if ((index = [address indexInWhiteListWithType:0]) != NSNotFound)
			{
				return 0;
			}
			else if ((index = [text indexInWhiteListWithType:1]) != NSNotFound)
			{
				return 0;
			}
			else if ([address isInAddressBook] && [[settings objectForKey:@"shouldIncludeContactsInWhitelist"] boolValue])
			{
				return 0;
			}
			else if ((index = [address indexInBlackListWithType:0]) != NSNotFound)
			{
				if (!isFromMe && [[blackReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[blackMessageArray objectAtIndex:index]];
				if (!isFromMe && [[blackForwardArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] forward:text to:[blackNumberArray objectAtIndex:index]];
				if (!isFromMe && [[blackSoundArray objectAtIndex:index] intValue] == 1) PlayBlockSound();
				if (!isFromMe && [[blackSmsArray objectAtIndex:index] intValue] == 1)
				{
					PersistentSave("blocked", "sms", text, blackNameArray[index], addressArray, isFromMe, pictureArray);
					return 2;
				}
			}
			else if ((index = [text indexInBlackListWithType:1]) != NSNotFound)
			{
				if (!isFromMe && [[blackReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[blackMessageArray objectAtIndex:index]];
				if (!isFromMe && [[blackForwardArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] forward:text to:[blackNumberArray objectAtIndex:index]];
				if (!isFromMe && [[blackSoundArray objectAtIndex:index] intValue] == 1) PlayBlockSound();
				if (!isFromMe && [[blackSmsArray objectAtIndex:index] intValue] == 1)
				{
					PersistentSave("blocked", "sms", text, blackNameArray[index], addressArray, isFromMe, pictureArray);
					return 2;
				}
			}
			else if ((index = [time indexInBlackListWithType:2]) != NSNotFound)
			{
				if (!isFromMe && [[blackReplyArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] reply:address with:[blackMessageArray objectAtIndex:index]];
				if (!isFromMe && [[blackForwardArray objectAtIndex:index] intValue] == 1) [[SNTelephonyManager sharedManager] forward:text to:[blackNumberArray objectAtIndex:index]];
				if (!isFromMe && [[blackSoundArray objectAtIndex:index] intValue] == 1) PlayBlockSound();
				if (!isFromMe && [[blackSmsArray objectAtIndex:index] intValue] == 1)
				{
					PersistentSave("blocked", "sms", text, blackNameArray[index], addressArray, isFromMe, pictureArray);
					return 2;
				}
			}
			else if ((index = [address indexInWhiteListWithType:0]) == NSNotFound && (index = [text indexInWhiteListWithType:1]) == NSNotFound && ([[settings objectForKey:@"whitelistMessagesOnlyWithBeep"] boolValue] || [[settings objectForKey:@"whitelistMessagesOnlyWithoutBeep"] boolValue]))
			{
				if (!isFromMe && [[settings objectForKey:@"whitelistMessagesOnlyWithBeep"] boolValue]) PlayBlockSound();
				if (!isFromMe) PersistentSave("blocked", "sms", text, [address stringByAppendingString:@"*"], addressArray, isFromMe, pictureArray);
				return 2;
			}
		}
	}
	return 0;
}

@implementation NSString (libsmsninja)
- (NSString *)normalizedPhoneNumber
{
	if ([self rangeOfString:@"@"].location == NSNotFound)
		for (NSString *toBeReplaced in @[@" ", @"-", @"(", @")"])
			self = [self stringByReplacingOccurrencesOfString:toBeReplaced withString:@""];
	return self;
}

- (BOOL)isRegularlyEqualTo:(NSString *)stringInList
{
	NSString *pattern = [stringInList stringByReplacingOccurrencesOfString:@"*" withString:@".*" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringInList length])];
	pattern = [@"^" stringByAppendingString:pattern];
	pattern = [pattern stringByAppendingString:@"$"];

	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	if (!error && regex)
	{
		NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
		if (numberOfMatches > 0)
		{
			NSLog(@"SMSNinja: \"%@\" matches regex \"%@\" (\"%@\").", self, pattern, stringInList);
			return YES;
		}
	}
	else if (error) NSLog(@"SMSNinja: Failed to generate regex from pattern \"%@\", error \"%@\"", pattern, [error localizedDescription]);

	NSString *longestCommonSubstring = LongestCommonSubstring(self, stringInList);
	if ([longestCommonSubstring length] >= 8 && [self hasSuffix:longestCommonSubstring] && [stringInList hasSuffix:longestCommonSubstring])
	{
		NSLog(@"SMSNinja: \"%@\" and \"%@\" shares the same suffix \"%@\".", self, stringInList, longestCommonSubstring);
		return YES;
	}

	return NO;
}

- (NSString *)stringByRemovingCharacters
{
	NSString *text = self;
	for (NSString *character in @[@" ", @"~", @"`", @"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*", @"(", @")", @"-", @"=", @"_", @"+", @"{", @"}", @"[", @"]", @"|", @"\\", @":", @";", @"\"", @"'", @"<", @">", @",", @".", @"?", @"/", @"·", @"！", @"￥", @"⋯⋯", @"（", @"）", @"——", @"【", @"】", @"、", @"：", @"；", @"“", @"”", @"‘", @"’", @"《", @"》", @"，", @"。", @"？"]) text = [text stringByReplacingOccurrencesOfString:character withString:@""];
	return text;
}

- (NSUInteger)indexInPrivateListWithType:(int)type // 0 for number, 1 for content
{
	if (type == 0)
	{
		NSString *countryCode = CurrentCountryCode();
		for (NSString *address in privateKeywordArray)
		{
			NSUInteger index = [privateKeywordArray indexOfObject:address];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[privateTypeArray objectAtIndex:index]] && [[[self stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] isRegularlyEqualTo:[[address stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""]])
			{
				NSLog(@"SMSNinja: \"%@\" as address is in privatelist", self);
				return index;
			}
		}			
	}
	else if (type == 1)
	{
		for (NSString *keyword in privateKeywordArray)
		{
			NSUInteger index = [privateKeywordArray indexOfObject:keyword];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[privateTypeArray objectAtIndex:index]] && ([self rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound || [[self stringByRemovingCharacters] rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound))
			{
				NSLog(@"SMSNinja: \"%@\" contains keyword \"%@\" in privatelist", self, keyword);
				return index;
			}
		}
	}
	NSLog(@"SMSNinja: \"%@\" is NOT in privatelist", self);
	return NSNotFound;
}

- (NSUInteger)indexInBlackListWithType:(int)type // 0 for number, 1 for content, 2 for time
{
	if (type == 0)
	{
		NSString *countryCode = CurrentCountryCode();
		for (NSString *address in blackKeywordArray)
		{
			NSUInteger index = [blackKeywordArray indexOfObject:address];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[blackTypeArray objectAtIndex:index]] && [[[self stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] isRegularlyEqualTo:[[address stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""]])
			{
				NSLog(@"SMSNinja: \"%@\" as address is in blacklist", self);
				return index;
			}
		}	
	}
	else if (type == 1)
	{	
		for (NSString *keyword in blackKeywordArray)
		{
			NSUInteger index = [blackKeywordArray indexOfObject:keyword];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[blackTypeArray objectAtIndex:index]] && ([self rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound || [[self stringByRemovingCharacters] rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound))
			{
				NSLog(@"SMSNinja: \"%@\" contains keyword \"%@\" in blacklist", self, keyword);
				return index;
			}
		}
	}
	else if (type == 2)
	{
		for (NSString *time in blackKeywordArray)
		{
			NSUInteger index = [blackKeywordArray indexOfObject:time];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[blackTypeArray objectAtIndex:index]])
			{
				NSString *startTime = [[time substringToIndex:[time rangeOfString:@"~"].location] stringByReplacingOccurrencesOfString:@":" withString:@""];
				NSString *endTime = [[time substringFromIndex:([time rangeOfString:@"~"].location + 1)] stringByReplacingOccurrencesOfString:@":" withString:@""];
				NSString *currentTime = [[self substringFromIndex:11] stringByReplacingOccurrencesOfString:@":" withString:@""];

				if ((([endTime intValue] > [startTime intValue] && [currentTime intValue] > [startTime intValue] && [currentTime intValue] < [endTime intValue]) || ([endTime intValue] < [startTime intValue] && ([currentTime intValue] > [startTime intValue] || [currentTime intValue] < [endTime intValue])) || ([currentTime intValue] == [startTime intValue] || [currentTime intValue] == [endTime intValue])))
				{
					NSLog(@"SMSNinja: \"%@\" as time is in blacklist", self);
					return index;
				}
			}
		}
	}
	NSLog(@"SMSNinja: \"%@\" is NOT in blacklist", self);
	return NSNotFound;
}

- (NSUInteger)indexInWhiteListWithType:(int)type // 0 for number, 1 for content
{
	if (type == 0)
	{
		NSString *countryCode = CurrentCountryCode();
		for (NSString *address in whiteKeywordArray)
		{
			NSUInteger index = [whiteKeywordArray indexOfObject:address];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[whiteTypeArray objectAtIndex:index]] && [[[self stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] isRegularlyEqualTo:[[address stringByReplacingOccurrencesOfString:countryCode withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""]])
			{
				NSLog(@"SMSNinja: \"%@\" as address is in whitelist", self);
				return index;
			}
		}	
	}
	else if (type == 1)
	{
		for (NSString *keyword in whiteKeywordArray)
		{
			NSUInteger index = [whiteKeywordArray indexOfObject:keyword];
			if ([[NSString stringWithFormat:@"%d", type] isEqualToString:[whiteTypeArray objectAtIndex:index]] && ([self rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound || [[self stringByRemovingCharacters] rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound))
			{
				NSLog(@"SMSNinja: \"%@\" contains keyword \"%@\" in whitelist", self, keyword);
				return index;
			}
		}
	}
	NSLog(@"SMSNinja: \"%@\" is NOT in whitelist", self);
	return NSNotFound;
}

- (BOOL)isInAddressBook // number
{
	BOOL result = NO;
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"])
	{
		ABAddressBookRef addressbook = ABAddressBookCreate();
		ABRecordRef record = nil;
		NSUInteger unknown = NSNotFound;
		if ([self rangeOfString:@"@"].location == NSNotFound) // number
		{
			NSString *countryCode = CurrentCountryCode();
			if ([countryCode length] != 0)
			{
				CFStringRef internationalCode = NULL;
				void *libHandle = NULL;
				if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
				{		
					static CFStringRef (*UICountryCodeForInternationalCode)(CFStringRef);
					libHandle = dlopen("/System/Library/Frameworks/UIKit.framework/UIKit", RTLD_LAZY);
					UICountryCodeForInternationalCode = (CFStringRef (*)(CFStringRef))dlsym(libHandle, "UICountryCodeForInternationalCode");
					internationalCode = UICountryCodeForInternationalCode((CFStringRef)countryCode);
				}
				else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
				{
					static CFStringRef (*TUISOCountryCodeForMCC)(CFStringRef);
					libHandle = dlopen("/System/Library/PrivateFrameworks/TelephonyUtilities.framework/TelephonyUtilities", RTLD_LAZY);
					TUISOCountryCodeForMCC = (CFStringRef (*)(CFStringRef))dlsym(libHandle, "TUISOCountryCodeForMCC");
					internationalCode = TUISOCountryCodeForMCC((CFStringRef)countryCode);
				}
				record = ABAddressBookFindPersonMatchingPhoneNumberWithCountry(addressbook, (CFStringRef)self, internationalCode, &unknown, 0);
				dlclose(libHandle);
			}
			if (!record) record = ABAddressBookFindPersonMatchingPhoneNumber(addressbook, (CFStringRef)self, &unknown, 0);
		}
		else record = ABAddressBookFindPersonMatchingEmailAddress(addressbook, (CFStringRef)self, &unknown); // email
		result = record ? YES : NO;
		if (addressbook != nil) CFRelease(addressbook);			
	}
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		NSDictionary *reply = [messagingCenter sendMessageAndReceiveReplyName:@"CheckAddressBook" userInfo:@{@"address" : self}];
		result = [(NSNumber *)[reply objectForKey:@"result"] boolValue];
	}
	if (result) NSLog(@"SMSNinja: \"%@\" as address is in addressbook", self);
	else NSLog(@"SMSNinja: \"%@\" is NOT in addressbook", self);
	return result;
}

- (NSString *)nameInAddressBook
{
	NSString *name = @"";
	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"])
	{
		ABAddressBookRef addressbook = ABAddressBookCreate();
		ABRecordRef record = nil;
		NSUInteger unknown = NSNotFound;
		if ([self rangeOfString:@"@"].location == NSNotFound) // number
		{
			NSString *countryCode = CurrentCountryCode();
			if ([countryCode length] != 0)
			{
				CFStringRef internationalCode = NULL;
				void *libHandle = NULL;
				if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
				{		
					static CFStringRef (*UICountryCodeForInternationalCode)(CFStringRef);
					libHandle = dlopen("/System/Library/Frameworks/UIKit.framework/UIKit", RTLD_LAZY);
					UICountryCodeForInternationalCode = (CFStringRef (*)(CFStringRef))dlsym(libHandle, "UICountryCodeForInternationalCode");
					internationalCode = UICountryCodeForInternationalCode((CFStringRef)countryCode);
				}
				else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
				{
					static CFStringRef (*TUISOCountryCodeForMCC)(CFStringRef);
					libHandle = dlopen("/System/Library/PrivateFrameworks/TelephonyUtilities.framework/TelephonyUtilities", RTLD_LAZY);
					TUISOCountryCodeForMCC = (CFStringRef (*)(CFStringRef))dlsym(libHandle, "TUISOCountryCodeForMCC");
					internationalCode = TUISOCountryCodeForMCC((CFStringRef)countryCode);
				}
				record = ABAddressBookFindPersonMatchingPhoneNumberWithCountry(addressbook, (CFStringRef)self, internationalCode, &unknown, 0);
				dlclose(libHandle);				
			}
			if (!record) record = ABAddressBookFindPersonMatchingPhoneNumber(addressbook, (CFStringRef)self, &unknown, 0);
		}
		else record = ABAddressBookFindPersonMatchingEmailAddress(addressbook, (CFStringRef)self, &unknown); // email
		if (record != nil)
		{
			CFStringRef firstName = (CFStringRef)ABRecordCopyValue(record, kABPersonFirstNameProperty);
			CFStringRef lastName = (CFStringRef)ABRecordCopyValue(record, kABPersonLastNameProperty);
			name = [[firstName ? (NSString *)firstName : @"" stringByAppendingString:@" "] stringByAppendingString:lastName ? (NSString *)lastName : @""];
			if (firstName != nil) CFRelease(firstName);
			if (lastName != nil) CFRelease(lastName);
		}
		if (addressbook != nil) CFRelease(addressbook);
	}
	else
	{
		CPDistributedMessagingCenter *messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.naken.smsninja.springboard"];
		NSDictionary *reply = [messagingCenter sendMessageAndReceiveReplyName:@"GetAddressBookName" userInfo:@{@"address" : self}];
		name = [reply objectForKey:@"result"];
	}
	if ([name length] != 0) NSLog(@"SMSNinja: Address \"%@\" matches name \"%@\" in addressbook", self, name);
	else NSLog(@"SMSNinja: Address \"%@\" doesn't match any name in addressbook", self);
	return name;
}
@end
