ActiveAdmin.register Target do
  actions :index, :show
  permit_params :topic_id, :user_id, :title, :radius, :latitude, :longitude
end
