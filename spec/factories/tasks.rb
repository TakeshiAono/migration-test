FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    deadline { Date.today }
    created_at { Date.today }
    #association :user ,factory::admin_user
  end
  factory :second_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル２' }
    content { 'Factoryで作ったデフォルトのコンテント２' }
    deadline { Date.today+1 }
    created_at { Date.today+1}
    
  end

end
