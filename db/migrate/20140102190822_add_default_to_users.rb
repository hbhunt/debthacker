class AddDefaultToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :has_defaulted, :boolean
  end
end
