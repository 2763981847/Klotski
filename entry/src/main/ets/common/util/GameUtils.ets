import CroppedImage from '../entity/CroppedImage';

/**
 * 游戏工具类
 */
export default class GameUtils {


  /**
   * 打乱函数
   * @param array 分割后的子图数组
   * @param cols 分割的列数
   */
  public static shuffle(array: Array<CroppedImage>, cols: number): void {
    // 获取空白图块的索引
    let blankIndex = this.getBlankIndex(array);
    // 定义移动方向，包括左、右、上、下
    const n = array.length, direction = [-1, 1, -cols, cols];
    // 循环 n*n 次，打乱图块的位置
    for (let i = 0; i < n * n; i++) {
      let nextBlankIndex;
      // 随机选择一个方向，直到找到有效的下一个空白图块的索引
      do {
        nextBlankIndex = blankIndex + direction[Math.floor(Math.random() * 4)];
        // 随机得到的坐标不合法或者在二维化后的子图数组中并不相邻
      } while (!this.areIndexesAdjacent(blankIndex, nextBlankIndex, n / cols, cols));
      // 交换当前图块和下一个空白图块的位置
      [array[blankIndex], array[nextBlankIndex]] = [array[nextBlankIndex], array[blankIndex]];
      blankIndex = nextBlankIndex;
    }
  }

  /**
   * 检查两个索引在二维化后的子图数组是否相邻
   * @param index1 索引1
   * @param index2 索引2
   * @param rows 分割的行数
   * @param cols 分割的列数
   * @returns 是否相邻
   */
  public static areIndexesAdjacent(index1: number, index2: number, rows: number, cols: number): boolean {
    // 检查给定索引是否合法
    if (index1 < 0 || index1 >= rows * cols || index2 < 0 || index2 >= rows * cols) {
      // 不合法，返回false
      return false
    }
    // 计算 index1 和 index2 在矩阵中的行和列
    const row1 = Math.floor(index1 / cols);
    const col1 = index1 % cols;
    const row2 = Math.floor(index2 / cols);
    const col2 = index2 % cols;

    // 判断两个索引是否在同一行或同一列，并且相邻
    if ((Math.abs(row1 - row2) === 1 && col1 === col2) || (Math.abs(col1 - col2) === 1 && row1 === row2)) {
      return true;
    }
    return false;
  }

  /**
   * 获取子图数组中空白格的索引
   * @param array 子图数组
   * @returns 空白格索引
   */
  public static getBlankIndex(array: Array<CroppedImage>): number {
    for (let i = 0; i < array.length; i++) {
      // 如果图块的像素映射为 null，则表示为空白图块
      if (array[i].pixelMap === null) {
        return i; // 返回空白图块的索引
      }
    }
    return -1; // 如果没有找到空白图块，返回 -1
  }
}
