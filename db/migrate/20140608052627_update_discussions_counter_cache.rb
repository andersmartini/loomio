class UpdateDiscussionsCounterCache < ActiveRecord::Migration
  def up
  	Group.all.each do |group| 
  	  n = group.discussions.where(archived_at: nil, is_deleted: false).count
  	  Group.reset_counters 	group.id, :discussions
  	  Group.update_counters group.id, discussions_count: n
  	end
  end

  def down
  end

  private
end
