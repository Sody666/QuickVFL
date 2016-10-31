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
