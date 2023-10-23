/**
 * 网格组件工具类
 */
export default class GridUtils {

  /**
   * 生成一个等距网格的模板字符串，用于网格布局
   * @param total 给定的行数或列数
   * @returns 模板字符串
   */
  public static generateIsometricTemplate(total: number): string {
    let result: string = '1fr';
    for (let i = 1; i < total; i++) {
      result += ' 1fr';
    }
    return result;
  }
}
