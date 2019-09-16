require 'rails_helper'


RSpec.feature "タスク管理機能", type: :feature do
background do
  @user = FactoryBot.create(:user)
  @second_user = FactoryBot.create(:second_user)

   @task = FactoryBot.create(:task, user_id: @user.id)
   @second_task = FactoryBot.create(:second_task, user_id: @user.id)
   @third_task= FactoryBot.create(:third_task, user_id: @second_user.id)

   visit new_session_path

   #userでログイン
   fill_in "session[email]", with: "name1@email.com"
   fill_in "session[password]", with: "password1"

   click_button "ログインする"

   visit new_task_path
end

 scenario "タスク一覧のテスト" do
   visit tasks_path

   expect(page).to have_content "tasktask1"
   expect(page).to have_content "tasktask2"

 end

 scenario "タスク作成のテスト" do
   visit new_task_path

   fill_in "task[task_name]", with: "taskname1"
   fill_in "task[task_body]", with: "tasktask1"

   click_button "登録する"

   visit task_path(Task.first)

   expect(page).to have_content "taskname1"
   expect(page).to have_content "tasktask1"
   #save_and_open_page
 end

 scenario "タスク詳細のテスト" do
   visit task_path(Task.first)
   expect(page).to have_content "tasktask1"
 end
 
 scenario "タスク一覧が作成日時で降順に並んでいるかのテスト" do
   visit tasks_path

    def tasks
     expect(page).to have_content "tasktask1"
     expect(page).to have_content "tasktask2"
    end
     tasks{order(created_at: :desc)}
     #save_and_open_page
 end

  scenario "終了期限でソートするを押すと、タスクが終了期限の昇順でソートされるかのテスト" do
    visit tasks_path(sort_expired: "true")
    expect(Task.order(:task_limit).map(&:id))
#save_and_open_page
  end

  scenario "一覧画面の検索機能でタスク名を入力すると、入力した値を含む結果が表示されるかのテスト" do
    visit tasks_path

    fill_in "task[task_name]", with: "1"

    click_button "検索する"

    expect(page).to have_content "taskname1"
    #save_and_open_page
  end

  scenario "一覧画面の検索機能でステータス選択すると、選択したステータスに該当する結果が出るかのテスト" do
    visit tasks_path

    select "着手中",  from:"task_task_status"

    click_button "検索する"

    expect(page).to have_content "着手中"
    #save_and_open_page
  end

  scenario "一覧画面の検索機能でタスク名とステータス両方値が入っていた場合、両方成り立つ結果を表示するかのテスト" do
    visit tasks_path

    fill_in "task[task_name]", with: "1"
    select "未着手",  from:"task_task_status"

    click_button "検索する"

    expect(page).to have_content "taskname1"
    expect(page).to have_content "着手中"
    #save_and_open_page
  end

  scenario "優先度順にソートするを押すと、タスクが優先度が高い順にソートされるかのテスト" do
    visit tasks_path(sort_priority: "true")
    expect(Task.order(:task_priority).map(&:id))
     #save_and_open_page
  end

  scenario "自分が作成したタスクだけ表示するテスト" do
    #userでログイン中
    visit tasks_path

    expect(page).to have_content "tasktask1"
    expect(page).to have_content "tasktask2"

     #save_and_open_page
  end

   scenario "ログインしていない状態でタスク一覧のページに飛ぼうとするとログインページに変移するテスト" do

     click_link "ログアウト"

     visit tasks_path

     expect(page).to have_content "ログイン画面"
    #save_and_open_page
   end

   scenario "ログインしていない状態でタスク編集のページに飛ぼうとするとログインページに変移するテスト" do

     click_link "ログアウト"

     visit edit_task_path(@task.id)

     expect(page).to have_content "ログイン画面"
    #save_and_open_page
   end

   scenario "ログインしていない状態でタスク詳細ページに飛ぼうとするとログインページに変移するテスト" do

     click_link "ログアウト"

     visit task_path(@task.id)

     expect(page).to have_content "ログイン画面"
    #save_and_open_page
   end

   scenario "ログインしていない状態でタスクを削除しようとするとログインページに変移するテスト" do

     click_link "ログアウト"

     page.driver.submit :delete, "/tasks/#{@task.id}", {}

     expect(page).to have_content "ログイン画面"
    #save_and_open_page
   end
end
