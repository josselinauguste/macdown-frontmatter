#import <Cocoa/Cocoa.h>
#import "MacDownFrontMatterController.h"


@protocol MacDownMarkdownSource <NSObject>

@property (readonly) NSString *markdown;

@end


@implementation MacDownFrontMatterController

- (NSString *)name
{
    return @"Front matter";
}

- (BOOL)run:(id)sender
{
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    return [self updateDate:dc.currentDocument];
}

- (BOOL)updateDate:(NSDocument *)document
{
    id<MacDownMarkdownSource> markdownSource = (id)document;
    NSString *markdown = markdownSource.markdown;
    if (!markdown.length)
        return NO;
    NSString *fileName = document.fileURL.path.lastPathComponent;
    if (!fileName.length)
        fileName = @"Untitled";

    return YES;
}

@end
