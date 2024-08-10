ActiveAdmin.register Product do
  permit_params :name, :author, :description, :number_in_stock, :price, :category_id, :image

  # Index page configuration
  index do
    selectable_column
    id_column
    column :name
    column :author
    column :description
    column :number_in_stock
    column :price
    column :category
    column :created_at
    column :updated_at
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: '50x50'
      else
        'No Image'
      end
    end
    actions
  end

  # Filters for the index page
  filter :name
  filter :author
  filter :description
  filter :price
  filter :number_in_stock
  filter :category

  # Form for creating/editing a product
  form html: { multipart: true } do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :author
      f.input :description
      f.input :number_in_stock
      f.input :price
      f.input :category, as: :select, collection: Category.all.map { |c| [c.name, c.id] }, include_blank: false
      f.input :image, as: :file,
                      hint: f.object.image.attached? ? image_tag(f.object.image.variant(resize_to_limit: [100, 100])) : content_tag(:span, 'No image uploaded yet')
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :name
      row :author
      row :description
      row :number_in_stock
      row :price
      row :category
      row :created_at
      row :updated_at
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image)
        else
          'No Image'
        end
      end
    end
    active_admin_comments
  end

  # Scope the collection of products
  controller do
    def scoped_collection
      Product.all
    end
  end

  # Pagination configuration
  config.per_page = 100
end
