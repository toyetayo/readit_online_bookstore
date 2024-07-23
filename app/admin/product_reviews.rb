ActiveAdmin.register ProductReview do
  permit_params :product_id, :user_id, :review, :rating, :review_date, :reviewer_name

  index do
    selectable_column
    id_column
    column :product
    column :user
    column :reviewer_name
    column :review
    column :rating
    column :review_date
    actions
  end

  filter :product
  filter :user
  filter :reviewer_name
  filter :rating
  filter :review_date

  form do |f|
    f.inputs do
      f.input :product
      f.input :user
      f.input :reviewer_name
      f.input :review
      f.input :rating, as: :select, collection: 1..5
      f.input :review_date, as: :datepicker
    end
    f.actions
  end
end
