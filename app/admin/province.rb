# app/admin/provinces.rb
ActiveAdmin.register Province do
  permit_params :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate

  index do
    selectable_column
    id_column
    column :name
    column :gst_rate
    column :pst_rate
    column :hst_rate
    column :qst_rate
    actions
  end

  filter :name
  filter :gst_rate
  filter :pst_rate
  filter :hst_rate
  filter :qst_rate

  form do |f|
    f.inputs do
      f.input :name
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
      f.input :qst_rate
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :qst_rate
      row :created_at
      row :updated_at
    end
  end
end
