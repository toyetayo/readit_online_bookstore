class AddSlugToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :slug, :string
  end
end
