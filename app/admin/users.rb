ActiveAdmin.register User do
  actions :index, :show
  permit_params :email, :full_name, :gender
end
