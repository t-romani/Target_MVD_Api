ActiveAdmin.register Conversation do
  actions :show, :index

  show do |conversation|
    attributes_table do
      row :id

      attributes_table_for conversation.users do
        row :id
        row :full_name
        row :email
      end
    end

    status_tag 'Messages'
    messages = conversation.messages
    paginated_collection(messages.page(params[:page]).per(10),
                         download_links: false) do
      table_for(messages) do
        column 'ID', :id
        column 'User', :user
        column 'Text', :text
        column 'Created at', :created_at
      end
    end
  end
end
