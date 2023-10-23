// 导入 difficultyLevels 对象，它包含不同难度级别的配置
import { difficultyLevels } from './model/DifficultyLevels'

// 标记为组件
@Component
export default struct DifficultySelectComponent {
  // 使用 @Link 注解将组件状态父组件进行双向绑定
  @Link rows: number // 行数
  @Link cols: number // 列数
  @Link withIndex: boolean // 是否显示图片编号

  // 构建组件的 UI 布局
  build() {
    Column({ space: 10 }) { // 创建垂直列布局，指定垂直间距
      Text('请选择难度') // 提示文本
        .fontSize(20)
        .fontColor('#182431')
      Row({ space: 30 }) { // 创建水平行布局，指定水平间距
        Row() { // 行列难度选择板块
          Select(difficultyLevels) // 创建行选择器
            .value(this.rows.toString()) // 设置选择框的当前值为行数
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => { // 处理选择事件
              this.rows = +difficultyLevels[index].value // 更新行数
            })

          Text('X')
            .fontSize(16)
            .fontColor('#182431')

          Select(difficultyLevels) // 创建列选择器
            .value(this.cols.toString()) // 设置选择框的当前值为列数
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => { // 处理选择事件
              this.cols = +difficultyLevels[index].value // 更新列数
            })
        }

        Text() // 空白文本，仅用于SpaceAround布局占位

        Row({ space: 5 }) { // 选择是否显示编号模块
          Checkbox() // 创建复选框
            .select(true) // 默认选中
            .selectedColor(0xed6f21)
            .onChange((value: boolean) => { // 处理复选框状态变更事件
              this.withIndex = value // 更新是否显示图片编号的状态
            })

          Text('显示图片编号') // 提示文本
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
