import CroppedImage from '../common/entity/CroppedImage'
import GridUtils from '../common/util/GridUtils'
import ImageUtils from '../common/util/ImageUtils'
import router from '@ohos.router'
import GameConstants from '../common/constant/GameConstants'
import SuccessDialog from '../view/SuccessDialog'
import TimerComponent from '../view/TimerComponent'
import TitleComponent from '../view/TitleComponent'
import OriginImageDialog from '../view/OriginImageDialog'
import GameUtils from '../common/util/GameUtils'

// 定义 GamePage 组件
@Entry
@Component
struct GamePage {
  // 创建 TextTimerController 实例
  private textTimerController: TextTimerController = new TextTimerController()

  // 定义并初始化状态变量
  @State rows: number = GameConstants.DEFAULT_ROWS
  @State cols: number = GameConstants.DEFAULT_COLS
  @State withIndex: boolean = GameConstants.WITH_INDEX
  @State croppedImages: CroppedImage[] = []
  @State selectedImage: PixelMap = undefined
  @State selectedImageAspectRatios: number = 0
  @State stepCounter: number = 0
  @State elapsedTime: number = 0

  // 创建 OriginImageDialog 控制器
  private originImageDialogController: CustomDialogController = new CustomDialogController({
    builder: OriginImageDialog({ selectedImage: $selectedImage }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  // 创建 SuccessDialog 控制器
  private successDialogController: CustomDialogController = new CustomDialogController({
    builder: SuccessDialog({
      elapsedTime: this.elapsedTime,
      stepCounter: this.stepCounter,
      tryAgain: () => this.reset(),
      resetDifficulty: () => router.back()
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: false
  })

  // 生命周期钩子，在页面即将出现时触发
  aboutToAppear() {
    this.initDataFromRouter() // 从路由参数初始化数据
    // 计算得到所选图片的宽高比
    this.selectedImage.getImageInfo().then(
      info => this.selectedImageAspectRatios = info.size.width / info.size.height
    )
    // 裁剪图片并开始游戏
    ImageUtils.cutImage(this.selectedImage, this.rows, this.cols, this.withIndex)
      .then(croppedImages => {
        this.croppedImages = croppedImages
        this.croppedImages[this.rows * this.cols-1].pixelMap = null
        this.reset()
      })
  }

  // 从路由参数初始化数据
  initDataFromRouter() {
    this.selectedImage = AppStorage.Get('images')[AppStorage.Get('selectedIndex') as number]
    this.rows = router.getParams()['rows']
    this.cols = router.getParams()['cols']
    this.withIndex = router.getParams()['withIndex']
  }

  // 重置游戏状态
  reset() {
    // 打乱排列，且不能与原始排列相同
    do {
      GameUtils.shuffle(this.croppedImages, this.cols)
    } while (this.checkForSuccess())
    this.stepCounter = 0
    this.textTimerController.reset()
    this.textTimerController.start()
  }

  // 尝试移动子图
  tryMoveImage(index: number): boolean {
    // 取得空白格坐标
    const blankIndex = GameUtils.getBlankIndex(this.croppedImages)
    // 点击图片与空白格不相邻，无法移动
    if (!GameUtils.areIndexesAdjacent(index, blankIndex, this.rows, this.cols)) {
      return false
    }
    // 成功移动，步数加一
    this.stepCounter ++
      // 点击图片与空白格换位
    [this.croppedImages[index], this.croppedImages[blankIndex]] = [this.croppedImages[blankIndex], this.croppedImages[index]]
    if (this.checkForSuccess()) {
      // 已经成功复原，弹出游戏通关对话框
      this.onSuccess()
    }
    return true
  }

  // 游戏通关
  onSuccess(): void {
    // 停止计时
    this.textTimerController.pause()
    // 打开游戏通关对话框
    this.successDialogController.open()
  }

  // 检查是否已成功还原
  checkForSuccess(): boolean {
    for (let i = 0;i < this.croppedImages.length; i++) {
      if (this.croppedImages[i].index != i) {
        return false
      }
    }
    return true
  }

  // 渲染页面的主体结构
  build() {
    Column({ space: 15 }) {
      TitleComponent() // 渲染标题组件
      Row() {
        Row({ space: 5 }) {
          // 创建返回按钮
          Button() {
            Image($r('app.media.back')) // 显示返回图标
          }
          .width(25)
          .height(25)
          .backgroundColor('rgba(0,0,0,0)')
          .onClick(() => router.back()) // 点击按钮时执行返回操作

          // 创建重置按钮
          Button() {
            Image($r('app.media.reset')) // 显示重置图标
          }
          .width(25)
          .height(25)
          .backgroundColor('rgba(0,0,0,0)')
          .onClick(() => this.reset()) // 点击按钮时执行重置游戏操作
        }
        .width('20%')

        // 显示当前游戏难度的行数和列数
        Text(this.rows + '  X  ' + this.cols)
          .fontSize(20)
          .textAlign(TextAlign.Center)

        // 占位用空白组件，仅用于布局
        Text()
          .width('20%')
      }
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('8%')
      .borderWidth({ top: 1, bottom: 1 })
      .borderRadius(5)
      .borderColor('#DEE8E9')

      Row({ space: 5 }) {
        // 计时组件
        TimerComponent({ elapsedTime: $elapsedTime, textTimerController: this.textTimerController })
          .width('35%')
          .height('70%')
        Text('步数    ' + this.stepCounter) // 显示步数
      }.justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('10%')

      Grid() {
        // 遍历并渲染每个拼图格
        ForEach(this.croppedImages, (croppedImage: CroppedImage, index) => {
          GridItem() {
            Image(croppedImage.pixelMap).objectFit(ImageFit.Contain) // 显示拼图图像
          }.onClick(() => this.tryMoveImage(index)) // 点击拼图时触发尝试移动拼图操作
        }, (croppedImage: CroppedImage) => croppedImage.index.toString())
      }
      .aspectRatio(this.selectedImageAspectRatios) // 设置拼图网格的宽高比
      .layoutDirection(GridDirection.Row) // 设置拼图网格的布局方向为行
      .rowsTemplate(GridUtils.generateIsometricTemplate(this.rows)) // 根据行数生成行模板
      .columnsTemplate(GridUtils.generateIsometricTemplate(this.cols)) // 根据列数生成列模板
      .width('80%')

      // 创建查看原图按钮
      Button('查看原图')
        .height('5%')
        .width('25%')
        .onClick(() => this.originImageDialogController.open()) // 点击按钮时打开原图查看对话框
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}