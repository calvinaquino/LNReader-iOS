//
//  Constants.h
//  LNReader
//
//  Created by Commix Company on 7/17/13.
//  Copyright (c) 2013 CommixWeb. All rights reserved.
//

#ifndef LNReader_Constants_h
#define LNReader_Constants_h

//URLs
#define kBTBaseUrl @"http://www.baka-tsuki.org"
//#define kBTMainUrl @"http://www.baka-tsuki.org/project/index.php?title=Main_Page"
#define kBTMainUrlEnglish @"http://www.baka-tsuki.org/project/index.php?action=render&title=Category:Light_novel_(English)"

//get Queues
#define GCDBackgroundThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDMainThread dispatch_get_main_queue()

#define startUIThread dispatch_async(GCDMainThread, ^{
#define startBGThread dispatch_async(GCDBackgroundThread, ^{
#define endThread });

//storyboards
#define kStoryboardIPhone @"MainStoryboard_iPhone"
#define kStoryboardIPad @"MainStoryboard_iPad"

//view controller strings
#define kViewControllerMain @"Main"
#define kViewControllerMenu @"Menu"

//view controller integers
enum viewControllers {
    kViewMain,
    kViewMenu
};

//other
#define kKeyboardSize 216

//Errors

#define kNoChapterNameError @"NO_CHAPTER_NAME_FOUND"
/* URLs */
FOUNDATION_EXPORT NSString* const kBakaTsukiBaseUrl;
FOUNDATION_EXPORT NSString* const kBakaTsukiMainPageUrl;

/* GCD */
#define GCDGlobalQueueDEFAULT dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDMainQueue dispatch_get_main_queue()

#endif
