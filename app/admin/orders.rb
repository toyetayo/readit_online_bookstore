ActiveAdmin.register Order do
  permit_params :user_id, :receiver_name, :address, :city, :zip, :province_id, :shipping_type_id, :purchase_date,
                :status, order_items_attributes: %i[id product_id quantity price _destroy]

  index do
    selectable_column
    id_column
    column :user
    column :receiver_name
    column :address
    column :city
    column :zip
    column :province
    column :shipping_type
    column :purchase_date
    column :status
    column :total_price
    actions
  end

  filter :user
  filter :receiver_name
  filter :city
  filter :province, as: :select, collection: -> { Province.all.pluck(:name, :id) }
  filter :shipping_type, as: :select, collection: -> { ShippingType.all.pluck(:name, :id) }
  filter :purchase_date
  filter :status

  show do
    attributes_table do
      row :id
      row :user
      row :receiver_name
      row :address
      row :city
      row :zip
      row :province
      row :shipping_type
      row :purchase_date
      row :status
      row :total_price
      row :created_at
      row :updated_at
    end

    panel 'Order Items' do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
        column :total_price do |order_item|
          number_to_currency order_item.quantity * order_item.price
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Order Details' do
      f.input :user
      f.input :receiver_name
      f.input :address
      f.input :city
      f.input :zip
      f.input :province, as: :select, collection: Province.all.pluck(:name, :id)
      f.input :shipping_type, as: :select, collection: ShippingType.all.pluck(:name, :id)
      f.input :purchase_date, as: :datepicker
      f.input :status, as: :select, collection: %w[Pending Paid Shipped Delivered]
    end

    f.inputs 'Order Items' do
      f.has_many :order_items, allow_destroy: true do |oi|
        oi.input :product
        oi.input :quantity
        oi.input :price
      end
    end

    f.actions
  end

  member_action :mark_as_shipped, method: :put do
    resource.update(status: 'Shipped')
    redirect_to resource_path, notice: 'Order marked as shipped'
  end

  action_item :mark_as_shipped, only: :show do
    link_to 'Mark as Shipped', mark_as_shipped_admin_order_path(order), method: :put if order.status == 'Paid'
  end
end
