ActiveAdmin.register Information do
  permit_params :section_title, :text

  controller do
    defaults finder: :find_by_section_title
  end
end
