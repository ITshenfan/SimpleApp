//
//  GTVideoCoverView.m
//  SimpleApp
//
//  Created by 申凡 on 2021/4/15.
//

#import "GTVideoCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import "GTVideoPlayer.h"
#import "GTVideoToolbar.h"

@interface GTVideoCoverView()
@property (nonatomic, strong, readwrite) UIImageView *coverView;
@property (nonatomic, strong, readwrite) UIImageView *playButton;
@property (nonatomic, copy, readwrite) NSString *videoUrl;
@property (nonatomic,strong,readwrite) GTVideoToolbar *toolbar;
@end

@implementation GTVideoCoverView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height - GTViderToolbarHeight)];
            _coverView;
        })];
        [_coverView addSubview:({
            _playButton = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 50)/2,(frame.size.height - GTViderToolbarHeight - 50)/2 ,50,50)];
            _playButton.image = [UIImage imageNamed:@"icon.bundle/videoPlay@3x.png"];
            _playButton;
        })];
        
        [self addSubview:({
            _toolbar = [[GTVideoToolbar alloc] initWithFrame:CGRectMake(0, _coverView.bounds.size.height, frame.size.width, GTViderToolbarHeight)];
            _toolbar;
        })];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

-(void) dealloc{

}

#pragma mark -public method
- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl {
    _coverView.image = [UIImage imageNamed:videoCoverUrl];
    _videoUrl = videoUrl;
    [_toolbar layoutWithModel:nil];
}


#pragma mark - private public
//视频播放的业务逻辑，首先是有一个占位图，占位图上有一个视频播放的按钮，当点击播放的时候，视频的界面粘贴到全部的界面上来

- (void)_tapToPlay {
    //在当前Item上播放视频
    [[GTVideoPlayer Player] playVideoWithUrl:_videoUrl attachView:_coverView];
}
@end
