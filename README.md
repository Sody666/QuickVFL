## Quick简介
QuickVFL是一个基于苹果VFL的构建视图的小框架。它特别适用于在代码里构建视图。

### 特点
凡是苹果VFL的特征，QuickVFL一律支持。除此以外，它还有以下的增强点
- 支持多行描述
- 支持对齐

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
