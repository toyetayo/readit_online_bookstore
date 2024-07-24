# app/admin/categories.rb
ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  # Custom action to fetch categories as JSON
  collection_action :fetch, method: :get do
    categories = Category.all
    render json: categories
  end
end
