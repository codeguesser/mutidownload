//
//  MYLoadingPic.m
//  mutidownload
//
//  Created by  on 2012/5/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MYLoadingPic.h"

@implementation MYLoadingPic



- (id)initWithFrame:(CGRect)frame url:(NSString *)_url
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"1.png"]];
        //启动线程
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:_url];
    }
    return self;
}

//线程函数

- (void) downloadImage:(NSString*)url{
    
    subThreed = [NSThread currentThread];
    
    uploadPool = [[NSAutoreleasePool alloc] init];
    characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    if (connection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    
    UIImage* photo = [[UIImage alloc]initWithData:characterBuffer];
    //下载结束，刷新
    [self performSelectorOnMainThread:@selector(fillPhoto:) withObject:photo waitUntilDone:NO];
    // Release resources used only in this thread.
    [photo release];
    
    
    connection = nil;
    [uploadPool release];
    uploadPool = nil;
    
    subThreed = nil;
}

-(void)httpConnectStart{
    prg_Bar = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
    [prg_Bar setProgressViewStyle:UIProgressViewStyleDefault];
    
    [prg_Bar setProgress:0];
    [self addSubview:prg_Bar];
}
-(void)fillPhoto:(UIImage*)image{
    [self setImage:image];
    [prg_Bar removeFromSuperview];
}
#pragma mark NSURLConnection Delegate methods
-(void)httpConnectEnd{
    
}
/*
 Disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    [characterBuffer setLength:0];
    
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Process the downloaded chunk of data.
    
    [prg_Bar setProgress:(prg_Bar.progress+data.length/(float)total) animated:YES];
    [characterBuffer appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES; 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        total = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }
}
@end
