# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Quick Links panel
    columns do
      column do
        panel 'Quick Links' do
          ul do
            li link_to('Products', admin_products_path)
            li link_to('Categories', admin_categories_path)
            li link_to('Orders', admin_orders_path)
            li link_to('Product Reviews', admin_product_reviews_path)
            li link_to('Admin Users', admin_admin_users_path)
            li link_to('Users', admin_users_path)
          end
        end
      end
    end

    # Statistics panel
    columns do
      column do
        panel 'Statistics' do
          ul do
            li "Total Admin Users: #{AdminUser.count}"
            li "Total Products: #{Product.count}"
            li "Total Categories: #{Category.count}"
            li "Total Reviews: #{ProductReview.count}"
            li "Total Orders: #{Order.count}"
            li "Total Delivered Orders: #{Order.where(status: 'delivered').count}"
            li "Total Pending Orders: #{Order.where(status: 'pending').count}"
            li "Total Registered Customers: #{User.count}"
          end
        end
      end
    end

    # Recent Orders panel
    columns do
      column do
        panel 'Recent Orders' do
          table_for Order.order('created_at desc').limit(5) do
            column('ID') { |order| link_to order.id, admin_order_path(order) }
            column('Customer') do |order|
              order.user ? link_to(order.user.email, admin_user_path(order.user)) : 'No Customer'
            end
            column('Status') { |order| status_tag(order.status) }
            column('Total') { |order| number_to_currency order.total_price }
          end
        end
      end

      # Recent Reviews panel
      column do
        panel 'Recent Reviews' do
          table_for ProductReview.order('created_at desc').limit(5) do
            column('ID') { |review| link_to review.id, admin_product_review_path(review) }
            column('Product') { |review| link_to review.product.name, admin_product_path(review.product) }
            column('Rating') { |review| review.rating }
            column('Review') { |review| truncate(review.review, length: 50) }
          end
        end
      end
    end

    # Recent Customers panel
    columns do
      column do
        panel 'Recent Customers' do
          table_for User.order('created_at desc').limit(5) do
            column('ID') { |user| link_to user.id, admin_user_path(user) }
            column('Email') { |user| user.email }
            column('Full Name') { |user| "#{user.first_name} #{user.last_name}" }
          end
        end
      end
    end
  end
end
