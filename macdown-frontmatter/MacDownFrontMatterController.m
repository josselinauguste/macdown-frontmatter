#import <Cocoa/Cocoa.h>
#import "Markdown.h"
#import "MacDownFrontMatterController.h"


@protocol MacDownMarkdownSource <NSObject>

@property NSString *markdown;

@end


@implementation MacDownFrontMatterController

- (NSString *)name
{
    return @"Front matter: update date";
}

- (BOOL)run:(id)sender
{
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    return [self updateDate:dc.currentDocument];
}

- (BOOL)updateDate:(NSDocument *)document
{
    id<MacDownMarkdownSource> markdownSource = (id)document;
    markdownSource.markdown = [Markdown updateFrontMatterAttribute:markdownSource.markdown:@"date":[MacDownFrontMatterController currentDate]];
    return YES;
}

+ (NSString*)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}

@end
