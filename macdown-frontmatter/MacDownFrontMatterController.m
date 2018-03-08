#import <Cocoa/Cocoa.h>
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
    markdownSource.markdown = [MacDownFrontMatterController updateFrontMatterAttribute:markdownSource.markdown:@"date":[MacDownFrontMatterController currentDate]];
    return YES;
}

+ (NSString*)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)updateFrontMatterAttribute:(NSString *)markdown :(NSString *)attribute :(NSString *)value
{
    NSString *markdownWithFrontMatter = [MacDownFrontMatterController ensureFrontMatterPresence:markdown];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"---\\n.*(%@:\\s*.*?)\\n.*---", attribute] options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:markdownWithFrontMatter options:0 range:NSMakeRange(0, [markdownWithFrontMatter length])];
    if ([match numberOfRanges] > 1)
    {
        return [markdownWithFrontMatter stringByReplacingOccurrencesOfString:[markdownWithFrontMatter substringWithRange:[match rangeAtIndex:1]] withString:[NSString stringWithFormat:@"%@: %@", attribute, value] options:0 range:NSMakeRange(0, [markdownWithFrontMatter length])];
    }
    else
    {
        NSString *replacement = [NSString stringWithFormat:@"%@: %@\n---", attribute, value];
        return [markdownWithFrontMatter stringByReplacingOccurrencesOfString:@"---" withString:replacement options:0 range:NSMakeRange(3, [markdownWithFrontMatter length] - 3)];
    }
}

+ (NSString *)ensureFrontMatterPresence:(NSString *)markdown
{
    if ([MacDownFrontMatterController frontMatterPresent:markdown])
    {
        return markdown;
    }
    else
    {
        return [MacDownFrontMatterController concatenateFrontMatter:markdown :[MacDownFrontMatterController frontMatterSkeleton]];
    }
}

+ (BOOL)frontMatterPresent:(NSString *)markdown
{
    return [markdown hasPrefix:@"---"];
}

+ (NSString *)frontMatterSkeleton
{
    return @"---\n---";
}

+ (NSString *)concatenateFrontMatter:(NSString *)markdown :(NSString *)frontMatter
{
    return [NSString stringWithFormat:@"%@\n\n%@", frontMatter, markdown];
}

@end
