//
//  AppDelegate.h
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 10/25/14.
//  Copyright (c) 2014 Erakk. All rights reserved.
//

#ifndef LNReader_Constants_h
#define LNReader_Constants_h

//UI
static CGFloat const kKeyboardSize = 216;

static CGFloat const kMargin = 20.0;
static CGFloat const kMarginSmall = 10.0;

static CGFloat const kFontSizeBig = 22.0;
static CGFloat const kFontSizeMedium = 18.0;
static CGFloat const kFontSizeSmall = 12.0;

//Errors
static NSString *const kNoChapterNameError = @"NO_CHAPTER_NAME_FOUND";

//URLs
static NSString *const kBTBaseUrl = @"https://www.baka-tsuki.org";
static NSString *const kBakaTsukiBaseUrl = @"https://www.baka-tsuki.org";
static NSString *const kBakaTsukiMainPageUrl = @"https://www.baka-tsuki.org/project/index.php?title=Main_Page";
static NSString *const kBakaTsukiMainUrlEnglish = @"https://www.baka-tsuki.org/project/index.php?action=render&title=Category:Light_novel_(English)";

static NSString *const kXPATHMainNovelList = @"//*[@id='mw-pages']/div/table/tr/td/ul/li";
static NSString *const kXPATHNovelContent = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
static NSString *const kXPATHNovelCover = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']/div/div/a[@class='image']";
static NSString *const kXPATHNovelSynopsis = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";
static NSString *const kXPATHNovelVolumes = @"//html/body/div[@class='mw-body']/div[@id='bodyContent']/div[@id='mw-content-text']";

enum ChapterResumeSource {
    ChapterResumeNone,
    ChapterResumeLastRead,
    ChapterResumeNovel,
};

typedef enum ChapterResumeSource ChapterResumeSource;

#endif