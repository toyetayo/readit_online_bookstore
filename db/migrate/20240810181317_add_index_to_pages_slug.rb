class AddIndexToPagesSlug < ActiveRecord::Migration[7.1]
  def change
    add_index :pages, :slug, unique: true
  end
end
