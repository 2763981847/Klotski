// 辅助函数，用于将毫秒格式化为 'HH:mm:ss' 时间字符串
function formatMillisecondsToHHMMSS(milliseconds: number): string {
  if (milliseconds < 0) {
    return '00:00:00'; // 如果传入的毫秒数小于0，返回默认时间字符串
  }

  // 将毫秒转化为秒
  const seconds = Math.floor(milliseconds / 1000);

  // 计算小时、分钟和秒
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const remainingSeconds = seconds % 60;

  // 格式化为 'HH:mm:ss'
  const formattedHours = String(hours).padStart(2, '0'); // 使用 padStart 将小时格式化为两位数
  const formattedMinutes = String(minutes).padStart(2, '0'); // 使用 padStart 将分钟格式化为两位数
  const formattedSeconds = String(remainingSeconds).padStart(2, '0'); // 使用 padStart 将秒格式化为两位数

  return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`; // 返回格式化后的时间字符串
}

// 使用 @CustomDialog 注解来定义自定义对话框组件
@CustomDialog
export default struct SuccessDialog {
  // 使用 @Prop 注解将组件的状态变量与父组件单向绑定
  @Prop elapsedTime: number // 通关用时（毫秒）
  @Prop stepCounter: number // 步数计数

  private controller: CustomDialogController
  tryAgain: () => void // 再来一次
  resetDifficulty: () => void // 重设难度

  // 构建对话框组件的 UI 布局
  build() {
    Column({ space: 10 }) { // 创建垂直列布局，指定垂直间距
      Row({ space: 10 }) { // 创建水平行布局，指定水平间距
        Image($r('app.media.congratulation')) // 显示祝贺图标
          .height(30)
          .objectFit(ImageFit.Contain) // 设置图像适应方式
        Text('通关啦') // 提示文本
          .fontSize(30)
        Image($r('app.media.congratulation')) // 显示祝贺图标
          .height(30)
          .objectFit(ImageFit.Contain) // 设置图像适应方式
      }.justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      // 显示通关用时和使用步数
      Text('本次用时:' + formatMillisecondsToHHMMSS(this.elapsedTime))
      Text('使用步数:' + this.stepCounter)

      Row({ space: 20 }) { // 创建水平行布局，指定水平间距
        // 创建“再来一次”按钮，并在点击时触发 tryAgain 回调函数
        Button('再来一次')
          .onClick(() => {
            this.tryAgain(); // 触发再来一次回调
            this.controller.close(); // 关闭对话框
          })

        // 创建“重设难度”按钮，并在点击时触发 resetDifficulty 回调函数
        Button('重设难度')
          .onClick(() => {
            this.resetDifficulty(); // 触发重设难度回调
            this.controller.close(); // 关闭对话框
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
