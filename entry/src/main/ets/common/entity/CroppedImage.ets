// 定义一个名为CroppedImage的类，用于表示裁剪后的图像
export default class CroppedImage {
  public pixelMap: PixelMap; // pixelMap属性存储裁剪后的图像
  public index: number; // index属性存储切割图像对应的索引

  // 构造函数，接受一个PixelMap对象和一个整数索引作为参数
  constructor(pixelMap: PixelMap, index: number) {
    this.pixelMap = pixelMap;
    this.index = index;
  }
}
