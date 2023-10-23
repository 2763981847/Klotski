@Component
export default struct TimerComponent {
  // 使用 @Link 注解将组件的属性与父组件进行双向绑定
  @Link elapsedTime: number // 通关用时（毫秒）
  private textTimerController: TextTimerController // 文本计时器控制器

  // 构建 TimerComponent 组件的 UI 布局
  build() {
    Row({ space: 10 }) { // 创建水平行布局，指定水平间距
      Image($r('app.media.timer')) // 显示计时器图标
        .objectFit(ImageFit.Contain) // 设置图像适应方式
        .width('15%')
      TextTimer({ controller: this.textTimerController }) // 创建文本计时器组件并关联控制器
        .format('HH:mm:ss') // 设置时间格式为 'HH:mm:ss'
        .fontColor(Color.Black)
        .fontSize(16)
        .onTimer((_utc: number, elapsedTime: number) => {
          this.elapsedTime = elapsedTime; // 在计时器回调中更新通关用时属性
        })
        .width('70%')
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}
