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

##通过实例学习QuickVFL
通过例子的方式进行学习是最快的。在此之前，建议你先花十分钟看看（如果之前已经知道，你依然可以温故而知新）[苹果官方VFL文档](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html "VFL")
