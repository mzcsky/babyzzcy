//
//  MatchDCCell.h
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchDCCell : UITableViewCell{
    UIWebView       *_webView;
}

- (void)loadHtml:(NSString *)url;

@end
