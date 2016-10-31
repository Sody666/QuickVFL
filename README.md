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
