class UpdateCounterCaches < ActiveRecord::Migration
  def up
    Group.update_all motions_count: 0, discussions_count: 0
  	Group.all.each do |group| 
  	  discussions = group.discussions.where(archived_at: nil, is_deleted: false)
      motions = discussions.map(&:motions).flatten
  	  Group.update_counters group.id, discussions_count: discussions.count
      Group.update_counters group.id, motions_count: motions.count
  	end
  end

  def down
  end
end
