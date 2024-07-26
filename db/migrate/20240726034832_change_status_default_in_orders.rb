class ChangeStatusDefaultInOrders < ActiveRecord::Migration[7.1]
  def up
    change_column_default :orders, :status, 'pending'

    # Update existing records
    Order.where(status: nil).update_all(status: 'pending')
    Order.where.not(status: %w[pending paid shipped]).update_all(status: 'pending')
  end

  def down
    change_column_default :orders, :status, nil
  end
end
