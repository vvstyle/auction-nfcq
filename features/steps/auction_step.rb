#encoding: utf-8

require 'capybara/cucumber'
require 'capybara-screenshot'
require 'selenium-webdriver'

Capybara.default_driver = :selenium

def login_bjr username, password, org
  return login '报价人', username, password, org
end
def login_zcr username, password, org
  return login '主持人', username, password, org
end

def login_admin
  return login '主持人', @admin_account[:account], @admin_account[:password], @admin_account[:org]
end

def login type, username, password, org
  session = Capybara::Session.new(:selenium)

  #session.visit 'http://192.168.10.201:8080/ras/'
  session.visit 'http://192.168.10.16:8018/ras/'
  session.click_link type
  session.fill_in 'j_username', with: username
  session.fill_in 'j_password', with: password
  session.fill_in 'j_org', with: org
  session.find("#login-bt").click

  return session
end

假如(/^有一个可管理项目的如下帐号$/) do |table|
  t = table.raw
  @admin_account = {
    account: t[1][0],
    user_name: t[1][1],
    password: t[1][2],
    org: t[1][3]
  }
end

当(/^使用管理帐号登录到系统$/) do
  @admin = login_admin
  class << @admin
    alias origin_fill_in fill_in
    def fill_in id, option
      origin_fill_in id, option
      execute_script "$('\##{id}').focusout()"
    end


  end
end

那么(/^应当看到已登录的界面标识$/) do
  @admin.should have_content('本机构报价项目')
end

当(/^管理员选择左侧"(.*?)"菜单$/) do |menu|
  @admin.click_link menu
  @admin.within_frame '首页' do
    @admin.should have_content '欢迎使用广东省产权交易竞价平台'
  end
end

当(/^管理员选择右侧"(.*?)"，即"(.*?)"菜单$/) do |menu1, menu2|
  @admin.within_frame '首页' do
    @admin.find("#新增一次报价").click
  end
  @admin.within_frame '新增一次报价' do
    @admin.should have_content '报价项目信息(一次报价)'
  end
end

当(/^输入基本项目信息$/) do |table|
  data = table.raw[1]
  @admin.within_frame '新增一次报价' do
    @new_project_sid = "YC#{Time.now.to_i}"
    @admin.fill_in 'projectSid', with: @new_project_sid
    @admin.fill_in 'projectName', with: data[1]
    @admin.find('#projectTypeCode').select data[2]
  end
end

当(/^选择报价项目主持人为自己的名称$/) do
  @admin.within_frame '新增一次报价' do
    @admin.find('#hostUuid').select @admin_account[:user_name]
  end
end

当(/^按照下面要求设置项目货币单位$/) do |table|
  data = table.raw[1]
  @admin.within_frame '新增一次报价' do
    @admin.fill_in 'basePrice', with: data[3]
  end
end

当(/^按照下面要求设置项目保证金$/) do |table|
  data = table.raw[1]
  @admin.within_frame '新增一次报价' do
    case data[0]
    when '是'
      @admin.choose 'setCaution_1'
      case data[1]
      when '保证金金额(万元人民币):'
        @admin.find(:xpath, '//*[@id="ycbj"]/table[6]/tbody/tr[2]/td/table/tbody/tr[2]/td[2]/input[3]')
              .click
        @admin.fill_in 'cautionAmount', with: data[2]
      end
    end
  end
end

当(/^设置为报价过程中允许增加报价人$/) do
  @admin.within_frame '新增一次报价' do
    @admin.choose 'allowAddQuoter_1'
  end
end

当(/^设置定时报价开始时间为：当前系统时间延后(\d+)小时，结束时间为延后(\d+)小时$/) do |start_later, end_later|
  @admin.within_frame '新增一次报价' do
    t1 = Time.now + start_later.to_i * 60 * 60
    t2 = Time.now + end_later.to_i * 60 * 60
    @admin.fill_in 'timingStartTime', with: t1.strftime("%Y-%m-%d %H:%M:%S")
    @admin.fill_in 'timingEndTime', with: t2.strftime("%Y-%m-%d %H:%M:%S")
  end
end

当(/^点击"(.*?)"按钮，提交项目$/) do |arg1|
  @admin.within_frame '新增一次报价' do
    @admin.click_link 'btnSave'
    a = @admin.driver.browser.switch_to.alert
    $stdin.gets
    a.accept  #处理modal对话框

  end  
end

那么(/^应该成功建立项目$/) do
  @admin.click_link '未开始项目'
  @admin.within_frame '未开始项目' do
    $stdin.gets
    @admin.should have_content @new_project_sid
  end  
end


假如(/^使用如下帐户登录到查看人$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had

  竞价现场 do
    主持人登录
    报价人1登录
    报价人2登录
    主持人开始
    报价人1加价1倍
    报价人2加价1倍
    报价人1加价1倍
  end
end
