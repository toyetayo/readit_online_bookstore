ActiveAdmin.register Order do
  permit_params :user_id, :receiver_name, :address, :city, :zip, :province_id, :shipping_type_id, :purchase_date,
                :status

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
    actions
  end

  filter :user
  filter :receiver_name
  filter :city
  filter :province, as: :select, collection: -> { Province.all.pluck(:name, :id) }
  filter :shipping_type, as: :select, collection: -> { ShippingType.all.pluck(:name, :id) }
  filter :purchase_date
  filter :status

  form do |f|
    f.inputs do
      f.input :user
      f.input :receiver_name
      f.input :address
      f.input :city
      f.input :zip
      f.input :province, as: :select, collection: Province.all.pluck(:name, :id)
      f.input :shipping_type, as: :select, collection: ShippingType.all.pluck(:name, :id)
      f.input :purchase_date, as: :datepicker
      f.input :status, as: :select, collection: %w[Pending Shipped Delivered]
    end
    f.actions
  end
end
