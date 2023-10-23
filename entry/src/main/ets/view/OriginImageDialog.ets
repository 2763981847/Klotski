// 使用 @CustomDialog 注解来定义自定义对话框组件
@CustomDialog
export default struct OriginImageDialog {
  // 使用 @Link 注解将组件状态与父组件进行双向绑定
  @Link selectedImage: PixelMap // 选中的图像
  controller: CustomDialogController // 自定义对话框控制器

  // 构建对话框组件的 UI 布局
  build() {
    Column() { // 创建垂直列布局
      Image(this.selectedImage) // 显示选中的图像
        .objectFit(ImageFit.Contain) // 设置图像适应方式为包含
        .height('80%')
        .width('80%')

      Button('收起原图') // 创建 '收起原图' 按钮
        .onClick(() => {
          this.controller.close() // 点击按钮时触发 close 方法关闭对话框
        })
        .margin({ bottom: 10 })
    }.alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
