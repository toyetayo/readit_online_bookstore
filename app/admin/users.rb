ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :address, :city, :phone_number, :province_id, :zip

  filter :first_name
  filter :last_name
  filter :email
  filter :address
  filter :city
  filter :phone_number
  filter :province_id
  filter :zip
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :address
    column :city
    column :phone_number
    column :province_id
    column :zip
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :address
      row :city
      row :phone_number
      row :province_id
      row :zip
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :address
      f.input :city
      f.input :zip
      f.input :province_id, as: :select,
                            collection: %w[AB BC MB NB NL NS NT NU ON PE QC SK YT], include_blank: false
      f.input :phone_number
    end
    f.actions
  end
end
