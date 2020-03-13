链接：https://www.jianshu.com/p/f81fcbb3e146

iOS11中UIDocumentInteractionController/UIActivityViewController分享文件到三方app毫无反应》问题的解决方案：

解决问题的关键点就是：copy文件到沙盒。
对，就是这么简单，但也就是这么出人意料。实际应用中，大多数分享的文件可能都是保存在沙盒里的；但是，一般做Demo的时候，大多可能就是拖个文件到boundle中，这也就造成了后续分享文件功能毫无反应的结果。
来说说具体怎么改进吧。

首先，如果你要分享的文件是在boundle中，那么就一定要先把他copy到沙盒中，然后把沙盒路径传给UIDocumentInteractionController/UIActivityViewController；

作者：XTShow
链接：https://www.jianshu.com/p/f81fcbb3e146
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。