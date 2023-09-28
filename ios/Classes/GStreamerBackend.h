#ifndef __GSTREAMERBACKEND_H__
#define __GSTREAMERBACKEND_H__

#import <Foundation/Foundation.h>

@interface GStreamerBackend : NSObject


-(id) init:(NSString*) pipeline videoView:(UIView*) video_view;

-(void) dealloc;

@end

#endif
