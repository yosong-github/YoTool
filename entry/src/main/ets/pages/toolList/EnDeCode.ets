// xxx.ets
import { LengthMetrics } from '@kit.ArkUI'
import { CommonUtil } from '../../common/CommonUtil'

import CryptoJS from '@ohos/crypto-js'


// //第二步定义加密解密需要用到的key
// const key = '111111'
// const message = 'yosong'
//
// let aesBase64 = CryptoJS.AES.encrypt(message, key, {
//
// }).toString()
//
// console.log(aesBase64, 'aes')
//
// let str = CryptoJS.AES.decrypt(aesBase64, key)
// // 最终得到结果res
// let res = CryptoJS.enc.Utf8.stringify(str)
//
// console.log(res)


interface ModeMap {
  'CBC': CryptoJS.BlockCipherMode,
  'CFB': CryptoJS.BlockCipherMode,
  'CTR': CryptoJS.BlockCipherMode,
  'OFB': CryptoJS.BlockCipherMode,
  'ECB': CryptoJS.BlockCipherMode,
}

@Component
export default  struct EnDeCode {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()


  // MD5 铭文
  @State MD5Txt: string = ''
  // 密文
  @State MD5Res: string = ''
  // Base 64 铭文
  @State B64Txt: string = ''
  // 密文
  @State B64Res: string = ''

  // AES
  @State AES_key: string = ''
  @State AES_txt: string = ''
  @State AES_res: string = ''
  @State AES_mode: string = 'CBC'
  private modeMap: ModeMap = {
    'CBC': CryptoJS.mode.CBC,
    'CFB': CryptoJS.mode.CFB,
    'CTR': CryptoJS.mode.CTR,
    'OFB': CryptoJS.mode.OFB,
    'ECB': CryptoJS.mode.ECB,
  }



  @Builder tabBuilder(title: string,targetIndex: number) {
    Column(){
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .fontWeight(this.currentIndex == targetIndex ? '600' : '')
    }.width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    NavDestination() {
      Tabs() {
        TabContent() {
          Column({space: 12}) {
            TextArea({placeholder: '请输入要加密的明文', text: this.MD5Txt})
              .onChange((value: string) => {
                if (value == '') {
                  this.MD5Res = ''
                } else {
                  this.MD5Txt = value
                }
              })
              .height(200)
            Button('加密')
              .width('100%')
              .onClick(() => {
                this.MD5Res = CryptoJS.MD5(this.MD5Txt) + ''
              })

            Column() {
              Text('MD5结果：')
              TextArea({text: this.MD5Res})
                .margin({top: 12})

            }
            .alignItems(HorizontalAlign.Start)

          }
          .padding(12)
          .height('100%')
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .tabBar(this.tabBuilder('MD5', 0))

        TabContent() {
          Column({space: 12}) {
            TextArea({placeholder: '请输入要加密的明文', text: this.MD5Txt})
              .onChange((value: string) => {
                if (value == '') {
                  this.B64Res = ''
                } else {
                  this.B64Txt = value
                }
              })
              .height(200)
            Button('加密')
              .width('100%')
              .onClick(() => {
                this.B64Res = CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(this.B64Txt))
              })
            Button('解密')
              .width('100%')
              .onClick(() => {
                this.B64Res = CryptoJS.enc.Base64.parse(this.B64Txt).toString(CryptoJS.enc.Utf8)
              })

            Column() {
              Text('Base 64 结果：')
              TextArea({text: this.B64Res})
                .margin({top: 12})

            }
            .alignItems(HorizontalAlign.Start)

          }
          .padding(12)
          .height('100%')
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .tabBar(this.tabBuilder('Base 64', 1))

        TabContent() {

          Column({space: 12}) {
            TextInput({placeholder: '加密Key', text: this.AES_key})
              .onChange((value: string) => {
                this.AES_key = value
              })
              .height(50)
            Row({space: 12}) {
              Text('模式')
              Select([
                {value: 'CBC'},
                // {value: 'CFB'},
                // {value: 'CTR'},
                // {value: 'OFB'},
                // {value: 'ECB'},
              ])
                .value(this.AES_mode)
              }
            TextArea({placeholder: '请输入要加密/解密的明文', text: this.AES_txt})
              .onChange((value: string) => {
                if (value == '') {
                  this.AES_res = ''
                } else {
                  this.AES_txt = value
                }
              })
              .height(200)
            Button('加密')
              .width('100%')
              .onClick(() => {
                this.AES_res = CryptoJS.AES.encrypt(this.AES_txt, this.AES_key, {
                  mode: Reflect.get(this.modeMap, this.AES_mode)
                }).toString()
              })
            Button('解密')
              .width('100%')
              .onClick(() => {
                this.AES_res = CryptoJS.enc.Utf8.stringify(CryptoJS.AES.decrypt(this.AES_txt, this.AES_key, {
                  mode: Reflect.get(this.modeMap, this.AES_mode)
                }))
              })

            Column() {
              Text('AES加密/解密结果：')
              TextArea({text: this.AES_res})
                .margin({top: 12})

            }
            .alignItems(HorizontalAlign.Start)

          }
          .padding(12)
          .height('100%')
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .tabBar(this.tabBuilder('AES', 2))

      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .barMode(BarMode.Fixed)
      .width('100%')
      .height('100%')

    }.title("加解密编码")
    .backgroundColor('#F1F3F5')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}




@Entry
@Component
struct TabsExample {
  @State currentIndex: number = 0
  @State animationDuration: number = 300
  @State indicatorLeftMargin: number = 0
  @State indicatorWidth: number = 0
  private tabsWidth: number = 0
  private textInfos: [number, number][] = []
  private isStartAnimateTo: boolean = false

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#182431')
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .id(index.toString())
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.textInfos[index] = [newValue.globalPosition.x as number, newValue.width as number]
        })
    }.width('100%')
  }

  build() {
    RelativeContainer() {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            Text('MD5')
          }
          .width('100%').height('100%')
        }.tabBar(this.tabBuilder(0, 'MD5'))

        TabContent() {
          Column() {
            Text('Base 64')
          }
          .width('100%').height('100%')
        }.tabBar(this.tabBuilder(1, 'Base 64'))

        TabContent() {
          Column() {
            Text('AES')
          }
          .width('100%').height('100%')
        }.tabBar(this.tabBuilder(2, 'AES'))

        TabContent() {
          Column() {
            Text('RSA')
          }
          .width('100%').height('100%')
        }.tabBar(this.tabBuilder(3, 'RSA'))

      }
      .onAreaChange((oldValue: Area, newValue: Area)=> {
        this.tabsWidth = newValue.width as number
        if (!this.isStartAnimateTo) {
          this.setIndicatorAttr(this.textInfos[this.currentIndex][0], this.textInfos[this.currentIndex][1])
        }
      })

      .barOverlap(true)
      .barWidth('100%')
      .barHeight(56)
      .width('100%')
      .height(296)
      .backgroundColor('red')
      .animationDuration(this.animationDuration)
      .onChange((index: number) => {
        this.currentIndex = index // 监听索引index的变化，实现页签内容的切换。
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        // 切换动画开始时触发该回调。下划线跟着页面一起滑动，同时宽度渐变。
        this.currentIndex = targetIndex
        this.startAnimateTo(this.animationDuration, this.textInfos[targetIndex][0], this.textInfos[targetIndex][1])
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
        // 切换动画结束时触发该回调。下划线动画停止。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.startAnimateTo(0, currentIndicatorInfo.left, currentIndicatorInfo.width)
      })
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        // 在页面跟手滑动过程中，逐帧触发该回调。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.currentIndex = currentIndicatorInfo.index
        this.setIndicatorAttr(currentIndicatorInfo.left, currentIndicatorInfo.width)
      })
      .zIndex(3)

      Column()
        .height(48)
        .width(this.indicatorWidth)
        .margin({ start: LengthMetrics.vp(this.indicatorLeftMargin), top: LengthMetrics.vp(48) })
        .backgroundColor('#000000')
        .offset({
          y:-48

        })
        .zIndex(2)
    }.width('100%')
  }

  private getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
    let nextIndex = index
    if (index > 0 && (CommonUtil.getIsRTL() ? event.currentOffset < 0 : event.currentOffset > 0)) {
      nextIndex--
    } else if (index < 3 && (CommonUtil.getIsRTL() ? event.currentOffset > 0 : event.currentOffset < 0)) {
      nextIndex++
    }
    let indexInfo = this.textInfos[index]
    let nextIndexInfo = this.textInfos[nextIndex]
    let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth)
    let currentIndex = swipeRatio > 0.5 ? nextIndex : index // 页面滑动超过一半，tabBar切换到下一页。
    let currentLeft = indexInfo[0] + (nextIndexInfo[0] - indexInfo[0]) * swipeRatio
    let currentWidth = indexInfo[1] + (nextIndexInfo[1] - indexInfo[1]) * swipeRatio
    return { 'index': currentIndex, 'left': currentLeft, 'width': currentWidth }
  }

  private startAnimateTo(duration: number, leftMargin: number, width: number) {
    this.isStartAnimateTo = true
    animateTo({
      duration: duration, // 动画时长
      curve: Curve.Linear, // 动画曲线
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        this.isStartAnimateTo = false
        console.info('play end')
      }
    }, () => {
      this.setIndicatorAttr(leftMargin, width)
    })
  }

  private setIndicatorAttr(leftMargin: number, width: number) {
    this.indicatorWidth = width
    if (CommonUtil.getIsRTL()) {
      this.indicatorLeftMargin = this.tabsWidth - leftMargin - width
    } else {
      this.indicatorLeftMargin = leftMargin
    }
  }
}
