
#import <UIKit/UIKit.h>

#import "ProjectAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([ProjectAppDelegate class]));
            
        }
        @catch (NSException *exception) {
                DLog(@"%@", exception);
        }
        @finally {
            
        }
    }
}
