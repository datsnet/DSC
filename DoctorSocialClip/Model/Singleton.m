//
//  Singleton.m
//  TypingTraining
//
//  Created by 福市 誠 on 09/09/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton

static NSMutableDictionary* _instance = nil;


+ (id) instance;
{

	@synchronized( self )
	{
		if( [ _instance objectForKey:NSStringFromClass(self)] == nil )
		{
			[[ self alloc ] init ];
		}
	}
	return [ _instance objectForKey:NSStringFromClass(self)];
}

+(id)allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if( [_instance objectForKey:NSStringFromClass(self)] == nil )
		{
			id inst = [super allocWithZone:zone ];
			if( [_instance count ] == 0 )
			{
				_instance = [[NSMutableDictionary alloc ] initWithCapacity:0 ];
			}
			
			[ _instance setObject: inst forKey:NSStringFromClass(self) ];
			
			return inst;
		}
	}
	return nil;
}

-(id)copyWithZone:(NSZone*)zone
{
	return self;
}

-(id)retain
{
	return self;
}

-(unsigned)retainCount
{
	return UINT_MAX;
}

-(oneway void) release
{
}

-( id )autorelease
{
	return self;
}

+( void ) deleteInstance
{
	if( [ _instance objectForKey:NSStringFromClass(self)] != nil )
	{
		@synchronized( self )
		{
			[self release ];
		}
	}
}

-( void ) dealloc
{
	// このクラスの削除処理を追加
	[ super dealloc ];
}
@end
