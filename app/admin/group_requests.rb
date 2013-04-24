ActiveAdmin.register GroupRequest do
  scope :unverified
  scope :verified, :default => true
  scope :approved
  scope :manually_approved
  scope :accepted
  scope :defered
  scope :marked_as_spam
  scope :all

  index do
    column :id
    column :name
    column :description
    column "Contribute?", :sortable => :cannot_contribute do |group_request|
      !group_request.cannot_contribute
    end
    column :expected_size
    column :max_size
    column :admin_email
    column :approved_at, sortable: :approved_at
    column(:approved_by) {|gr| }
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :name
      row :admin_email
      row :description
      row :expected_size
      row :status if group_request.unverified? or group_request.verified?
      if group_request.unverified?
        row ('Resend Verification Link') { link_to "resend",
            resend_verification_admin_group_request_path(group_request.id)}
      end
      row ('Touch level') do
        if group_request.high_touch?
          link_to "Low Touch (click to change)", low_touch_admin_group_request_path(group_request.id),
            :method => :put
        else
          link_to "High Touch (click to change)", high_touch_admin_group_request_path(group_request.id),
            :method => :put
        end
      end
      if group_request.verified? and not group_request.approved?
        row ('Approve request') { link_to "approve",
          approve_and_send_form_admin_group_request_path(group_request.id),
          id: "approve_group_request_#{group_request.id}" }
        row ('Defer request until a later date') {
          link_to "defer", defer_and_send_form_admin_group_request_path(group_request.id) }
      end
      if group_request.approved? or group_request.manually_approved?
        row :approved_at
        row ('Action') { link_to "resend invitation to start group",
            resend_invitation_to_start_group_admin_group_request_path(group_request.id) }
      end
      if group_request.defered?
        row :defered_until
        row ('Action') { link_to "approve", approve_and_send_form_admin_group_request_path(group_request.id) }
      end
      if group_request.marked_as_spam?
        row ('Mark as unverified') { link_to "reset", mark_as_unverified_admin_group_request_path(group_request.id),
            :method => :put }
      end
    end
    active_admin_comments
  end

  member_action :approve_and_send_form, :method => :get do
    @group_request = GroupRequest.find(params[:id])
  end

  member_action :approve_and_send, :method => :put do
    @group_request = GroupRequest.find(params[:id])
    setup_group = SetupGroup.new(@group_request)
    group = setup_group.approve_group_request(current_user)
    setup_group.send_invitation_to_start_group(params[:message_body])
    redirect_to admin_group_requests_path,
      :notice => ("Group approved: " +
      "<a href='#{admin_group_path(group)}'>#{group.name}</a>").html_safe
  end

  member_action :defer_and_send_form, :method => :get do
    @group_request = GroupRequest.find(params[:id])
  end

  member_action :defer_and_save, :method => :put do
    @group_request = GroupRequest.find(params[:id])
    @group_request.defered_until = params[:defered_until]
    @group_request.defer!
    redirect_to admin_group_requests_path, :notice => "Group request defered."
  end

  member_action :mark_as_manually_approved, :method => :put do
    group_request = GroupRequest.find(params[:id])
    group_request.mark_as_manually_approved!
    redirect_to admin_group_requests_path,
      :notice => "Group marked as 'already approved': " +
      group_request.name
  end

  member_action :mark_as_spam, :method => :put do
    group_request = GroupRequest.find(params[:id])
    group_request.mark_as_spam!
    redirect_to admin_group_requests_path,
      :notice => "Group marked as 'spam': " +
      group_request.name
  end

  member_action :mark_as_unverified, :method => :put do
    group_request = GroupRequest.find(params[:id])
    group_request.mark_as_unverified!
    redirect_to admin_group_requests_path,
      :notice => "Group marked as 'unverified': " +
      group_request.name
  end

  member_action :resend_verification, :method => :get do
    group_request = GroupRequest.find(params[:id])
    group_request.send_verification
    redirect_to admin_group_requests_path,
      :notice => "Verification email sent for " +
      group_request.name
  end

  member_action :resend_invitation_to_start_group, :method => :get do
    group_request = GroupRequest.find(params[:id])
    group_request.send_invitation_to_start_group
    redirect_to admin_group_requests_path,
      :notice => "Invitation to start group email sent for " +
      group_request.name
  end

  member_action :low_touch, :method => :put do
    group_request = GroupRequest.find(params[:id])
    group_request.set_high_touch!(false)
    redirect_to admin_group_requests_path,
      :notice => group_request.name + " set to low touch"
  end

  member_action :high_touch, :method => :put do
    group_request = GroupRequest.find(params[:id])
    group_request.set_high_touch!(true)
    redirect_to admin_group_requests_path,
      :notice => group_request.name + " set to high touch"
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :admin_email
      f.input :expected_size
      f.input :max_size
      f.input :description
    end
    f.buttons
  end
end
