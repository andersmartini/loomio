class AddEmotionToComments < ActiveRecord::Migration
  def up
    add_column :comments, :emotion, :string, default: 'neutral', null: false
    change_column :comments, :emotion, :string, default: 'neutral', null: false
  end

  def down
    remove_column :comments, :emotion
  end
end
