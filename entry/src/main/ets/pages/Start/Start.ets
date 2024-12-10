import { AdvertClass, UserSettingClass } from 'basic'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass = {
    showAd: false,
    adTime: 0
  }
  timer: number = -1

  // 定义关闭窗口函数
  closeWin() { // 调用销毁的声明周期关闭页面
    window.findWindow('ad_window').destroyWindow()
  }

  async aboutToAppear() {
    this.adObj = await this.userSetting.getAdvert()
    this.timer = setInterval(() => {
      if (this.adObj.adTime === 0) {
        this.closeWin()
        clearInterval(this.timer)
        return
      }
      this.adObj.adTime--
    }, 1000)
  }

  // 页面销毁后关闭定时器   防止点击跳过定时器还未释放
  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          // 点击跳过时关闭页面
          this.closeWin()
        })

    }.height('100%').width('100%')
  }
}
