
#import "CommonWebViewController.h"

@interface CommonWebViewController ()
{
}
@end

@implementation CommonWebViewController
@synthesize strUrl;
@synthesize strTitle;
@synthesize webView;

- (id)initWithMOC:(NSManagedObjectContext *)MOC {
    
    self = [super initWithMOC:MOC];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.strUrl = nil;
    self.strTitle = nil;
    
    [self closeAsyncLoadingView];
    [self.webView setDelegate:nil];
    [self.webView stopLoading];
    self.webView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    self.title = self.strTitle;
        
    CGRect frame = CGRectMake(self.view.frame.origin.x, 0.0, SCREEN_WIDTH, self.view.frame.size.height);
    
    // web view
    CGRect webFrame = frame;
    self.webView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.userInteractionEnabled = YES;
    
    if (![self.strUrl hasPrefix:@"http://"]) {
        self.strUrl = [NSString stringWithFormat:@"http://%@",self.strUrl];
    }
    NSURL *url = [NSURL URLWithString:[self.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
}

#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self closeAsyncLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self closeAsyncLoadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
