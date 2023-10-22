import { Size } from '@ohos/hypium'
import hash from '@ohos.file.hash'

export default class CroppedImage {
  public pixelMap: PixelMap
  public index: number

  constructor(pixelMap: PixelMap, index: number) {
    this.pixelMap = pixelMap
    this.index = index
  }
}