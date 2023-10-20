@Preview
@Component
export default struct TimerComponent {
  @Link elapsedTime: number
  private textTimerController: TextTimerController

  build() {
    Row({ space: 10 }) {
      Image($r('app.media.timer'))
        .objectFit(ImageFit.Contain)
        .width('15%')
      TextTimer({ controller: this.textTimerController })
        .format('HH:mm:ss')
        .fontColor(Color.Black)
        .fontSize(16)
        .onTimer((_utc: number, elapsedTime: number) => {
          this.elapsedTime = elapsedTime
        })
        .width('70%')
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}
