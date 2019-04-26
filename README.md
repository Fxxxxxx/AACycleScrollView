# AACycleScrollView  swift版本的无限轮播图
- 项目地址：[AACycleScrollView](https://github.com/Fxxxxxx/AACycleScrollView)
（ Demo见项目地址）
- 实现效果：**自动轮播，无限轮播**

![Apr-15-2019 16-29-41.gif](https://upload-images.jianshu.io/upload_images/3569202-7ed31238266a5f68.gif?imageMogr2/auto-orient/strip)

- 最新更新：
   1. 支持横向、纵向滑动
```
aaCycle.scrollDirection = .vertical
```
   2. 支持自定义轮播样式(代理方法返回自定义类或者nib)
```
aaCycle.cycleType = .custom
aaCycle.numberOfCustomCells = 6
```


- 集成方式：
1. 项目原地址下载后，把AACycleScrollView文件夹拖入项目
2. Cocoapods   ```pod  'AACycleScrollView' ```

- 使用方式：
```
let aaCycle = AACycleScrollView.init(frame: CGRect.init(x: 0, y: 80, width: kScreenW, height: 200))
aaCycle.imagesUrlStringGroup = []            //网络图片
aaCycle.imagesNameStringGroup = []      //本地图片
aaCycle.autoScrollTimeInterval = 2
aaCycle.pageControlOffset = UIOffset.init(horizontal: kScreenW / 2 - 50, vertical: 0)
view.addSubview(aaCycle)
```
代理方法：
```
//点击选中一张轮播图
@objc optional func cycleScrollView(_: AACycleScrollView, didSelected: Int) -> Void

```

>欢迎集成和使用，联系方式：e2shao1993@163.com
