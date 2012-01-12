//
//  Singleton.h
//  TypingTraining
//
//  Created by 福市 誠 on 09/09/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject {

}

+ (id) instance;
+ (void ) deleteInstance;
@end
