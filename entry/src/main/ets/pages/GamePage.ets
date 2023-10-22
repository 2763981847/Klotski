import CroppedImage from '../common/entity/CroppedImage'
import GridUtils from '../common/util/GridUtils'
import ImageUtils from '../common/util/ImageUtils'
import router from '@ohos.router'
import GameConstants from '../common/constant/GameConstants'
import MathUtils from '../common/util/MathUtils'
import SuccessDialog from '../view/SuccessDialog'
import TimerComponent from '../view/TimerComponent'
import TitleComponent from '../view/TitleComponent'
import OriginImageDialog from '../view/OriginImageDialog'


@Entry
@Component
struct GamePage {
  private textTimerController: TextTimerController = new TextTimerController()
  @State rows: number = GameConstants.DEFAULT_ROWS
  @State cols: number = GameConstants.DEFAULT_COLS
  @State withIndex: boolean = GameConstants.WITH_INDEX
  @State croppedImages: CroppedImage[] = []
  @State selectedImage: PixelMap = undefined
  @State selectedImageAspectRatios: number = 0
  @State stepCounter: number = 0
  @State elapsedTime: number = 0
  private originImageDialogController: CustomDialogController = new CustomDialogController({
    builder: OriginImageDialog({ selectedImage: $selectedImage }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
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

  aboutToAppear() {
    this.initDataFromRouter()
    this.selectedImage.getImageInfo().then(
      info => this.selectedImageAspectRatios = info.size.width / info.size.height
    )
    ImageUtils.cutImage(this.selectedImage, this.rows, this.cols, this.withIndex)
      .then(croppedImages => {
        this.croppedImages = croppedImages
        this.croppedImages[this.rows * this.cols-1].pixelMap = null
        this.reset()
      })
  }

  initDataFromRouter() {
    this.selectedImage = AppStorage.Get('images')[AppStorage.Get('selectedIndex') as number]
    this.rows = router.getParams()['rows']
    this.cols = router.getParams()['cols']
    this.withIndex = router.getParams()['withIndex']
  }

  reset() {
    do {
      MathUtils.shuffle(this.croppedImages)
    } while (this.checkForSuccess())
    this.stepCounter = 0
    this.textTimerController.reset()
    this.textTimerController.start()
  }

  tryMoveImage(index: number): boolean {
    const blankIndex = this.getBlankIndex()
    if (!MathUtils.areIndexesAdjacent(index, blankIndex, this.cols)) {
      return false
    }
    this.stepCounter ++
    [this.croppedImages[index], this.croppedImages[blankIndex]] = [this.croppedImages[blankIndex], this.croppedImages[index]]
    if (this.checkForSuccess()) {
      this.onSuccess()
    }
    return true
  }

  onSuccess(): void {
    this.textTimerController.pause()
    this.successDialogController.open()
  }

  checkForSuccess(): boolean {
    for (let i = 0;i < this.croppedImages.length; i++) {
      if (this.croppedImages[i].index != i) {
        return false
      }
    }
    return true
  }

  getBlankIndex(): number {
    for (let i = 0;i < this.croppedImages.length; i++) {
      if (this.croppedImages[i].pixelMap === null) {
        return i
      }
    }
    return -1
  }

  build() {
    Column({ space: 15 }) {
      TitleComponent()
      Row() {
        Row({ space: 5 }) {
          Button() {
            Image($r('app.media.back'))
          }
          .width(25)
          .height(25)
          .backgroundColor('rgba(0,0,0,0)')
          .onClick(() => router.back())

          Button() {
            Image($r('app.media.reset'))
          }
          .width(25)
          .height(25)
          .backgroundColor('rgba(0,0,0,0)')
          .onClick(() => this.reset())
        }
        .width('20%')

        Text(this.rows + '  X  ' + this.cols)
          .fontSize(20)
          .textAlign(TextAlign.Center)
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
        TimerComponent({ elapsedTime: $elapsedTime, textTimerController: this.textTimerController })
          .width('35%')
          .height('70%')
        Text('步数    ' + this.stepCounter)
      }.justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('10%')

      Grid() {
        ForEach(this.croppedImages, (croppedImage: CroppedImage, index) => {
          GridItem() {
            Image(croppedImage.pixelMap).objectFit(ImageFit.Contain)
          }.onClick(() => this.tryMoveImage(index))
        }, (croppedImage: CroppedImage) => croppedImage.index.toString())
      }
      .aspectRatio(this.selectedImageAspectRatios)
      .layoutDirection(GridDirection.Row)
      .rowsTemplate(GridUtils.generateIsometricTemplate(this.rows))
      .columnsTemplate(GridUtils.generateIsometricTemplate(this.cols))
      .width('80%')

      Button('查看原图')
        .height('5%')
        .width('25%')
        .onClick(() => this.originImageDialogController.open())
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')

  }
}