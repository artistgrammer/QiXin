
#import "ProjectUserDefaults.h"

#define APP_PROP_NAME @"ProjectProp"


@interface ProjectUserDefaults()
@property (nonatomic, retain) NSUserDefaults *defaults;
@end

@implementation ProjectUserDefaults{
    NSDictionary *_appProps;
}

- (id) init
{
	self = [super init];
	if(self) {
		NSString *p = [[NSBundle mainBundle] pathForResource:APP_PROP_NAME ofType:@"plist"];
		_appProps = [[NSDictionary dictionaryWithContentsOfFile:p] retain];
		assert(_appProps);
	}
	return self;
}

- (void) dealloc
{
	[_appProps release];
	[_defaults release];
	[super dealloc];
}

//system defaults
- (id) valueForAppProperty:(NSString *) key
{
	assert(_appProps);
	return [_appProps objectForKey:key];
}

- (NSString *) usernameRemembered
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *) passwordRemembered
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (NSString *)customerNameRemembered {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"customerName"];
}

- (void)rememberUsername:(NSString *) username
			  andPassword:(NSString *) password
            customerName:(NSString *)customerName
{
	NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
	if(username == nil) {
		[_def removeObjectForKey:@"username"];
		[_def removeObjectForKey:@"password"];
        [_def removeObjectForKey:@"customerName"];
	} else {
		[_def setObject:username forKey:@"username"];
		[_def setObject:password forKey:@"password"];
        [_def setObject:customerName forKey:@"customerName"];
	}
	[_def synchronize];
}

@end
