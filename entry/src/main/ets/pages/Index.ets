import pageOneTmp from './toolList/PageOne'

import EnDeCode from './toolList/EnDeCode'
import Eat from './toolList/eat'
import BodyFatCalculators from './toolList/bodyFatCalculator'
import Call from './toolList/call'
import FamilyRelationCalculator from './toolList/familyRelationCalculator'
import QrCode from './toolList/qrCode'
import WoodenFish from './toolList/woodenFish'


interface ToolList {
  title: string
  info?: string
  cpn?: string
}

@Entry
@Component
struct Index {
  @State TooTmp: ToolbarItem = {'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}

  private toolList: Array<ToolList> = [
    {
      title: "加解密编码",
      info: 'MD5, base 64, 对称加密对称加密对称加密对称加密对称加密对称加密对称加密对称加密对称加密对称加密对称加密对称加密。。。',
      cpn: 'EnDeCode'
    },
    {
      title: "二维码生成器",
      info: '在线生成二维码',
      cpn: 'QrCode'
    },
    {
      title: "今天吃什么",
      info: '今天吃什么是一个人生大问题',
      cpn: 'Eat'
    },
    {
      title: "功德木鱼",
      info: '我佛慈悲',
      cpn: 'WoodenFish'
    },
    {
      title: "电话模拟器",
      info: '打个电话吧 (敬请期待)',
      // cpn: "Call"
    },
    {
      title: "关系计算器",
      info: '爸爸的爸爸叫什么？ (敬请期待)',
      // cpn: "FamilyRelationCalculator"
    },
    {
      title: "体脂计算器",
      info: '今天的你也要美美哒 (敬请期待)',
      // cpn: 'BodyFatCalculators'
    },


    {
      title: "更多功能",
      info: "作者正在发现新点子，持续更新中..."
    }
  ]


  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === "EnDeCode") {
      EnDeCode()
    } else if (name === "Eat") {
      Eat()
    } else if (name === "BodyFatCalculators") {
      BodyFatCalculators()
    } else if (name === "Call") {
      Call()
    } else if (name === "FamilyRelationCalculator") {
      FamilyRelationCalculator()
    } else if (name === "QrCode") {
      QrCode()
    } else if (name === "WoodenFish") {
      WoodenFish()
    }
  }

  build() {
    Column() {
      Navigation(this.pageInfos) {
        List({ space: 12 }) {
          ForEach(this.toolList, (item: ToolList) => {
            ListItem() {
              Row(){
                Column() {
                  Text(item.title)
                    .fontWeight(600)
                    .fontSize(14)
                  Text(item.info)
                    .textOverflow({
                      overflow: TextOverflow.Ellipsis
                    })
                    .maxLines(1)
                    .fontSize(12)
                    .width('80%')
                    .fontColor("#ff929292")
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(HorizontalAlign.Start)
                .height('100%')
                Blank()
                if (item.cpn) {
                  Image('/common/images/arrows-right.svg')
                    .height('12')
                }
              }
              .width("100%")
              .padding('16 20')
              .height(72)
              .backgroundColor('#F1F3F5')
              .borderRadius(16)
              .onClick(()=>{
                if (item.cpn) {
                  this.pageInfos.pushPath({ name: item.cpn})
                } else {

                }
              })
            }
          })
        }
        .scrollBarWidth(0)
        .width("100%")
        .padding({
          left: '5%',
          right: '5%'
        })
        .margin({ top: 12 })

      }
      .title("Yo 工具箱")
      .navDestination(this.PageMap) // 子页面
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(true)
      .menus([ // 顶部菜单栏
        // {value: "列表", icon: '/common/images/list.svg', action: ()=> {}},
        // {value: "宫格", icon: '/common/images/grid.svg', action: ()=> {}},
        // {value: "设置", icon: '/common/images/edit.svg', action: ()=> {}},
      ])
    }
    // .backgroundColor('#F1F3F5')
    .height('100%')
    .width('100%')
  }
}




// PageTwo.ets
@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent2")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle2")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageThree.ets
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}