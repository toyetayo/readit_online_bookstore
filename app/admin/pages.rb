ActiveAdmin.register Page do
  permit_params :title, :content

  index do
    selectable_column
    id_column
    column :title
    column :content do |page|
      raw truncate(page.content, length: 100)
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :quill_editor
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content do |page|
        raw page.content
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
