import image from '@ohos.multimedia.image'
import CroppedImage from '../entity/CroppedImage'

/**
 * 图片工具类
 */
export default class ImageUtils {
  // 创建一个静态 OffscreenCanvasRenderingContext2D 实例，用于图像处理
  private static offC2d = new OffscreenCanvasRenderingContext2D(1000, 1000, {
    antialias: true
  })

  /**
   * 等距切割图片
   * @param img 原图
   * @param rows 要切割的行数
   * @param cols 要切割的列数
   * @param withIndex 切割后图片是否标记编号
   * @returns 切割后的图片数组
   */
  public static async cutImage(img: image.PixelMap, rows: number, cols: number, withIndex: boolean = true): Promise<CroppedImage[]> {
    // 获取原图的尺寸信息
    const imgInfo = await img.getImageInfo()
    const size = imgInfo.size
    // 计算分割后子图的尺寸信息
    const eachHeight = size.height / rows
    const eachWidth = size.width / cols

    // 配置 OffscreenCanvasRenderingContext2D
    this.offC2d.font = 'normal bolder 60px sans-serif'
    this.offC2d.fillStyle = 'rgb(255,0,0)'
    this.offC2d.textAlign = 'center'
    this.offC2d.textBaseline = 'middle'

    // 用于存储切割后的子图像的数组
    const result: CroppedImage[] = [];

    // 遍历每行
    for (let i = 0; i < rows; i++) {
      // 遍历每列
      for (let j = 0; j < cols; j++) {
        // 计算切割的起始坐标
        const startX: number = j * eachWidth;
        const startY: number = i * eachHeight;

        // 利用 OffscreenCanvasRenderingContext2D 进行图像切割
        this.offC2d.drawImage(img, startX, startY, eachWidth, eachHeight, 0, 0, eachWidth, eachHeight)

        // 计算图像编号
        const index = i * cols + j;

        // 如果 withIndex 为真，将图像编号添加到子图像中
        if (withIndex) {
          this.offC2d.fillText(index + 1 + '', eachWidth / 2, eachHeight / 2)
        }

        // 将子图像添加到结果数组
        result.push(new CroppedImage(this.offC2d.getPixelMap(0, 0, eachWidth, eachHeight), index));
      }
    }

    // 返回切割后的子图像数组
    return result
  }
}
