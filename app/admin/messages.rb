ActiveAdmin.register Conversation
ActiveAdmin.register Message do
  belongs_to :conversation
  actions :show, :index
  permit_params :text, :user, :created_at, :id
end
