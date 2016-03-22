//
//  MatchDCCell.m
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MatchDCCell.h"

@implementation MatchDCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-240)];
        [self.contentView addSubview:_webView];
    
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadHtml:(NSString *)url{
    if ([url hasPrefix:@"http://"]) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:req];
    }else{
        NSString *show = [NSString stringWithFormat:@"<p>%@</p>",url];
        [_webView loadHTMLString:show baseURL:nil];
    }
}

@end
