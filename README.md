## Quick简介
QuickVFL是一个基于苹果VFL的构建视图的小框架。它特别适用于在代码里构建视图。

### 特点
凡是苹果VFL的特征，QuickVFL一律支持。除此以外，它还有以下的增强点
- 支持多行描述
- 支持对齐
- 支持设置比例约束

## 技术要点及常用API说明
### 控件定位
我们会想传统的frame，它包括origin和size。同样，一个控件要能准确的被布局出来，它必须要有正确的坐标和大小。这里的正确的含义是，不含糊的，不冲突的。
举例而言，一个控件如果只描述了x值，没有y值，则是含糊的。或者没有描述大小，则其也是含糊的。含糊的时候，系统会用默认的方式布局。比如，如果你没有描述y的值，则系统可能会把它设置为0.
一个控件，对于一个属性（x、y、大小等），如果有多个描述，并且这些描述的优先级是一样的，则系统会认为描述冲突了，它就会自己武断地删除掉一些，直到冲突消失为止。这个时候，xcode的log就会打印大段大段的警告信息。
当你没有准确地描述一个控件的frame信息的时候，你就把你的程序置于一个不可控的状态。这是不可取的。
> 所以我们在写写VFL的时候，要不上眼睛，好好想想一个控件它是否已经被准确地描述了。你可以直接描述它，也可以使用对齐等方式间接描述。总而言之，它务必处于一个确定的状态中。

#### 一些不能准确描述控件的VFL的例子
```objective-c
# labelName, labelEmail are wrap by viewWrapper
# labelName = QUICK_SUBVIEW(viewWrapper, UILabel);
# labelEmail = QUICK_SUBVIEW(viewWrapper, UILabel);

////////////////////
V:|-[labelName]-[labelEmail]-|;
H:|-[labelName]; # tail undetermined
H:[labelEmail]-|;# lead undetermined

////////////////////
V:|-[labelName]-[labelEmail]-| {left, right};
H:|-[labelName]-|;
H:|-[labelEmail]-|; # conflict. should be removed.
```

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
#These 3 widgets vertical relationship. But labels are center X.

#Bad way:
V:[labelName]-[labelEmail]-[imageNotice] {centerX};

#Good way:
V:[labelName]-[labelEmail] {centerX};
V:[labelEmail]-[imageNotice];
```
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
