// PageOne.ets
@Component
export default  struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("我被抽离出来了，后面可以写很多工具页面了")
      }.width('100%').height('100%')
    }.title("工具1")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}