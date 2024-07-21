ActiveAdmin.register Page do
  permit_params :title, :content

  index do
    selectable_column
    id_column
    column :title
    column :content
    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title
      f.input :content
    end
    f.actions
  end
end
