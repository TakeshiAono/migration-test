class Aono < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :name, :text
  end

  def down
    change_column :users, :name, :string
  end
end
