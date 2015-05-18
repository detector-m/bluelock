//
//  WebViewVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/18.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "WebViewVC.h"

@implementation WebViewVC
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebView];
}

- (void)setupWebView {
    CGRect frame = self.view.frame;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    [self loadRequest];
}

- (void)loadRequest {
    [self.webView loadRequest:[self requestForWebContent:self.url]];
}

- (NSURLRequest *)requestForWebContent:(NSString *)aUrl {
    DLog(@"%@", aUrl);
    NSURL *newsUrl = [NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:newsUrl];
    return request;
}

#pragma mark -

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [RLHUD hudProgressWithBody:nil onView:webView timeout:5.0f];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [RLHUD hideProgress];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"error=%@", error);
    [RLHUD hideProgress];
}
@end
