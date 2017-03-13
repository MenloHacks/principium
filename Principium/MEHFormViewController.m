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

@interface MEHFormViewController ()

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
    if(self.url) {
        //Force loading of web view.
        self.url = self.url;
    }
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.webView];
    
    // Do any additional setup after loading the view.
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if(self.webView) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

@end
