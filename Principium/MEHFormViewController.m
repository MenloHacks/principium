//
//  MEHFormViewController.m
//  Principium
//
//  Created by Jason Scharff on 3/12/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHFormViewController.h"

#import "AutolayoutHelper.h"

@import WebKit;

@interface MEHFormViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation MEHFormViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    //Force view to load which will allow us to start loading the form in the web view before the user sees it.
    [self view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc]init];
    self.webView.navigationDelegate = self;
    if(self.url) {
        //Force loading of web view.
        self.url = self.url;
    }
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.webView];
    
    // Do any additional setup after loading the view.
}

//iOS 12 bug when switching VCs
//Delete this when Apple fixes the bug...eventually?
//https://stackoverflow.com/questions/52735158/wkwebview-shows-gray-background-and-pdf-content-gets-invisible-on-viewcontroller
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.url) {
        [self setUrl:self.url];
    }
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if(self.webView) {
        NSURL *pdf = [NSURL URLWithString:@"https://cdn.filestackcontent.com/71yeKXr1RY6wHdRrfEXs"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"did finish");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"fail");
}

@end
