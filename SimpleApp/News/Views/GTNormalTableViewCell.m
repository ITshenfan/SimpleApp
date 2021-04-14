//
//  GTNormalTableViewCell.m
//  SimpleApp
//
//  Created by 申凡 on 2021/4/12.
//

#import "GTNormalTableViewCell.h"
#import "GTListItem.h"

@interface GTNormalTableViewCell ()


@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *sourceLabel;
@property(nonatomic,strong,readwrite) UILabel *commentLabel;
@property(nonatomic,strong,readwrite) UILabel *timeLabel;

@property(nonatomic,strong,readwrite) UIImageView *rightimageView;
@property(nonatomic,strong,readwrite) UIButton *deleteButton;
@end

@implementation GTNormalTableViewCell


- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self) {
		[self.contentView addSubview:({
			self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 270, 50)];
			self.titleLabel.font = [UIFont systemFontOfSize:16];
			self.titleLabel.textColor = [UIColor blackColor];
			self.titleLabel.numberOfLines = 2;
			self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
			self.titleLabel;
		})];
		[self.contentView addSubview:({
			self.sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 50, 20)];
			self.sourceLabel.font = [UIFont systemFontOfSize:12];
			self.sourceLabel.textColor = [UIColor grayColor];
			self.sourceLabel;
		})];
		[self.contentView addSubview:({
			self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 50, 20)];
			self.commentLabel.font = [UIFont systemFontOfSize:12];
			self.commentLabel.textColor = [UIColor grayColor];
			self.commentLabel;
		})];
		[self.contentView addSubview:({
			self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 70,50, 20)];
			self.timeLabel.font = [UIFont systemFontOfSize:12];
			self.timeLabel.textColor = [UIColor grayColor];
			self.timeLabel;
		})];

		[self.contentView addSubview:({
			self.rightimageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 15,100, 70)];
			self.rightimageView.image = [UIImage imageNamed:@"icons8-greek-god-zeus-50.png"];
			self.rightimageView;
		})];

//		[self.contentView addSubview:({
//			self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(260, 80,30, 20)];
//			self.deleteButton.backgroundColor= [UIColor blueColor];
//			[self.deleteButton setTitle:@"X" forState:UIControlStateNormal];
//			[self.deleteButton setTitle:@"V" forState:UIControlStateHighlighted];
//
//			//添加操作方法
//			[self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//			//给按钮增加效果
//			self.deleteButton.layer.cornerRadius = 10;
//			self.deleteButton.layer.masksToBounds = YES;
//			self.deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//			self.deleteButton.layer.borderWidth = 2;
//
//			self.deleteButton;
//		})];
	}
	return self;
}

//给Label赋值上相应的文字
- (void)layoutTableViewCellWithItem:(GTListItem *)item {
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:item.uniqueKey];
    if (hasRead) {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
    }
	self.titleLabel.text = item.title;

	self.sourceLabel.text = item.authorName;
	[self.sourceLabel sizeToFit];

	self.commentLabel.text = item.category;
	[self.commentLabel sizeToFit];
	self.commentLabel.frame = CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width + 15,self.commentLabel.frame.origin.y, self.commentLabel.frame.size.width,self.commentLabel.frame.size.height);

	self.timeLabel.text = item.date;
	[self.timeLabel sizeToFit];
	self.timeLabel.frame = CGRectMake(self.commentLabel.frame.origin.x + self.commentLabel.frame.size.width + 15,self.timeLabel.frame.origin.y, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);

    //加载图片一直在主线程上运行，使渲染卡顿。可以从主线程中分离出来，建立到自己建立的线程中
    
    NSThread *downloadImageThread = [[NSThread alloc] initWithBlock:^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
        self.rightimageView.image = image;
    }];
    downloadImageThread.name = @"downloadImageThread";
    [downloadImageThread start];
}

//po [NSThread currentThread]查看当前线程
//po [NSThread currentThread].isMainThread查看是否为主线程

-(void)deleteButtonClick {
	if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDeleteButton:)]) {
		[self.delegate tableViewCell:self clickDeleteButton:self.deleteButton];
	}
}
@end
