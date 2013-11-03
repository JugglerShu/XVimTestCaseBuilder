//
//  AppDelegate.m
//  XVimTestCaseBuilder
//
//  Created by Patrick on 11/2/13.
//  Copyright (c) 2013 weaksauce. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong) IBOutlet NSTextView *txtResults;
@property (strong) IBOutlet NSTextView *txtBefore;
@property (strong) IBOutlet NSTextView *txtAfter;
@property (strong) IBOutlet NSTextField *txtTestName;
@property (strong) IBOutlet NSTextField *txtCommandString;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[self txtBefore] setString:@""];
    [[self txtAfter] setString:@""];
    [[self txtResults] setString:@""];
    
    [[self txtCommandString] setStringValue:@""];
    [[self txtTestName] setStringValue:@""];
}
-(IBAction)showHelp:(id)sender{
    
   NSAlert* alrt = [NSAlert alertWithMessageText:@"Instructions" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Enter in the before and after text.\nPlace the cursor and/or select the range of the text in each text view where you'd expect the associated before and after vim commands to operate.\nDelete or add text into the After text view to reflect what vim commands would change."];
    
    [alrt runModal];
}
- (IBAction)generateTest:(NSButton *)sender {
    NSString* inputCommand = [[self txtCommandString] stringValue];
    
    NSString* before =  [[[self txtBefore] string] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    NSString* after =  [[[self txtAfter] string] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    
    NSRange beforeRange = [[self txtBefore] selectedRange];
    NSRange afterRange = [[self txtAfter] selectedRange];
    
    NSString* testName = [[self txtTestName] stringValue];
    
    NSString* beforeTestString = [testName stringByAppendingString:@"_before"];
    NSString* afterTestString = [testName stringByAppendingString:@"_after"];
    
    NSString* beforeResult = [NSString stringWithFormat:@"static NSString* %@ = @\"%@\";", beforeTestString, before ];
    NSString* afterResult = [NSString stringWithFormat:@"static NSString* %@ = @\"%@\";", afterTestString, after];
    
//   XVimMakeTestCase(initText, initRangeLoc, initRangeLen, inputText , expcText, expcRangeLoc, expcRangeLen)
    NSString* testCaseResult = [NSString stringWithFormat:@"XVimMakeTestCase(%@, %lu, %lu, @\"%@\" , %@, %lu, %lu),",
                    beforeTestString,
          beforeRange.location,
          beforeRange.length,
          inputCommand,
          afterTestString,
          afterRange.location,
          afterRange.length];
    NSString* results = [NSString stringWithFormat:@"%@\n%@\n%@", beforeResult, afterResult, testCaseResult];
    
    [[self txtResults] setString:results];
}

- (IBAction)copyTextToAfter:(id)sender {
    [[self txtAfter] setString:[[self txtBefore ] string]];
}


-(void) windowWillClose:(id)sender{
    [NSApp terminate:nil];
}

@end
