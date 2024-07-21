ActiveAdmin.register Product do
  permit_params :name, :author, :number_in_stock, :price, :description, :user_id, :image, category_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :author
    column :number_in_stock
    column :price
    column :description
    column :user
    column 'Image' do |product|
      image_tag url_for(product.image), size: '100x100' if product.image.attached?
    end
    actions
  end

  filter :name
  filter :author
  filter :number_in_stock
  filter :price

  form do |f|
    f.inputs do
      f.input :name
      f.input :author
      f.input :number_in_stock
      f.input :price
      f.input :description
      f.input :user
      f.input :image, as: :file
      f.input :categories, as: :check_boxes
    end
    f.actions
  end
end
