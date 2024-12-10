import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass, defaultAd, UserSettingClass } from 'basic';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {

    // 测试是否有加入到首选项中
    // const userSetting = new UserSettingClass(this.context)
    // userSetting.setAdvert({adTime:3,showAd:true})

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 1.查询配置，是否要显示广告
    // 模拟发请求，查询广告配置
    const ad = await new Promise<AdvertClass>((resolve) => {
      setTimeout(() => {
        resolve(defaultAd)
      }, 500)
    })

    //存到用户的持久化存储中
    const userSetting = new UserSettingClass(this.context)
    userSetting.setAdvert(defaultAd)

    // 如果要显示广告- 不能直接显示首页
    if (ad.showAd) {
      // 如何创建一个子页面，显示子页面 和 销毁子页面
      // 创建子页面
      const win = await windowStage.createSubWindow('ad_window')
      await win.showWindow() // 打开子页面
      //   参数传入子页面的路径
      win.setUIContent('pages/Start/Start') // 显示在子窗口上的页面
    }

    windowStage.loadContent('pages/Index ')
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
