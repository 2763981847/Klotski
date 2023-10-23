// 导入所需的模块
import image from '@ohos.multimedia.image'; // 用于图像处理
import picker from '@ohos.file.picker'; // 用于文件选择
import fileIo from '@ohos.file.fs'; // 用于文件操作

/**
 * IO工具类
 */
export default class IOUtils {
  // 创建一个 PhotoViewPicker 实例，用于从相册选择照片
  private static photoPicker = new picker.PhotoViewPicker();

  /**
   * 从resource中取出pixelMap
   * @param resource 指定资源
   * @returns pixelMap
   */
  public static async getPixelMapFromResource(resource: Resource): Promise<image.PixelMap> {
    // 通过资源管理器获取资源的字节数组
    const array = await getContext().resourceManager.getMediaContent(resource);

    // 利用字节数组创建图像源并从中创建 PixelMap
    return await image.createImageSource(array.buffer).createPixelMap();
  }

  /**
   * 从resource中取出多个pixelMap
   * @param resources 指定资源数组
   * @returns pixelMap数组
   */
  public static async getPixelMapsFromResource(resources: Resource[]): Promise<image.PixelMap[]> {
    const pixelMaps: image.PixelMap[] = [];

    // 遍历资源数组
    for (let i = 0; i < resources.length; i++) {
      // 通过资源管理器获取资源的字节数组
      const array = await getContext().resourceManager.getMediaContent(resources[i]);

      // 利用字节数组创建图像源并从中创建 PixelMap，然后将其添加到 pixelMaps 数组中
      pixelMaps.push(await image.createImageSource(array.buffer).createPixelMap());
    }
    return pixelMaps; // 返回包含多个 PixelMap 的数组
  }

  /**
   * 从相册中选择并图片并获取 PixelMap
   * @returns 选取的pixelMap
   */
  public static async getPixelMapFromAlbum(): Promise<image.PixelMap> {

    // 通过选择器选择照片，限制最多选择 1 张图片（maxSelectNumber: 1）
    // 以及指定 MIME 类型为图片类型（MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE）
    const result = await IOUtils.photoPicker.select({
      maxSelectNumber: 1,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    });

    // 获取选择的照片的文件描述符（file descriptor）
    let fd = fileIo.openSync(result.photoUris[0]).fd;

    // 利用文件描述符创建图像源并从中创建 PixelMap
    return await image.createImageSource(fd).createPixelMap();
  }
}
