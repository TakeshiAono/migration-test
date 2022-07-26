require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let(:user_a) {FactoryBot.create(:user, name: 'ユーザーa', email: 'a@gmail.com')}
  let(:user_b) {FactoryBot.create(:user, name: 'ユーザーB', email: 'b@gmail.com')}
  let!(:user_a) {FactoryBot.create(:task, title: 'first_task', deadline: Date.today, user_a)}
  let!(:user_a) {FactoryBot.create(:task, title: 'second_task', deadline: Date.today+1, user_a)}
  before do
    visit_login_path
    fill_in 'メールアドレス', with: 'a@gmail.com'
    fill_in 'パスワード', with: '123456'
    click_on 'ログインする'
  end
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "タスク表示"
        fill_in "task[content]", with: "テストします"
        fill_in "task[deadline]", with: Date.today
        select "着手中", from: "task_status"
        click_on "Create タスク"
        expect(page).to have_content "タスク表示"
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'first_task'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        task_list = all('.task_row')[0]
        expect(page.text).to match 'first_task'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合'
      it '終了期限が近いタスクが一番上に表示される' do
        visit tasks_path
        task_list = all('.task_row')[0]
        expect(page.text).to match 'second_task'
      end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
        @task = FactoryBot.create(:task, title: 'first', user_a)
        visit task_path(@task.id)
        expect(page).to have_content 'first'
       end
     end
  end

  describe '検索機能' do
    before do
      FactoryBot.create(:task, title: "task", status: "done", user_a)
      FactoryBot.create(:second_task, title: "sample", status: "not_yet", user_a)
    end

    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path
        fill_in "search_title_search", with: "task"
        click_on "検索"
        expect(page).to have_content 'task'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        visit tasks_path
        select "完了", from: "search_status_search"
        click_on '検索'
        expect(page).to have_content '完了'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        visit tasks_path
        fill_in "search_title_search", with: "sample"
        select "未着手", from: "search_status_search"
        click_on '検索'
        expect(page).to have_content "sample"
      end
    end
  end
  describe '一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移すること' do
    content 'ユーザーBがログインしているとき' do
      before do
        user_b = FactoryBot.create{:user 'ユーザーB', email: 'b@gmail.com'}
        visit_login_path
        fill_in 'メールアドレス', with: 'b@gmail.com'
        fill_in 'パスワード', with: '123456'
        click_on 'ログインする'
      end
      it 'ユーザーa のタスクに飛ぶとユーザーBのタスク一覧画面に遷移する' do
      visit_tasks_path
      expect(page).to have_no_content 'first_task'

      end
    end
  end
end
