import { audio } from '@kit.AudioKit';
import { media } from '@kit.MediaKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

// let soundPool: media.SoundPool;
// let streamId: number = 0;
// let soundId: number = 0;
//
// // audioRenderInfo中的参数usage取值为STREAM_USAGE_UNKNOWN，STREAM_USAGE_MUSIC，STREAM_USAGE_MOVIE，
// // STREAM_USAGE_AUDIOBOOK时，SoundPool播放短音时为混音模式，不会打断其他音频播放。
// let audioRendererInfo: audio.AudioRendererInfo = {
//   usage: audio.StreamUsage.STREAM_USAGE_AUDIOBOOK,
//   rendererFlags: 1
// }
// let playParameters: media.PlayParameters = {
//   loop: 1, // 循环4次
//   rate: audio.AudioRendererRate.RENDER_RATE_NORMAL, // 正常倍速
//   leftVolume: 0.5, // range = 0.0-1.0
//   rightVolume: 0.5, // range = 0.0-1.0
//   priority: 0, // 最低优先级
// }
//
// let uri: string = "";
// async function create() {
//   //创建soundPool实例
//   soundPool = await media.createSoundPool(5, audioRendererInfo);
//   //注册监听
//   loadCallback();
//   finishPlayCallback();
//   setErrorCallback();
//
//
//   // 加载音频资源
//   let fsRes = await fs.open('../../common/mp3/fish.mp3', fs.OpenMode.READ_ONLY)
//     .then(async (file: fs.File) => {
//       uri = 'fd://' + (file.fd).toString()
//       console.info("file fd: " + file.fd);
//       soundId = await soundPool.load(uri);
//       console.log('播放')
//       PlaySoundPool()
//     })
//     .catch((err: BusinessError) => {
//       console.log(err + '');
//     })
//
//   // console.log(fsRes + '')
//
// }
//
// function loadCallback() {
//   // 加载完成回调
//   soundPool.on('loadComplete', (soundId_: number) => {
//     console.info('loadComplete, soundId: ' + soundId_);
//   })
// }
//
// //设置播放完成监听
// function finishPlayCallback() {
//   // 播放完成回调
//   soundPool.on('playFinished', () => {
//     console.info("receive play finished message");
//     // 可进行下次播放
//   })
// }
//
// //设置错误类型监听
// function setErrorCallback() {
//   soundPool.on('error', (error: BusinessError) => {
//     console.info('error happened,message is :' + error.message);
//   })
// }
//
// async function PlaySoundPool() {
//   // 开始播放，这边play也可带播放播放的参数PlayParameters，请在音频资源加载完毕，即收到loadComplete回调之后再执行play操作
//   soundPool.play(soundId, playParameters, (error, streamID: number) => {
//     if (error) {
//       console.info(`play sound Error: errCode is ${error.code}, errMessage is ${error.message}`)
//     } else {
//       streamId = streamID;
//       console.info('play success soundid:' + streamId);
//     }
//   });
//   // 设置循环播放次数
//   await soundPool.setLoop(streamId, 2); // 播放3次
//   // 设置对应流的优先级
//   await soundPool.setPriority(streamId, 1);
//   // 设置音量
//   await soundPool.setVolume(streamId, 0.5, 0.5);
// }
//
// async function release() {
//   // 终止指定流的播放
//   await soundPool.stop(streamId);
//   // 卸载音频资源
//   await soundPool.unload(soundId);
//   //关闭监听
//   setOffCallback();
//   // 释放SoundPool
//   await soundPool.release();
// }
//
// //关闭监听
// function setOffCallback() {
//   soundPool.off('loadComplete');
//   soundPool.off('playFinished');
//   soundPool.off('error');
// }
//




async function init() {
  const avPlayer = await media.createAVPlayer()

  avPlayer.on("stateChange", (state) => {
    switch (state) {
      case "initialized":
        avPlayer?.prepare()
        break;
      case "prepared":
        avPlayer?.play()
        break;
      case "completed":
        // 播放完毕，销毁实例
        avPlayer?.release()
        break;
      default:
        break;
    }
  })

  avPlayer.on("error", (err) => {
    console.log("err===============>", err)
  })
  // 设置URL
  const res = await getContext().resourceManager.getRawFd('fish.mp3')
  avPlayer!.fdSrc = res
}



PersistentStorage.persistProp('num', 0);
@Component
export default  struct WoodenFish {
  @Consume('pageInfos') pageInfos: NavPathStack;

  @StorageLink('num') num: number = 0

  @State widtNumber: number = 140;
  @State AddTextStatus: 0 | 1 = 0;

  // @State num: number = 0

  build() {
    NavDestination() {
      Column() {
        Text('+1')
          .fontSize(30)
          .fontWeight(600)
          .opacity(this.AddTextStatus)
          .margin({
            bottom: 10
          })
          .animation({
            duration: 300, // 动画持续时间（毫秒）
            curve: Curve.EaseInOut, // 缓动函数
          })

        Image('/common/images/WoodenFish.png') // 替换为你的图片资源路径
          .width(this.widtNumber)
            // 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
          .objectFit(ImageFit.Contain)
          .animation({
            duration: 100, // 动画持续时间（毫秒）
            curve: Curve.EaseInOut, // 缓动函数
          })
          .onTouch((event) => {

            if (event.type == TouchType.Down) {
              this.widtNumber = 120
              // create()
              this.AddTextStatus = 1
              init()
            } else if(event.type == TouchType.Up) {
              this.widtNumber = 140
              this.num ++

              setTimeout(() => {
                this.AddTextStatus = 0
              }, 300)
            }
          })
      }.width('100%').height('100%')
      .justifyContent(FlexAlign.Center)
    }.title("功德圆满 " + this.num)
    .backgroundColor('#F1F3F5')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}
