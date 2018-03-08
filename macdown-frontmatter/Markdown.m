#import <Cocoa/Cocoa.h>
#import "Markdown.h"


@interface Markdown()

+ (NSString *)ensureFrontMatterPresence:(NSString *)markdown;
+ (BOOL)frontMatterPresent:(NSString *)markdown;
+ (NSString *)frontMatterSkeleton;
+ (NSString *)concatenateFrontMatter:(NSString *)markdown :(NSString *)frontMatter;

@end


@implementation Markdown

+ (NSString *)updateFrontMatterAttribute:(NSString *)markdown :(NSString *)attribute :(NSString *)value
{
    NSString *markdownWithFrontMatter = [Markdown ensureFrontMatterPresence:markdown];
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
    if ([Markdown frontMatterPresent:markdown])
    {
        return markdown;
    }
    else
    {
        return [Markdown concatenateFrontMatter:markdown :[Markdown frontMatterSkeleton]];
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
