import ImageSelectComponent from '../view/ImageSelectComponent';
import { imageResources } from '../view/model/ImageResources';
import router from '@ohos.router';
import GameConstants from '../common/constant/GameConstants';
import IOUtils from '../common/util/IOUtils';
import DifficultySelectComponent from '../view/DifficultySelectComponent';
import TitleComponent from '../view/TitleComponent';


@Entry()
@Component
struct Index {
  @State rows: number = GameConstants.DEFAULT_ROWS
  @State cols: number = GameConstants.DEFAULT_COLS
  @State withIndex: boolean = GameConstants.WITH_INDEX
  @StorageLink('selectedIndex') selectedIndex: number = 0
  @StorageLink('images') images: PixelMap[] = []

  aboutToAppear() {
    if (this.images.length === 0) {
      IOUtils.getPixelMapsFromResource(imageResources)
        .then(images => this.images = images)
    }
  }

  startGame() {
    router.pushUrl(
      { url: 'pages/GamePage',
        params: {
          rows: this.rows,
          cols: this.cols,
          withIndex: this.withIndex
        }
      })
  }

  build() {
    Column({ space: 20 }) {
      TitleComponent()
      DifficultySelectComponent({ rows: $rows, cols: $cols, withIndex: $withIndex })
        .height('10%')
        .width('100%')
      ImageSelectComponent({ selectedIndex: $selectedIndex, images: $images })
        .height('70%')
        .width('100%')
      Button('开始挑战')
        .height('8%')
        .width('50%')
        .onClick(() => this.startGame())
    }.height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}