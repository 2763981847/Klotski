import display from '@ohos.display';
import Constants from '../common/constant/Constants';
import IOUtils from '../common/util/IOUtils';

enum scrollTypeEnum {
  STOP = 'onScrollStop',
  SCROLL = 'onScroll'
};

@Component
export default struct ImageSelectComponent {
  private smallScroller: Scroller = new Scroller();
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  @State smallImgWidth: number = (this.deviceWidth - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
  @Link selectedIndex: number;
  @Link images: PixelMap[]

  aboutToAppear() {
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let width = displayClass?.width / displayClass.densityPixels ?? Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
  }

  onPageShow() {
    this.smallScroller.scrollToIndex(this.selectedIndex);
  }

  smallImgClickAction(index: number): void {
    this.selectedIndex = index;
    this.smallScroller.scrollToIndex(this.selectedIndex);
  }

  smallScrollAction(type: scrollTypeEnum): void {
    this.selectedIndex = Math.round(((this.smallScroller.currentOffset().xOffset as number) +
    this.smallImgWidth / 2) / (this.smallImgWidth + Constants.LIST_ITEM_SPACE));
    if (type === scrollTypeEnum.STOP) {
      this.smallScroller.scrollTo({ xOffset: this.selectedIndex * this.smallImgWidth, yOffset: 0 });
    }
  }

  async selectFromAlbum() {
    let pixelMap = await IOUtils.getPixelMapFromAlbum()
    let temp = [pixelMap]
    temp.push(...this.images)
    this.images = temp
    this.selectedIndex = 0
    this.smallScroller.scrollToIndex(0)
  }

  build() {
    Column({ space: 20 }) {
      Text('请选择图片')
        .fontSize(20)
        .fontColor('#182431')
      Image(this.images[this.selectedIndex])
        .objectFit(ImageFit.Contain)
        .height('70%')
        .width('80%')
      List({
        scroller: this.smallScroller,
        space: Constants.LIST_ITEM_SPACE,
        initialIndex: this.selectedIndex
      }) {
        ForEach(this.images, (img: PixelMap, index?: number) => {
          ListItem() {
            Image(img)
              .onClick(() => this.smallImgClickAction(index))
          }
          .width(this.smallImgWidth)
          .aspectRatio(1)
        }, (item: PixelMap, index) => index.toString() + Date.now().toString())
      }
      .listDirection(Axis.Horizontal)
      .onScroll((scrollOffset, scrollState) => {
        if (scrollState === ScrollState.Fling) {
          this.smallScrollAction(scrollTypeEnum.SCROLL);
        }
      })
      .onScrollStop(() => this.smallScrollAction(scrollTypeEnum.STOP))
      .height(this.smallImgWidth)
      .width('100%')

      Row() {
        Text('从相册选择图片')
          .fontSize(16)
          .fontColor('#182431')
        Button("浏览图片", { type: ButtonType.Normal })
          .fontColor('#182431')
          .fontSize(16)
          .height('70%')
          .borderRadius(5)
          .onClick(() => this.selectFromAlbum())
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