import image from '@ohos.multimedia.image'
import picker from '@ohos.file.picker'
import fileIo from '@ohos.file.fs'
import resourceManager from '@ohos.resourceManager'

export default class IOUtils {
  public static async getPixelMapFromResource(resource: Resource): Promise<image.PixelMap> {
    const array = await getContext().resourceManager.getMediaContent(resource)
    return await image.createImageSource(array.buffer).createPixelMap()
  }

  public static async getPixelMapsFromResource(resources: Resource[]): Promise<image.PixelMap[]> {
    const pixelMaps: image.PixelMap[] = []
    for (let i = 0; i < resources.length; i++) {
      const array = await getContext().resourceManager.getMediaContent(resources[i])
      pixelMaps.push(await image.createImageSource(array.buffer).createPixelMap())
    }
    return pixelMaps
  }


  public static async getPixelMapFromAlbum(): Promise<image.PixelMap> {
    const photoPicker = new picker.PhotoViewPicker()
    const result = await photoPicker.select({
      maxSelectNumber: 1, MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    let fd = fileIo.openSync(result.photoUris[0]).fd
    return await image.createImageSource(fd).createPixelMap()
  }

}