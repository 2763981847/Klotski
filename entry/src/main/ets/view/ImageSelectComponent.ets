// 导入所需的模块和组件
import display from '@ohos.display'; // 用于获取显示信息
import Constants from '../common/constant/Constants'; // 包含常量定义
import IOUtils from '../common/util/IOUtils'; // IO工具

// 定义滚动类型的枚举
enum scrollTypeEnum {
  STOP = 'onScrollStop', // 停止滚动
  SCROLL = 'onScroll' // 滚动中
};

// 标记为组件
@Component
export default struct ImageSelectComponent {
  // 创建小滚动器对象
  private smallScroller: Scroller = new Scroller();

  // 使用 @State 注解声明组件状态变量
  @State deviceWidth: number = Constants.DEFAULT_WIDTH; // 设备宽度
  @State smallImgWidth: number = (this.deviceWidth - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT; // 小图像宽度
  // 使用 @Link 注解将组件状态父组件进行双向绑定
  @Link selectedIndex: number; // 选中的图像索引
  @Link images: PixelMap[]; // 图像数组

  // 生命周期钩子函数，当页面即将显示时调用
  aboutToAppear() {
    // 获取默认显示对象
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let width = displayClass?.width / displayClass.densityPixels ?? Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
  }

  // 生命周期钩子函数，当页面显示时调用
  onPageShow() {
    // 缩略图滑动到当前选择图片
    this.smallScroller.scrollToIndex(this.selectedIndex);
  }

  // 处理缩略图的点击事件
  smallImgClickAction(index: number): void {
    this.selectedIndex = index;
    this.smallScroller.scrollToIndex(this.selectedIndex);
  }

  // 处理缩略图滚动器的滚动事件
  smallScrollAction(type: scrollTypeEnum): void {
    this.selectedIndex = Math.round(((this.smallScroller.currentOffset().xOffset as number) +
    this.smallImgWidth / 2) / (this.smallImgWidth + Constants.LIST_ITEM_SPACE));
    if (type === scrollTypeEnum.STOP) {
      this.smallScroller.scrollTo({ xOffset: this.selectedIndex * this.smallImgWidth, yOffset: 0 });
    }
  }

  // 从相册中选择图片并添加至图像数组
  async selectFromAlbum() {
    let pixelMap = await IOUtils.getPixelMapFromAlbum();
    this.images = [pixelMap, ...this.images];
    this.selectedIndex = 0;
    this.smallScroller.scrollToIndex(0);
  }

  // 构建组件的 UI 布局
  build() {
    Column({ space: 20 }) { // 创建垂直列布局，指定垂直间距
      Text('请选择图片') // 提示文本
        .fontSize(20)
        .fontColor('#182431')

      Image(this.images[this.selectedIndex]) // 显示当前选中的图像
        .objectFit(ImageFit.Contain) // 设置图像适应方式
        .height('70%')
        .width('80%')

      List({
        scroller: this.smallScroller, // 使用缩略图滚动器
        space: Constants.LIST_ITEM_SPACE, // 列表项之间的间距
        initialIndex: this.selectedIndex // 初始选中的索引
      }) {
        ForEach(this.images, (img: PixelMap, index?: number) => {
          ListItem() {
            Image(img) // 显示图像
              .onClick(() => this.smallImgClickAction(index)) // 点击图像时触发 smallImgClickAction 方法
          }
          .width(this.smallImgWidth) // 设置列表项的宽度
          .aspectRatio(1) // 设置图像的纵横比为 1（正方形）
        }, (item: PixelMap, index) => index.toString() + Date.now().toString())
      }
      .listDirection(Axis.Horizontal) // 设置列表的方向为水平
      .onScroll((scrollOffset, scrollState) => { // 处理列表滚动事件
        if (scrollState === ScrollState.Fling) {
          this.smallScrollAction(scrollTypeEnum.SCROLL);
        }
      })
      .onScrollStop(() => this.smallScrollAction(scrollTypeEnum.STOP))
      .height(this.smallImgWidth) // 设置列表的高度
      .width('100%')

      Row() { // 创建水平行布局
        Text('从相册选择图片') // 提示文本
          .fontSize(16)
          .fontColor('#182431')

        Text() // 空白文本，仅用于SpaceAround布局占位

        Button({ type: ButtonType.Normal }) { // 创建选择图片按钮
          Image($r('app.media.album')).objectFit(ImageFit.Contain) // 显示相册图标
        }
        .width('20%')
        .height('70%')
        .fontColor('#182431')
        .fontSize(16)
        .borderRadius(5)
        .onClick(() => this.selectFromAlbum()) // 点击按钮时触发 selectFromAlbum 方法
        .backgroundColor('#FEFEFE')
        .borderColor('#D2D3D4')
        .borderWidth({
          left: 0.2,
          right: 0.2,
          top: 0.4,
          bottom: 0.4
        })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
      .borderWidth({ bottom: 1, top: 1 })
      .borderColor('#DEE8E9')
      .width('100%')
      .height('8%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}