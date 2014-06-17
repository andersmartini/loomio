class DiscussionItems::MotionDescriptionEdited < DiscussionItem
  attr_reader :event, :motion

  def initialize(event, motion)
    @event, @motion = event, motion
  end

  def icon
    'proposal-icon'
  end

  def actor
    event.user
  end

  def group
    motion.group
  end

  def header
    I18n.t('discussion_items.motion_description_edited')
  end

  def body
    ""
  end

  def time
    event.created_at
  end
end
