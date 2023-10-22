import CroppedImage from '../entity/CroppedImage';
import Stack from '@ohos.util.Stack';

export default class GameUtils {

  public static shuffle(array: Array<CroppedImage>, cols: number): void {
    let blankIndex = this.getBlankIndex(array)
    const n = array.length, direction = [-1, 1, -cols, cols]
    for (let i = 0; i < n * n; i++) {
      let nextBlankIndex
      do {
        nextBlankIndex = blankIndex + direction[Math.floor(Math.random() * 4)];
      } while (nextBlankIndex < 0 || nextBlankIndex >= n || !this.areIndexesAdjacent(blankIndex, nextBlankIndex, cols))
      [array[blankIndex], array[nextBlankIndex]] = [array[nextBlankIndex], array[blankIndex]]
      blankIndex = nextBlankIndex
    }
  }

  public static areIndexesAdjacent(index1: number, index2: number, cols: number): boolean {
    // 计算 index1 和 index2 在矩阵中的行和列
    const row1 = Math.floor(index1 / cols);
    const col1 = index1 % cols;
    const row2 = Math.floor(index2 / cols);
    const col2 = index2 % cols;
    // 判断两个索引是否相邻
    if (
      (Math.abs(row1 - row2) === 1 && col1 === col2) ||
      (Math.abs(col1 - col2) === 1 && row1 === row2)
    ) {
      return true;
    }
    return false;
  }

  public static getBlankIndex(array: Array<CroppedImage>): number {
    for (let i = 0;i < array.length; i++) {
      if (array[i].pixelMap === null) {
        return i
      }
    }
    return -1
  }
}