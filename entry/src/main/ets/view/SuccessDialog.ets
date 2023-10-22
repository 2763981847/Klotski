@CustomDialog
export default struct SuccessDialog {
  @Prop elapsedTime: number
  @Prop stepCounter: number
  private controller: CustomDialogController
  tryAgain: () => void
  resetDifficulty: () => void

  formatMillisecondsToHHMMSS(milliseconds: number): string {
    if (milliseconds < 0) {
      return '00:00:00';
    }

    // 将毫秒转化为秒
    const seconds = Math.floor(milliseconds / 1000);

    // 计算小时、分钟和秒
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainingSeconds = seconds % 60;

    // 格式化为 'HH:mm:ss'
    const formattedHours = String(hours).padStart(2, '0');
    const formattedMinutes = String(minutes).padStart(2, '0');
    const formattedSeconds = String(remainingSeconds).padStart(2, '0');

    return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Image($r('app.media.congratulation'))
          .height(30)
          .objectFit(ImageFit.Contain)
        Text('通关啦')
          .fontSize(30)
        Image($r('app.media.congratulation'))
          .height(30)
          .objectFit(ImageFit.Contain)
      }.justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Text('本次用时:' + this.formatMillisecondsToHHMMSS(this.elapsedTime))
      Text('使用步数:' + this.stepCounter)
      Row({ space: 20 }) {
        Button('再来一次')
          .onClick(() => {
            this.tryAgain()
            this.controller.close()
          })
        Button('重设难度')
          .onClick(() => {
            this.resetDifficulty()
            this.controller.close()
          })
      }.justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(HorizontalAlign.Center)
    .height('70%')
    .width('70%')
  }
}