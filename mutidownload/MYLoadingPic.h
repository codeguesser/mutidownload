//
//  MYLoadingPic.h
//  mutidownload
//
//  Created by  on 2012/5/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLoadingPic : UIImageView{
    BOOL done;
    long total;
    
    
    
    NSAutoreleasePool *uploadPool;
    NSThread *subThreed;
    NSMutableData *characterBuffer;
    NSURLConnection *connection;
    UIProgressView *prg_Bar;

}

- (id)initWithFrame:(CGRect)frame url:(NSString *)_url;
- (void) downloadImage:(NSString*)url;
-(void)httpConnectEnd;
-(void)fillPhoto:(UIImage*)image;
-(void)httpConnectStart;
@end
