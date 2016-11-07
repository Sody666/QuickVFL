## Quick简介
QuickVFL是一个基于苹果VFL的构建视图的小框架。它特别适用于在代码里构建视图。

### 特点
凡是苹果VFL的特征，QuickVFL一律支持。除此以外，它还有以下的增强点
- 支持多行描述
- 支持对齐
- 支持设置比例约束

### 谁会需要QuickVFL
总而言之，是不能用xib或者不喜欢用xib的人。会有以下情形：
- app太大，xib是其中的因素
- 多人合作的时候，经常造成xib冲突
- 一个人多个版本同时进行，经常造成xib冲突
- 控制欲太强的人
- 想要跟别人方便交流布局经验的人

第一条就不用解释了
第二第三条，如果你经历过，肯定也不用说了。xib冲突起来，貌似出了重新写，没啥好办法。
第四条，在你比较过xib中约束的可读性、可修改性后，估计抓狂的你会很有心得。
第五条。你如果用文字去快速、直观地表述你的布局，然后在stackoverflow上讨教？除了截屏，没办法。
我会在文章的后面不断地添加使用技巧，使读者慢慢爱上QuickVFL。

### QuickVFL的短处
- 上手时间比较长，尤其当你之前没用过VFL的时候
- 使用的效果严重依赖于经验
- 跟VFL一样，出错了，不容易定位

但用QuickVFL跟玩魔法一样，当你看到一个一个个灵活的、鲁棒性很强的界面被你构建出来的时候，成就感很强。
OK，如果你觉得以上的好和坏你都可以接受，我们就动身吧。

## 技术要点
### 控件定位
我们回想传统的frame，它包括origin和size。同样，一个控件要能准确的被布局出来，它必须要有正确的坐标和大小。这里的正确的含义是，不含糊的，不冲突的。不过，当你使用约束的时候，你要转变一下观念。你不要老想着它在哪里，有多大多大，而是想着，它**相对谁，边界关系如何**，这里，被相对的这个谁，你要假定它是已经确定的。
其实，定位控件基本上就是VFL的全部工作。你可以写得很艺术，也可以写得很笨拙。有如以下的代码：
```objective-c
UIView* viewWrapper = QUICK_SUBVIEW(self.view, UIView);
UIButton* buttonLeft = QUICK_SUBVIEW(viewWrapper, UIButton);
UIButton* buttonRight = QUICK_SUBVIEW(viewWrapper, UIButton);
UIView* viewDivider = QUICK_SUBVIEW(viewWrapper, UIView);

NSString* goodWay = @"\
	H:|[buttonLeft][buttonRight][viewDivider(0.5)]| {top, bottom};\
	V:|[buttonLeft]|;";

NSString* verbalWay = @"\
	H:|[buttonLeft][buttonRight][viewDivider(0.5)]|;\
	V:|[buttonLeft]|;\
	V:|[buttonRight]|;\
	V:|[viewDivider]|;";
```
如果你才刚刚开始用VFL，可以用笨拙的平铺直叙的方式去写。等你慢慢有经验了，就可以写得有技巧一点。
在写的时候，第一思想一定不要是某某控件是多大多大，而是要把设备想象成不定宽高，控件是相对什么什么应该怎样怎样。
### 对齐
QuickVFL支持在语句里设置对齐。格式是：
```objective-c
VorH:|-[widget]-| {left, right, top, bottom, centerX, centerY};
```
也就是，在语句结束符号，分号之前，用大括号包扩对齐方式。
但一定要注意，
在V方向的时候，你只能限定*left、right、centerX*
在H方向的时候，你只能限定*top、bottom、centerY*
其实这个限制很好理解，因为你在相应方向上你做这些限定才有意义。
> 逆向思维：如果你在H方向上，限定多个控件左对齐，你觉得有意义吗？

请重点注意，如果你在设置centerX、centerY的时候，最好只包扩相关的控件，无关的控件要分开第二个语句描述，否则会出现没法对齐的情况。
```objective-c
#labelName
#    |
#labelEmail
#    |
#imageNotice
#
#These 3 widgets vertical relationship. But labels will　be center X.

#Bad way:
V:[labelName]-[labelEmail]-[imageNotice] {centerX};

#Good way:
V:[labelName]-[labelEmail] {centerX};
V:[labelEmail]-[imageNotice];
```
### 空间抢占
当你在同一个水平线上放置两个以上的控件时，如果它们的宽度会运行时改变，你就必须指定它们变化时的抢占优先级。iOS里有两个维度说明这件事：空间不足时和空间有多时的优先级。其实苹果描述两个维度的api非常拗口，非常难记住。所以我们会稍后一点地章节提供了一个直观一点的api。其实这个空间抢占问题，也是控件的相对性的确定性的问题。几个控件，你中有我，我中有你，所有钱都放一个口袋。当空间有多余，或者空间不足，要挤压或拉伸时，就会出乱子。你的成效就处于一个不可控的状态中。
## 常用API说明
### 快速添加控件
```objective-c
QUICK_SUBVIEW(superView, targetWidgetName);
```
初始化控件，并把它添加到父试图内。第一个参数是目标控件的super view，第二个参数是控件的类名字。这个宏会返回准备好的控件。

例子：
```objective-c
UIScrollView* scrollViewVertical = QUICK_SUBVIEW(self.view, UIScrollView);
UILabel* labelName = QUICK_SUBVIEW(self.view, UILabel);
```
### 给控件添加约束
```objective-c
/**
 *  add autolayout constraint to me.
 *
 *  @param text  VFL text
 *  @param views views involed
 *
 *  @return added constraints
 */
-(NSArray*) q_addConstraintsByText:(NSString*)text
                  involvedViews:(NSDictionary*)views;
```
就是写好了整坨VFL后，直接把它加到最大的superview上。一般情况下，调用者就是VFL中描述的所有的控件的共同的父视图。最大的父视图的父视图也没关系。此视图包含了所有的视图就可以了。involvedViews我们一般跟*NSDictionaryOfVariableBindings *配合使用。如果你不知道这是啥东东，最好马上到狗爹上搜一下。
> 有了以上两个api后，其实你就可以架锅烧饭了。每次无非就是添加视图，然后用文本描述它，然后把约束添加到父视图上。

### 设置控件调整空间的优先级
```objective-c
/**
 *  Stay shaped when there is less space than needed.
 *
 *  @param priority     priority to stay original shape
 *  @param isHorizontal is for horizontal orientation
 */
-(void)q_stayShapedWhenCompressedWithPriority:(UILayoutPriority)priority
                                  isHorizontal:(BOOL)isHorizontal;

/**
 *  Stay shaped when there are more space than needed.
 *
 *  @param priority     priority to stay original shape
 *  @param isHorizontal is for horizontal orientation
 */
-(void)q_stayShapedWhenStretchedWithPriority:(UILayoutPriority)priority
                                 isHorizontal:(BOOL)isHorizontal;
```
当同一维度放置了多个控件时，有可能会发生如下问题：当此维度上的空间多余/不足时，该拉伸/挤压谁？苹果有直接的api解决这问题的。但其非常拗口难记。所以我们写了一个包装一下。用途就是，当空间发生变化时，控件保持现状的优先级。优先级越高，保持现状的能力越高。优先级越低，空间发生变化时，第一时间要修改此控件。因为所有控件默认的优先级都是“高优先级”，所以你作为修改，降低目标控件的优先级就可以了。
如下的例子代码就是一个聊天记录里的右侧情形：
```objective-c
UIView* viewWrapper = QUICK_SUBVIEW(self.view, UIView);
UILabel* labelChatContent = QUICK_SUBVIEW(viewWrapper, UILabel);
UIImageView* imageViewAvatar = QUICK_SUBVIEW(viewWrapper, UIImageView);

NSString* layoutTree = @"H:|-(>=15)-[labelChatContent]-[imageViewAvatar]-15-| {top};\
						 V:|-5-[imageViewAvatar]-(>=5)-|;\
						 V:[labelChatContent]-(>=5)-|";

[viewWrapper q_addConstraintsByText:layoutTree
                        involvedViews:NSDictionaryOfVariableBindings(labelChatContent, imageViewAvatar)];

[labelChatContent q_stayShapedWhenStretchedWithPriority:UILayoutPriorityDefaultLow isHorizontal:YES];
[labelChatContent q_stayShapedWhenCompressedWithPriority:UILayoutPriorityDefaultLow isHorizontal:YES];
```

如果没有最底下的那两行，头像可能会被挤到屏幕外面。
当然，不要忘了把label的行数设置为0.

### 设置控件不同维度的比例关系
```objective-c
/**
 *  Set send's width equal to another view's attribute
 *
 *  @param aView      target view
 *  @param attribute  equal attribution
 *  @param multiplier multiplier value
 */
-(void)q_equalWidthToView:(UIView*)aView
       forLayoutAttribute:(NSLayoutAttribute)attribute
               multiplier:(CGFloat)multiplier;

/**
 *  Set send's height equal to another view's attribute
 *
 *  @param aView      target view
 *  @param attribute  equal attribution
 *  @param multiplier multiplier value
 */
-(void)q_equalHeightToView:(UIView*)aView
        forLayoutAttribute:(NSLayoutAttribute)attribute
                multiplier:(CGFloat)multiplier;
```
**attribute只应该使用长或宽**，因为api已经明说了是设置控件的宽高的。这个api和VFL结合着使用，实现不同维度的比例约束。比如：
- 自身宽高比例
- 自身宽高和非sibling的控件的比例关系

### 使用ScrollView
基本所有的VC都必须要使用scrollView或者UITableView，以防止屏幕不够高的问题。如果你还没有意识到这是一个大问题的话，我只能悄悄拍拍你肩膀并提示，兄弟，别说话了，趁老板没发现这问题，赶紧去修改代码，支持这个功能。
我们的小框架非常方便地支持此功能的。
```objective-c
// #import "UIScrollView+constraint.h"

/**
 *  prepare the scroll view content as same size to scroll view
 *
 *  @return the content view prepared.
 */
-(UIView*)q_prepareAutolayoutContentView;

/**
 *  Refresh the content view with updated height.
 *  Note: Used for vertically scroll.
 *  Should be used when widgets is dynamically added to
 *  content view and the height is undetermined(i.e. the
 *  widget at the bottom is not stick to bottom of content view)
 *
 *  @param height current updated height
 */
-(void)q_refreshContentViewWithHeight:(CGFloat)height;

/**
 *  Refresh the content view.
 *  Note: Used for vertically scroll.
 *  Should be used when the content view height is determined.
 */
-(void)q_refreshContentViewHeight;

/**
 *  Refresh the content view with updated width
 *  Note: Used for horizontally scroll.
 *  Should be used when widgets is dynamically added to content 
 *  view and the width is undetermined.
 *
 *  @param width current updated width
 */
-(void)q_refreshContentViewWithWidth:(CGFloat)width;

/**
 *  Refresh the content view.
 *  Note: Used for horizontally scroll.
 *  Should be used when the content view width is determined.
 */
-(void)q_refreshContentViewWidth;
```
第一个API就是让你的scrollView准备好一切，然后它会返回一个UIView给你使用。这个返回的View就是contentView，你可以随意往里面写东西。
一般情况下，我们的UIScrollView是覆盖整个VC的。
你往contentView里构建完了layout，最后要做的工作就是刷新scrollView。是垂直还是水平，根据需要调用刷新api即可。但在这里又一个细节你是需要清楚的：
如果你的contentView最底下的视图的bottom跟contentView的bottom是“粘合”起来了的，你只要调用不用提供高度的那个api就可以。如果没有粘合（此种情形最有可能是你后续需要动态地增加更多控件），你需要把contentView的高度告诉api，然后框架会提你做刷新。
刷新的结果是，如果你的contentView没有scrollView高/宽，则滚动会被禁用，否则contentView会自动拉到适当的大小，然后帮你把滚动启动过来。
你可以看Demo中的ScrollView部分。里面的简单例子够你学习的。
> 近来在想，貌似ContentView中如果有输入控件，弹键盘的时候是否应该做一些东东？是个问题，看什么时候加上这个功能。

## Learn by Example
你可以直接下载源代码，然后直接在xcode中编译运行。在模拟器中将会看到更加直接的运行效果。
QuickVFL的主要文件是
> UIView+constraint.h

当你需要ScrollView的时候，你要需要用到
> UIScrollView+constraint.h

Tips:
> 你可以在项目的prefix文件中把需要的头文件import进来，这样你就可以不用在每个用到这些文件的地方都做import了。

### import相关的头文件
```objective-c
#import "UIView+constraint.h"
#import "UIScrollView+constraint.h"
```
### property的命名约定
VFL对命名其实是没有限制的，只要你遵循oc的变量命名规则就可以。但我们做多一些约定，这样我们的VFL代码的可读与维护性都讲大幅提高。
我们这样约定property的约定：
> 控件名＋用途

> 数据结构名＋用途

比如：
```objective-c
@property (nonatomic, weak) UITableView* tableViewContents;
@property (nonatomic, strong) NSArray* arrayNames;
```
那么，其对应的ivar就是
```objective-c
UITableView* _tableViewContents;
NSArray* _arrayNames;
```
如果我们能严格遵循这个约定，则我们的VFL代码一眼就能看出变量身份和用途。重申一下，**VFL的可读性非常非常重要**。如果我们养成了这个编程习惯，还有有一个意外惊喜给你哦：当你有类里有多个同样类型的property的时候，你只要写self.类型,然后xcode就回即刻给你提示出所有的类型来。这个对于“煲老火汤”是非常有用的 －－已经是农农老司机的你肯定知道，写完的代码转身就忘。编写的代码，隔日可能就忘了某某变量叫啥，甚至会忘了有没有设定过这个变量。

#### 批评的声音
> 有些同学喜欢缩写，因而labelName喜欢写成lblNam。这是得不偿失的。这也是跟苹果的代码规范相违背的。有兴趣的同学，可以参读一下苹果的代码规范。益处大大的有哦。

#### 更多property的例子
```objective-c
@property (nonatomic, weak) UIView* viewWrapper;
@property (nonatomic, weak) UITextView* textViewNote;
@property (nonatomic, weak) UILabel* labelEmail;
@property (nonatomic, weak) UITextField* textFieldPassword;
@property (nonatomic, strong) NSMutableDictionary* dictionaryParams;
@property (nonatomic, strong) NSDate* dateRecordDate;
```

### 左右对齐
```objective-c
    UILabel* labelShortLeft = QUICK_SUBVIEW(self.view, UILabel);
    UILabel* labelLongLeft = QUICK_SUBVIEW(self.view, UILabel);
    
    UILabel* labelShortRight = QUICK_SUBVIEW(self.view, UILabel);
    UILabel* labelLongRight = QUICK_SUBVIEW(self.view, UILabel);
    
    UILabel* labelShortCenter = QUICK_SUBVIEW(self.view, UILabel);
    UILabel* labelLongCenter = QUICK_SUBVIEW(self.view, UILabel);
    
    NSString* layoutTree = @"\
    V:|-10-[labelShortLeft]-10-[labelLongLeft] {left};\
    H:|-8-[labelShortLeft]-(>=8)-|;\
    H:[labelLongLeft]-(>=8)-|;\
    \
    \
    V:[labelLongLeft]-10-[labelShortRight]-10-[labelLongRight] {right};\
    H:|-(>=8)-[labelShortRight]-8-|;\
    H:|-(>=8)-[labelLongRight];\
    \
    \
    V:[labelLongRight]-10-[labelShortCenter];\
    V:[labelShortCenter]-10-[labelLongCenter] {centerX};\
    H:|-(>=8)-[labelShortCenter]-(>=8)-|;\
    H:|-(>=8)-[labelLongCenter]-(>=8)-|;\
    ";
    
    [self.view q_addConstraintsByText:layoutTree
                                   involvedViews:NSDictionaryOfVariableBindings(labelLongLeft,
									labelShortLeft, labelShortCenter, labelLongCenter, 
									labelLongRight, labelShortRight)];
    [self.view setNeedsLayout];
```
在第一坨VFL语句中，有一个*{left}*，这表示这个语句中的所有控件（superview除外）左对齐。一定要注意的是，**只能在V方向上的语句才能用左右、水平居中对齐**。正是因为做对齐说明了labelShortLeft和labelLongLeft左边的空间关系，所以在labelShortLeft设定了左边跟superView的关系后，labelLongLeft就不用再设置其左边跟superView的关系了。这两个控件在水平描述语句上的(>=8)表示，右边的trail大于等于8.当label文本比较短的时候，label的宽度会缩小。当文本长的时候，宽度会扩大，但最大的时候也只能跟右边有8的距离。
> 注意：
> 请确保一个语句的所有内容在分号的左边。\用来控制NSString的内容的。

> 强调：
> 请不要把VFL语句使用外部的text表示，然后把此内容独立到额外的文件。这样做会打破“相关内容要聚到一起”的规则，会降低代码的可读性和可维护性——VFL里的控件名称跟VC里的ivar名称必须要一致。

第二坨VFL描述了右对齐的两个标签的关系，情形跟第一坨的差不多，所以就不多说了。

第三坨VFL描述了水平居中对齐。这里要重点说明的是，虽然labelShortCenter、labelLongCenter描述了它们的水平居中关系，但你还要单独在H描述上说明它们跟superview的关系，否则当标签的文本很长的时候，文本的内容会失控。

最后两行的代码是设定所有控件的布局并刷新界面。
最后，运行的效果如下：
[![对齐运行效果](https://github.com/Sody666/QuickVFL/blob/master/readMeResources/align1.png "对齐运行效果")](https://github.com/Sody666/QuickVFL/blob/master/readMeResources/align1.png "对齐运行效果")
