//
//  ORSTimelineCacheManager.m
//  Timeline Cache Controller
//
//  Created by Nicholas Toumpelis on 22/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 22/11/2008

#import "ORSTimelineCacheManager.h"

@implementation ORSTimelineCacheManager

@synthesize followingStatusCache, repliesStatusCache, publicStatusCache, 
	archiveStatusCache, receivedMessagesCache, sentMessagesCache,
	firstFollowingCall, firstRepliesCall, firstPublicCall, 
	firstArchiveCall, firstReceivedMessagesCall, firstSentMessagesCall,
	lastFollowingStatusID, lastReplyStatusID, lastPublicStatusID,
	lastArchiveStatusID, lastReceivedMessageID, lastSentMessageID, 
	favoritesStatusCache, firstFavoriteCall, lastFavoriteStatusID;

- (id) init {
	if (self = [super init]) {
		// Following cache
		//followingStatusCache = [[NSMutableArray array] retain];
		followingStatusCache = [NSMutableArray array];
		firstFollowingCall = YES;
		//lastFollowingStatusID = [[NSString string] retain];
		lastFollowingStatusID = [NSString string];
		// Replies cache
		//repliesStatusCache = [[NSMutableArray array] retain];
		repliesStatusCache = [NSMutableArray array];
		firstRepliesCall = YES;
		//lastReplyStatusID = [[NSString string] retain];
		lastReplyStatusID = [NSString string];
		// Public cache
		//publicStatusCache = [[NSMutableArray array] retain];
		publicStatusCache = [NSMutableArray array];
		firstPublicCall = YES;
		//lastPublicStatusID = [[NSString string] retain];
		lastPublicStatusID = [NSString string];
		// Archive cache
		//archiveStatusCache = [[NSMutableArray array] retain];
		archiveStatusCache = [NSMutableArray array];
		firstArchiveCall = YES;
		//lastArchiveStatusID = [[NSString string] retain];
		lastArchiveStatusID = [NSString string];
		// Received Messages cache
		//receivedMessagesCache = [[NSMutableArray array] retain];
		receivedMessagesCache = [NSMutableArray array];
		firstReceivedMessagesCall = YES;
		//lastReceivedMessageID = [[NSString string] retain];
		lastReceivedMessageID = [NSString string];
		// Sent Messages cache
		//sentMessagesCache = [[NSMutableArray array] retain];
		sentMessagesCache = [NSMutableArray array];
		firstSentMessagesCall = YES;
		//lastSentMessageID = [[NSString string] retain];
		lastSentMessageID = [NSString string];
		// Favorites cache
		//favoritesStatusCache = [[NSMutableArray array] retain];
		favoritesStatusCache = [NSMutableArray array];
		firstFavoriteCall = YES;
		//lastFavoriteStatusID = [[NSString string] retain];
		lastFavoriteStatusID = [NSString string];
	}
	return self;
}

- (void) resetAllCaches {
	[favoritesStatusCache removeAllObjects];
	[followingStatusCache removeAllObjects];
	[repliesStatusCache removeAllObjects];
	[publicStatusCache removeAllObjects];
	[archiveStatusCache removeAllObjects];
	[receivedMessagesCache removeAllObjects];
	[sentMessagesCache removeAllObjects];
	
	firstFavoriteCall = YES;
	firstFollowingCall = YES;
	firstRepliesCall = YES;
	firstPublicCall = YES;
	firstArchiveCall = YES;
	firstReceivedMessagesCall = YES;
	firstSentMessagesCall = YES;
}

- (NSMutableArray *) setStatusesForTimelineCache:(NSUInteger)timelineCacheType 
					withNotification:(NSNotification *)note{
	BOOL *firstCall;
	NSMutableArray *cache;
	NSString **lastStatusID;
	if (timelineCacheType == ORSFollowingTimelineCacheType) {
		firstCall = &firstFollowingCall;
		cache = followingStatusCache;
		lastStatusID = &lastFollowingStatusID;
	} else if (timelineCacheType == ORSArchiveTimelineCacheType) {
		firstCall = &firstArchiveCall;
		cache = archiveStatusCache;
		lastStatusID = &lastArchiveStatusID;
	} else if (timelineCacheType == ORSPublicTimelineCacheType) {
		firstCall = &firstPublicCall;
		cache = publicStatusCache;
		lastStatusID = &lastPublicStatusID;
	} else if (timelineCacheType == ORSRepliesTimelineCacheType) {
		firstCall = &firstRepliesCall;
		cache = repliesStatusCache;
		lastStatusID = &lastReplyStatusID;
	} else if (timelineCacheType == ORSFavoritesTimelineCacheType) {
		firstCall = &firstFavoriteCall;
		cache = favoritesStatusCache;
		lastStatusID = &lastFavoriteStatusID;
	} else if (timelineCacheType == ORSReceivedMessagesTimelineCacheType) {
		firstCall = &firstReceivedMessagesCall;
		cache = receivedMessagesCache;
		lastStatusID = &lastReceivedMessageID;
	} else if (timelineCacheType == ORSSentMessagesTimelineCacheType) {
		firstCall = &firstSentMessagesCall;
		cache = sentMessagesCache;
		lastStatusID = &lastSentMessageID;
	}
	
	if (*firstCall) {
		[cache setArray:(NSArray *)[note object]];
	} else {
		NSIndexSet *indexSet = [NSIndexSet 
			indexSetWithIndexesInRange:NSMakeRange(0, 
				[(NSArray *)[note object] count])];
		[cache insertObjects:(NSArray *)[note object] atIndexes:indexSet];
	}
	
	NSError *error = NULL;
	if ([cache count] > 0) {
		NSXMLNode *lastNode = (NSXMLNode *)[cache objectAtIndex:0];
		NSArray *lastCreatedAt = [lastNode nodesForXPath:@".//id" error:&error];
		NSXMLNode *lastCreatedAtNode = (NSXMLNode *)[lastCreatedAt 
													 objectAtIndex:0];
		*lastStatusID = [[lastCreatedAtNode stringValue] retain];
		*firstCall = NO;
	}
	return cache;
}

@end
