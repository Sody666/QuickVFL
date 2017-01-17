## QuickVFL简介
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

其实当你习惯了用VFL去布局，你将会发现xib的直观性并没有那么的好，尤其是你的构图里用了大量的约束——你如果要把其中一个控件从一个位置挪到另外一个位置的时候，将会头疼无比。然而在QuickVFL里，这压根就不是办法。

###安装办法
1. 从Released lib中下载发布出来的framework，并把它放到你项目里
2. 在Target->Build Settings->Other Linker Flags添加上**-ObjC**
3. 在需要用QuickVFL的地方#import < QuickVFL/QuickVFL.h >既可

###更多技巧
如果你需要调试VFL，则可以设置enableVFLDebug=YES;这是一个QuickVFL里定义的全局的布尔值

##API说明
QuickVFL的API并不多，掌握api的使用，能使你在布局的时候得心应手。
```objective-c
QUICK_SUBVIEW(superView, subviewClass)

```
这是一个宏，意思是给superView添加一个类型为subviewClass的控件。宏的返回值是实例化好的控件。

------------

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
UIView的延伸方法。请注意的是，调用者必须是VFL语句描述的所有控件的共同superView。

------------

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
当约束描述的控件发生控件不足、多余时，如何处理他们跟原形之间的关系。一般情况下，如果同一水平线上有多个控件，都要通过这两个接口设置他们的控制优先级。优先级越高，保持自己不受外部影响的能力就越高。
另外，其实这两个接口对应苹果的两个很拗口的compress和hugging的接口。

------------
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
设置调用者和别的控件的宽高比。

------------
```objective-c
/**
 *  Add a constraint to hide self.
 *  Note: The result constraint will be low priority, and 
 *  clipsToBounds property of the view will be set to YES.
 *
 *  @return constraint added.
 */
-(NSLayoutConstraint*)q_addHideConstraintHorizontally;

/**
 *  Add a constraint to hide self.
 *  Note: The result constraint will be low priority, and
 *  clipsToBounds property of the view will be set to YES.
 *
 *  @return constraint added.
 */
-(NSLayoutConstraint*)q_addHideConstraintVertically;
```
针对水平、竖直方向隐藏控件的接口

------------
```objective-c
/**
 *  Prepare the content view for scroll view.
 *
 *  @param orientation the orientation for future use
 *
 *  @return prepared content view
 */
-(UIView*)q_prepareAutolayoutContentViewForOrientation:(QScrollOrientation)orientation;
```
UIScrollView的延伸接口。用于生成contentView。你后面要做的东西就是往此api返回的UIView里添加你的布局。

------------
```objective-c
/**
 *  Refresh the content view.
 *  Make sure the height of the content view is determined before calling this.
 *
 *  Note: Used for vertically scroll.
 *
 *  Should be used when the content view height is determined.
 */
-(void)q_refreshContentViewHeight;

/**
 *  Refresh the content view.
 *  Make sure the height of the content view is determined before calling this.
 *
 *  Note: Used for horizontally scroll.
 *
 *  Should be used when the content view width is determined.
 */
-(void)q_refreshContentViewWidth;
```
contentView的内容发生变化之后，使用此两接口更新高度/宽度。这里的刷新方向对应上一个接口里的初始化朝向。

------------
##通过实例学习QuickVFL
通过例子的方式进行学习是最快的。在此之前，建议你先花十分钟看看（如果之前已经知道，你依然可以温故而知新）[苹果官方VFL文档](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html "VFL")

###三个竖直方向并列的Label
先来点简单的嘛
```objective-c
    UILabel* labelA = QUICK_SUBVIEW(self.view, UILabel);
    UILabel* labelB = QUICK_SUBVIEW(self.view, UILabel);
    UILabel* labelC = QUICK_SUBVIEW(self.view, UILabel);
    
    NSString* layout = @"                                 \
    /* 定义好一个标签的左右边际 */                               \
    H:|-[labelA]-|;                                         \
                                                            \
    /* 竖直方向上定义好三个标签的方位关系。最后的左右是指本语句中的     \
       所有控件都左右对齐。也即是A、B、C左右对齐。                  \
       但因为A的左右边际已经确定，所以三个控件的左右边际就确定下来了*/  \
    V:|-[labelA]-[labelB]-[labelC]-| {left, right};";
    
    [self.view q_addConstraintsByText:layout
                        involvedViews:NSDictionaryOfVariableBindings(labelA, labelB, labelC)];
```
如果忽略layout字符串中的注释，你会发现就两个语句就把布局定下来了。干净利索！运行的结果是三个标签从上到下依次排列，左右对齐。因为界面蛮简单的，我就补贴图了。
但有几个知识点要指出来：
- 每个语句必须要以分号结束
- 多行的时候要用\分隔。这个应该是C语言的基本知识
- 注释遵循C语言的方式
- 整个构建界面步骤就是：
  1.   添加控件（QUICK_SUBVIEW）到其superView上
  2.   构建VFL语句
  3.   把语句添加到最外部的视图上

###约束优先级处理
约束优先级的作用是，在**多条约束对同一个效果**有不同的作用的时候（也就是多条约束起了冲突），优先级最高的约束起决定作用。如果几条约束的优先级是一样的，则系统选择一条保持，其他的降低优先级。
所以我们在布局的时候，尽量降低约束冲突。如果有冲突，也要设置优先级定向选择，不要把最终的选择交给系统，这样可能会使你的程序处于一种不可预测的状态中。
我们来看一段代码：
```objective-c
    UIView* viewWrapperA = QUICK_SUBVIEW(self.view, UIView);
    UIView* viewWrapperB = QUICK_SUBVIEW(self.view, UIView);
    UILabel* labelA1 = QUICK_SUBVIEW(viewWrapperA, UILabel);
    UILabel* labelA2 = QUICK_SUBVIEW(viewWrapperA, UILabel);
    UILabel* labelB1 = QUICK_SUBVIEW(viewWrapperB, UILabel);
    UILabel* labelB2 = QUICK_SUBVIEW(viewWrapperB, UILabel);
    
    NSString* layout = @"\
    /* 先放置好两个标签容器 */\
    H:|[viewWrapperA]|;\
    V:|-[viewWrapperA][viewWrapperB] {left, right};\
    \
        /* A容器的内容 */\
        H:|-[labelA1(200@750)][labelA2(200@740)]-| {top, bottom};\
        V:|[labelA1]|;\
    \
        /* B容器的内容 */\
        H:|-[labelB1(200@740)][labelB2(200@750)]-| {top, bottom};\
        V:|[labelB1]|;\
    ";
    
    [self.view q_addConstraintsByText:layout
                        involvedViews:NSDictionaryOfVariableBindings(viewWrapperA, viewWrapperB, labelA1, labelA2, labelB1, labelB2)];
    
    labelA1.text = @"A1 A1 A1 A1 A1 A1 A1";
    labelA2.text = @"A2 A2 A2 A2 A2 A2 A2";
    labelB1.text = @"B1 B1 B1 B1 B1 B1 B1";
    labelB2.text = @"B2 B2 B2 B2 B2 B2 B2";
```
在每一个标签容器里，两个标签都要求宽度要到200，可是屏幕宽度总共只有320，因为两标签的宽度约束发生了冲突。但是所有两个标签的优先级不一样，所以最终的运行效果是，有限极高的约束得到满足，剩下的空间分配给剩下的控件。
运行的截图如下：
常用的约束使用场景是针对具体情况改变控件的布局。比如，改变大小，改变位置，改变隐藏等。做法是，针对不同的布局，添加各自的约束。然后在想使用某布局的时候，提高相应约束的优先级，降低其他约束的优先级。具体的代码，请参看Demo项目里的Visibility Control页面。
知识点：
- 设置优先级的时候，要有对应的目标。比如*H:[labelB1(200@740)]*它就是对宽度为200的约束设置优先级。如果你写成*H:[labelB1(@740)]*系统则不知道你要对什么约束进行优先级设置。
- 优先级分为如下几个层次：
  - LOW(250),
  - HIGH(750),
  - REQUIRED(1000)
  要注意的是，如果你对一个约束不设置优先级的话，系统会默认给它1000的优先级。如果你要在运行中改变约束的优先级，它原来的优先级不能是1000，你也不能把一个之前的优先级不是1000的改为1000。

实际工作场景中，我们需要在代码里单独对某一个控件添加控制约束。比如：
```objective-c
// 添加隐藏的约束
self.constraintHideA = [viewAWrapper q_addHideConstraintVertically];

/*framework中的源代码：
-(NSLayoutConstraint*)q_addHideConstraintVertically{
    UIView* selfView = self;
    self.clipsToBounds = YES;
    return [self q_addConstraintsByText:@"V:[selfView(0@250)];" involvedViews:NSDictionaryOfVariableBindings(selfView)][0];
}
*/

// 控制
if(self.constraintHideA.priority >= UILayoutPriorityDefaultHigh){
            self.constraintHideA.priority = UILayoutPriorityDefaultLow;
        }else{
            self.constraintHideA.priority = UILayoutPriorityDefaultHigh + 1;
        }
}
```
