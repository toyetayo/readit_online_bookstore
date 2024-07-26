class MakeUserIdNullableInOrderItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :order_items, :user_id, true
  end
end
