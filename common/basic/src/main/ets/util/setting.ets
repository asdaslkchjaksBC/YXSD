// 用户配置： 广告信息 token 用户信息之类的
import { Context } from "@kit.AbilityKit";
import { preferences } from "@kit.ArkData";
import { AdvertClass } from "../models";

// 定义默认广告配置类
export const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
}

export class UserSettingClass{

  // 获取用户的广告持久化仓库
  context: Context

  // 初始化必须传递Context
  constructor(ctx: Context) {
    this.context = ctx
  }

  // 定义获取持久化仓库对象的函数
  getStore(){
    // 因为Context分为UIAbility的Context和组件的Context，
    // 所以直接get可能会获错，使用上面初始化传递的
    // 传递两个参数，Context和仓库的名字
    return preferences.getPreferencesSync(this.context,{name:'advert'})
  }

  //保存广告配置到持久化存储中
  setAdvert(ad: AdvertClass){
    // 先获取到当前的持久化对象
    const store = this.getStore()
    // 持久化能存储的内容只有string number boolean 所以要使用JSON来转换为字符串
    store.putSync('advert',JSON.stringify(ad)) //将传递进来的广告对象存储到内存中
    store.flush()  //存储到硬盘中
  }

  // 获取持久化配置的广告信息
  getAdvert(): AdvertClass{
    const store = this.getStore() // 获取持久化对象
    // 获取advert对应的持久化信息  要两个参数，key和未获取到的默认值
    const str = store.getSync('advert',JSON.stringify(defaultAd)) as string
    // 把获取到的数据转成AdvertClass对象返回
    return JSON.parse(str)
  }

}