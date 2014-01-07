class AddEmploymentAndGraduationToUser < ActiveRecord::Migration
  def change
  	add_column :users, :has_graduated, :boolean
  	add_column :users, :has_full_time_employment, :boolean
  end
end
