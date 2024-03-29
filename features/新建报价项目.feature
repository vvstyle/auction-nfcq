#language: zh-CN

功能: 报价项目建立
  作为主持人或管理员
  新建一次、多次、限次、反向、双向、开放等报价项目

  背景: 主持人或管理员登录
    假如有一个可管理项目的如下帐号
      |帐号 |帐号名称|密码 |机构  |
      |zcr1|主持人1 |123 |TESTORG|
    当使用管理帐号登录到系统
    那么应当看到已登录的界面标识

  @wip @javascript
  场景: 1、建立一次报价项目

    当管理员选择左侧"新增报价项目"菜单
    而且管理员选择右侧"新增一次报价"，即"投标式报价模式"菜单

    而且输入基本项目信息
      |  项目编号   |   项目名称    |  项目类型  |
      |YC{当前时间戳}|新建一次报价测试|  产股权    |

    而且选择报价项目主持人为自己的名称

    而且按照下面要求设置项目货币单位
      |报价货币是否为人民币|报价货币单位是否为万元|报价货币单位与"人民币"的汇率值|报价项目底价|
      |是               |万元               |10000                    |200       |

    而且按照下面要求设置项目保证金
      |是否设置保证金|保证金设置类型设置     |保证金金额|
      |是          |保证金金额(万元人民币):|200     |

    而且设置为报价过程中允许增加报价人

    而且设置定时报价开始时间为：当前系统时间延后1小时，结束时间为延后2小时

    而且点击"保存"按钮，提交项目

    那么应该成功建立项目
