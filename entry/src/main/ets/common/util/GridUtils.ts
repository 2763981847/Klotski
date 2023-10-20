export default class GridUtils {
  public static generateIsometricTemplate(total: number): string {
    let result: string = '1fr'
    for (let i = 1;i < total; i++) {
      result += ' 1fr'
    }
    return result
  }
}