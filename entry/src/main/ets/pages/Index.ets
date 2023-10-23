// 导入所需的模块和组件
import ImageSelectComponent from '../view/ImageSelectComponent'; // 图像选择组件
import { imageResources } from '../view/model/ImageResources'; // 图像资源数组
import router from '@ohos.router'; // 路由模块
import GameConstants from '../common/constant/GameConstants'; // 游戏常量
import IOUtils from '../common/util/IOUtils'; // IO工具
import DifficultySelectComponent from '../view/DifficultySelectComponent'; // 难度选择组件
import TitleComponent from '../view/TitleComponent'; // 标题组件

@Entry // 标记为入口组件
@Component // 标记为组件
struct Index {
  // 使用 @State 注解来声明组件所需的状态变量
  @State rows: number = GameConstants.DEFAULT_ROWS // 默认行数
  @State cols: number = GameConstants.DEFAULT_COLS // 默认列数
  @State withIndex: boolean = GameConstants.WITH_INDEX // 是否显示编号
  // 使用@StorageLink实现AppStorage和变量的双向绑定
  @StorageLink('selectedIndex') selectedIndex: number = 0 // 选中的图像索引
  @StorageLink('images') images: PixelMap[] = [] // 图像数组

  // 生命周期钩子函数，当页面即将显示时调用
  aboutToAppear() {
    // 从资源中获取 PixelMap 图像数组并设置到组件状态中
    IOUtils.getPixelMapsFromResource(imageResources)
      .then(images => this.images = images);
  }

  // 启动游戏，导航到游戏页面并传递所选参数
  startGame() {
    router.pushUrl({ url: 'pages/GamePage',
      params: {
        rows: this.rows, // 行数
        cols: this.cols, // 列数
        withIndex: this.withIndex // 是否显示编号
      }
    });
  }

  // 构建组件的 UI 布局
  build() {
    Column({ space: 20 }) { // 创建垂直列布局，指定垂直间距
      TitleComponent() // 标题组件
      DifficultySelectComponent({ rows: $rows, cols: $cols, withIndex: $withIndex }) // 难度选择组件
        .height('10%')
        .width('100%')
      ImageSelectComponent({ selectedIndex: $selectedIndex, images: $images }) // 图像选择组件
        .height('70%')
        .width('100%')
      Button('开始挑战') // 开始挑战按钮
        .height('8%')
        .width('50%')
        .onClick(() => this.startGame()) // 点击按钮时触发 startGame 方法
    }.height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
  }
}
