import { CounterComponent, CounterType } from '@kit.ArkUI'; // 导入计数器组件和计数器类型


PersistentStorage.persistProp('eatList', 0);

@Component
export default struct Eat {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Wheel()
      }
      .width('100%')
      .height('100%')
    }.title("吃货大转盘")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}


// 定义扇形组件
@Component
struct Sector {
  @Prop radius: number; // 扇形的半径
  @Prop angle: number; // 扇形的角度
  @Prop color: string; // 扇形的颜色

  // 创建扇形路径的函数
  createSectorPath(radius: number, angle: number): string {
    const centerX = radius / 2; // 计算扇形中心的X坐标
    const centerY = radius / 2; // 计算扇形中心的Y坐标
    const startX = centerX; // 扇形起始点的X坐标
    const startY = centerY - radius; // 扇形起始点的Y坐标
    const halfAngle = angle / 4; // 计算半个角度

    // 计算扇形结束点1的坐标
    const endX1 = centerX + radius * Math.cos((halfAngle * Math.PI) / 180);
    const endY1 = centerY - radius * Math.sin((halfAngle * Math.PI) / 180);

    // 计算扇形结束点2的坐标
    const endX2 = centerX + radius * Math.cos((-halfAngle * Math.PI) / 180);
    const endY2 = centerY - radius * Math.sin((-halfAngle * Math.PI) / 180);

    // 判断是否为大弧
    const largeArcFlag = angle / 2 > 180 ? 1 : 0;
    const sweepFlag = 1; // 设置弧线方向为顺时针

    // 生成SVG路径命令
    const pathCommands =
      `M${startX} ${startY} A${radius} ${radius} 0 ${largeArcFlag} ${sweepFlag} ${endX1} ${endY1} L${centerX} ${centerY} L${endX2} ${endY2} A${radius} ${radius} 0 ${largeArcFlag} ${1 -
        sweepFlag} ${startX} ${startY} Z`;
    return pathCommands; // 返回路径命令
  }

  // 构建扇形组件
  build() {
    Stack() {
      // 创建第一个扇形路径
      Path()
        .width(`${this.radius}px`) // 设置宽度为半径
        .height(`${this.radius}px`) // 设置高度为半径
        .commands(this.createSectorPath(this.radius, this.angle)) // 设置路径命令
        .fillOpacity(1) // 设置填充透明度
        .fill(this.color) // 设置填充颜色
        .strokeWidth(0) // 设置边框宽度为0
        .rotate({ angle: this.angle / 4 - 90 }); // 旋转扇形

      // 创建第二个扇形路径
      Path()
        .width(`${this.radius}px`) // 设置宽度为半径
        .height(`${this.radius}px`) // 设置高度为半径
        .commands(this.createSectorPath(this.radius, this.angle)) // 设置路径命令
        .fillOpacity(1) // 设置填充透明度
        .fill(this.color) // 设置填充颜色
        .strokeWidth(0) // 设置边框宽度为0
        .rotate({ angle: 180 - (this.angle / 4 - 90) }); // 旋转扇形
    }
  }
}

// 定义单元格类
@ObservedV2
class Cell {
  @Trace angle: number = 0; // 扇形的角度
  @Trace title: string; // 当前格子的标题
  @Trace color: string; // 背景颜色
  @Trace rotate: number = 0; // 在转盘要旋转的角度
  angleStart: number = 0; // 轮盘所在区间的起始
  angleEnd: number = 0; // 轮盘所在区间的结束
  proportion: number = 0; // 所占比例

  // 构造函数
  constructor(proportion: number, title: string, color: string) {
    this.proportion = proportion; // 设置比例
    this.title = title; // 设置标题
    this.color = color; // 设置颜色
  }
}

// 定义转盘组件
@Entry
@Component
struct Wheel {
  @State cells: Cell[] = []; // 存储单元格的数组
  @State wheelWidth: number = 600; // 转盘的宽度
  @State currentAngle: number = 0; // 当前转盘的角度
  @State selectedName: string = ""; // 选中的名称
  isAnimating: boolean = false; // 动画状态
  colorIndex: number = 0; // 颜色索引
  colorPalette: string[] = [ // 颜色调色板
    "#26c2ff",
    "#978efe",
    "#c389fe",
    "#ff85bd",
    "#ff7051",
    "#fea800",
    "#ffcf18",
    "#ff12ff5d",
    "#ff8818ff",
    "#96ff4a18",
    "#ff342c11",
    "#ff18ffdc",
    "#ff53993b",
    "#ff48096d",
    "#ffedf0f0",
    "#ffd5da71",
    "#ff42ff18",
    "#ff18ffd8",
    "#ffa1c627",
    "#ff161c6a",
    "#ae76d035"
  ];

  // 组件即将出现时调用
  aboutToAppear(): void {
    // 初始化单元格
    this.cells.push(new Cell(1, "泡面", this.colorPalette[0]));
    this.cells.push(new Cell(1, "火锅", this.colorPalette[1]));
    this.cells.push(new Cell(1, "鸡腿饭", this.colorPalette[2]));
    this.cells.push(new Cell(1, "猪脚饭", this.colorPalette[3]));
    this.cells.push(new Cell(1, "土豆烧鸡", this.colorPalette[4]));
    this.cells.push(new Cell(1, "蛋炒饭", this.colorPalette[5]));
    this.cells.push(new Cell(1, "鲍鱼", this.colorPalette[6]));
    this.cells.push(new Cell(1, "蛋卷", this.colorPalette[7]));
    this.cells.push(new Cell(1, "凉面", this.colorPalette[8]));
    this.cells.push(new Cell(1, "西湖醋鱼", this.colorPalette[9]));

    this.calculateAngles(); // 计算角度
  }

  // 计算每个单元格的角度
  private calculateAngles() {
    // 根据比例计算总比例
    const totalProportion = this.cells.reduce((sum, cell) => sum + cell.proportion, 0);
    this.cells.forEach(cell => {
      cell.angle = (cell.proportion * 360) / totalProportion; // 计算每个单元格的角度
    });

    let cumulativeAngle = 0; // 累计角度
    this.cells.forEach(cell => {
      cell.angleStart = cumulativeAngle; // 设置起始角度
      cumulativeAngle += cell.angle; // 更新累计角度
      cell.angleEnd = cumulativeAngle; // 设置结束角度
      cell.rotate = cumulativeAngle - (cell.angle / 2); // 计算旋转角度
    });
  }

  // 构建转盘组件
  build() {
    Column() {
      // 创建滚动区域
      Scroll() {
        Column() {

          Stack() {
            Stack() {
              // 遍历每个单元格并绘制扇形
              ForEach(this.cells, (cell: Cell) => {
                Stack() {
                  Sector({ radius: lpx2px(this.wheelWidth) / 2, angle: cell.angle, color: cell.color }); // 创建扇形
                  Text(cell.title).fontColor(Color.White).margin({ bottom: `${this.wheelWidth / 1.4}lpx` }); // 显示单元格标题
                }.width('100%').height('100%').rotate({ angle: cell.rotate }); // 设置宽度和高度，并旋转
              });
            }
            .borderRadius('50%') // 设置圆角
            .backgroundColor(Color.Gray) // 设置背景颜色
            .width(`${this.wheelWidth}lpx`) // 设置转盘宽度
            .height(`${this.wheelWidth}lpx`) // 设置转盘高度
            .rotate({ angle: this.currentAngle }); // 旋转转盘

            // 创建指针
            Polygon({ width: 20, height: 10 })
              .points([[0, 0], [10, -20], [20, 0]]) // 设置指针的点
              .fill("#d72b0b") // 设置指针颜色
              .height(20) // 设置指针高度
              .margin({ bottom: '140lpx' }); // 设置指针底部边距

            // 创建开始按钮
            Button('开始')
              .fontColor("#c53a2c") // 设置按钮字体颜色
              .borderWidth(10) // 设置按钮边框宽度
              .borderColor("#dd2218") // 设置按钮边框颜色
              .backgroundColor("#fde427") // 设置按钮背景颜色
              .width('200lpx') // 设置按钮宽度
              .height('200lpx') // 设置按钮高度
              .borderRadius('50%') // 设置按钮为圆形
              .clickEffect({ level: ClickEffectLevel.LIGHT }) // 设置点击效果
              .onClick(() => { // 点击按钮时的回调函数
                if (this.isAnimating) { // 如果正在动画中，返回
                  return;
                }
                this.selectedName = ""; // 清空选中的名称
                this.isAnimating = true; // 设置动画状态为正在动画
                animateTo({ // 开始动画
                  duration: 5000, // 动画持续时间为5000毫秒
                  curve: Curve.EaseInOut, // 动画曲线为缓入缓出
                  onFinish: () => { // 动画完成后的回调
                    this.currentAngle %= 360; // 保持当前角度在0到360之间
                    for (const cell of this.cells) { // 遍历每个单元格
                      // 检查当前角度是否在单元格的角度范围内
                      if (360 - this.currentAngle >= cell.angleStart && 360 - this.currentAngle <= cell.angleEnd) {
                        this.selectedName = cell.title; // 设置选中的名称为当前单元格的标题
                        break; // 找到后退出循环
                      }
                    }
                    this.isAnimating = false; // 设置动画状态为未动画
                  },
                }, () => { // 动画进行中的回调
                  this.currentAngle += (360 * 5 + Math.floor(Math.random() * 360)); // 更新当前角度，增加随机旋转
                });
              });
          }
          .margin({
            bottom: 20
          })

          // 遍历每个单元格，创建输入框和计数器
          ForEach(this.cells, (item: Cell, index: number) => {
            Row() {
              // 创建文本输入框，显示单元格标题
              TextInput({ text: item.title })
                .layoutWeight(1) // 设置输入框占据剩余空间
                .onChange((value) => { // 输入框内容变化时的回调
                  item.title = value; // 更新单元格标题
                })
                .margin({
                  right: 10
                })
              // 创建删除按钮
              Button('删除').onClick(() => {
                this.cells.splice(index, 1); // 从单元格数组中删除当前单元格
                this.calculateAngles(); // 重新计算角度
              });
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween) // 设置行的宽度和内容对齐方式
            .margin({
              bottom: 10
            })
          });
        }.layoutWeight(1) // 设置滚动区域占据剩余空间
        .padding({
          left: 10,
          right: 10
        })
      }
      .layoutWeight(1) // 设置滚动区域占据剩余空间
      .margin({ bottom: 20 }) // 设置上下外边距
      .align(Alignment.Top); // 设置对齐方式为顶部对齐

      if (this.cells.length < 10) {
        // 创建添加新内容按钮
        Button('添加新内容').onClick(() => {
          // 向单元格数组中添加新单元格
          this.cells.push(new Cell(1, "新内容", this.colorPalette[this.colorIndex++ % this.colorPalette.length]));
          this.calculateAngles(); // 重新计算角度
        })
      }
    }
    .height('100%') // 设置组件高度为100%
    .width('100%') // 设置组件宽度为100%
  }
}
