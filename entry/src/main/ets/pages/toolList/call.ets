@Component
export default  struct Call {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("模拟打电话")
      }.width('100%').height('100%')
    }.title("call")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}