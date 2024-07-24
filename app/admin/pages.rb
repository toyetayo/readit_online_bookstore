# app/admin/pages.rb

ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :ckeditor
      f.input :slug
    end
    f.actions
  end
end
