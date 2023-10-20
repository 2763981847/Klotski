export default class MathUtils {
  public static shuffle<T>(array: Array<T>): void {
    let n = array.length, random;
    while (0 != n) {
      random = (Math.random() * n--) >>> 0;
      [array[n], array[random]] = [array[random], array[n]]
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
}