ActiveAdmin.register Contact do
  actions :all, except: %i[update create new edit]
end
