class ChangeGroupPrivacyDefault < ActiveRecord::Migration
  def up
    change_column_default(:groups, :privacy, 'public')
  end

  def down
    change_column_default(:groups, :privacy, 'private')
  end
end
