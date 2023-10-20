import { difficultyLevels } from './model/DifficultyLevels'

@Component
export default struct DifficultySelectComponent {
  @Link rows: number
  @Link cols: number
  @Link withIndex: boolean

  build() {
    Column({ space: 10 }) {
      Text('请选择难度')
        .fontSize(20)
        .fontColor('#182431')
      Row({ space: 30 }) {
        Row() {
          Select(difficultyLevels)
            .value(this.rows.toString())
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => {
              console.info('Select:' + index)
              this.rows = +difficultyLevels[index].value
            })
          Text('X')
            .fontSize(16)
            .fontColor('#182431')
          Select(difficultyLevels)
            .value(this.cols.toString())
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => {
              console.info('Select:' + index)
              this.cols = +difficultyLevels[index].value
            })
        }

        Text()

        Row({ space: 5 }) {
          Checkbox()
            .select(true)
            .selectedColor(0xed6f21)
            .onChange((value: boolean) => {
              this.withIndex = value
            })
          Text('显示图片编号')
            .fontColor('#182431')
            .fontSize(16)
        }

      }.height('50%')
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .height('100%')
    .width('100%')
    .borderColor('#DEE8E9')
    .borderWidth(1)
    .borderRadius(5)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}