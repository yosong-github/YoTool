import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';

import { componentSnapshot, promptAction } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';


/*
 * 获取图片
 * */
let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
// 设置筛选过滤条件，例如选择图片类型
PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
// 设置用户可以选择的图片数量
PhotoSelectOptions.maxSelectNumber = 1;
let photoPicker = new photoAccessHelper.PhotoViewPicker();


@Component
export default  struct QrCode {
  @Consume('pageInfos') pageInfos: NavPathStack;

  controller: TextInputController = new TextInputController();

  @State pixmap: image.PixelMap | null = null;
  @State context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;


  @State value: string = ''
  @State qrTxt: string = ''
  @State qrImg: string | null = null
  // 要保持的图片
  @State img: image.PixelMap | null = null;
  @State hideSaveBtn: boolean = false;


  // 组件截图
  clickToComponentSnapshot() {
    componentSnapshot.get('qrCode', (error: Error, pixmap: image.PixelMap) => {
      if (error) {
        console.log('error: ' + JSON.stringify(error));
        return;
      }
      console.log('截图成功');
      this.pixmap = pixmap;
      this.savePixmap2SysHelper()
    });
  }

  // 保存到系统相册
  async savePixmap2SysHelper() {
    if (!this.pixmap) {
      return;
    }
    const imgBuffer = await this.transferPixelMap2Buffer(this.pixmap);
    let helper = photoAccessHelper.getPhotoAccessHelper(this.context);
    const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
    const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    await fileIo.write(file.fd, imgBuffer);
    await fileIo.close(file.fd);

    promptAction.showToast({ message: '保存成功' });
  }

  // 将pixelMap转成图片格式
  transferPixelMap2Buffer(pixelMap: image.PixelMap): Promise<ArrayBuffer> {
    return new Promise((resolve, reject) => {
      let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
      const imagePackerApi = image.createImagePacker();
      imagePackerApi.packing(pixelMap, packOpts).then((buffer: ArrayBuffer) => {
        resolve(buffer);
      }).catch((err: BusinessError) => {
        reject();
      })
    });
  }

  build() {
    NavDestination() {
      Column({space: 16}) {
        TextInput({placeholder: '请输入要生成的二维码内容', text: this.value, controller: this.controller})
          .onChange((value: string) => {
            this.value = value
          })
          .onBlur(() => {
            console.log('失去焦点了')
            this.hideSaveBtn = false
          })
          .onFocus(() => {
            console.log('聚焦了')
            this.hideSaveBtn = true
          })

        Button('生成')
          .onClick(() => {
            if (this.value) {
              this.qrTxt = this.value
            }
            // 手动关闭键盘
            this.controller.stopEditing();
            // 显示保存按钮
            this.hideSaveBtn = true
          })
          .width('100%')
          .margin({
            bottom: 12
          })

        if (this.qrTxt) {
          Column({space: 16}) {
            // Row() {
            //   Button('背景色')
            //     .backgroundColor('#F1F3F5')
            //     .fontColor("#000")
            //   Blank()
            //   Button('前景色')
            //     .backgroundColor('#F1F3F5')
            //     .fontColor("#000")
            // }
            // .width('100%')
            Text('点击二维码中心，可自定义中心图片')

            Stack() {
              QRCode(this.qrTxt).width(240).height(240)

              if (this.qrImg) {
                Image(this.qrImg)
                  .width(40)
                  .height(40)
                  .borderRadius(20)
                  .onClick(() => {
                    // 选择图片
                    photoPicker.select(PhotoSelectOptions, (err: BusinessError, PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                      if (err) {
                        console.error("photoPicker.select error: " + JSON.stringify(err));
                        return;
                      }
                      // 用户选择确认后，会回调到这里，并返回用户选择的图片信息
                      console.info("photoPicker.select successfully: " + JSON.stringify(PhotoSelectResult), '获取到图片------------');
                      this.qrImg = PhotoSelectResult.photoUris[0]
                      // 可以根据PhotoSelectResult中的信息进一步处理用户选择的图片
                    });
                  })
              } else {
                Button({ type: ButtonType.Circle }){
                  Text('+')
                    .fontColor('#000')
                    .fontWeight(600)
                    .fontSize(20)
                }
                .backgroundColor('#fff')
                .width(40)
                .height(40)
                .onClick(() => {
                  // 选择图片
                  photoPicker.select(PhotoSelectOptions, (err: BusinessError, PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                    if (err) {
                      console.error("photoPicker.select error: " + JSON.stringify(err));
                      return;
                    }
                    // 用户选择确认后，会回调到这里，并返回用户选择的图片信息
                    console.info(JSON.stringify(PhotoSelectResult), 'asfasfasfasfasdfasf------------');
                    this.qrImg = PhotoSelectResult.photoUris[0]
                    // 可以根据PhotoSelectResult中的信息进一步处理用户选择的图片
                  });
                })
              }
            }
            .id('qrCode')

            if(!this.hideSaveBtn) {
              SaveButton({
                text: SaveDescription.SAVE_IMAGE,
                buttonType: ButtonType.Capsule
              })
                .width('100%')
                .onClick( async (event, result: SaveButtonOnClickResult) => {
                  if (result == SaveButtonOnClickResult.SUCCESS) {
                    this.clickToComponentSnapshot()
                  } else {
                    promptAction.showToast({ message: '暂无权限' });
                  }
                })
            }
          }
          .width('100%')
        }

      }
      .width('100%')
      .height('100%')
      .padding(12)
    }.title("二维码生成器")
    .backgroundColor('#F1F3F5')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}
