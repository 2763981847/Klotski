import image from '@ohos.multimedia.image'
import CroppedImage from '../entity/CroppedImage'

export default class ImageUtils {
  private static c2d: CanvasRenderingContext2D = new CanvasRenderingContext2D({
    antialias: true
  })
  private static offC2d = new OffscreenCanvasRenderingContext2D(1000, 1000, {
    antialias: true
  })

  public static async pixelMapToArrayBuffer(img: image.PixelMap): Promise<ArrayBuffer> {
    let arrayBuffer = new ArrayBuffer(img.getPixelBytesNumber())
    await  img.readPixelsToBuffer(arrayBuffer)
    console.info('arrayBuffer:' + arrayBuffer.byteLength.toString())
    return arrayBuffer
  }

  public static async cutImage(img: image.PixelMap, rows: number, cols: number, withIndex: boolean = true): Promise<CroppedImage[]> {
    const imgInfo = await img.getImageInfo()
    const size = imgInfo.size
    const eachHeight = size.height / rows
    const eachWidth = size.width / cols
    // const offC2d = new OffscreenCanvasRenderingContext2D(eachWidth, eachHeight, {
    //   antialias: true
    // })
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
        this.offC2d.drawImage(img, startX, startY, eachWidth, eachHeight, 0, 0, eachWidth, eachHeight)
        const index = i * cols + j;
        if (withIndex) {
          this.offC2d.fillText(index + 1 + '', eachWidth / 2, eachHeight / 2)
        }
        // 将子图像添加结果
        result.push(new CroppedImage(this.offC2d.getPixelMap(0, 0, eachWidth, eachHeight), index));
      }
    }
    return result
  }
}