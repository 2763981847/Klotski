@CustomDialog
export default struct OriginImageDialog {
  @Link selectedImage: PixelMap
  controller: CustomDialogController

  build() {
    Column() {
      Image(this.selectedImage)
        .objectFit(ImageFit.Contain)
        .height('80%')
        .width('80%')
      Button('收起原图')
        .onClick(() => {
          this.controller.close()
        })
        .margin({ bottom: 10 })
    }.alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}