ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  filter :title
  filter :slug
  filter :content
  filter :created_at

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :content
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :content, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        raw page.content
      end
      row :created_at
    end
    active_admin_comments
  end
end
