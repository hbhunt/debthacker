class AddInstitutionTypeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :institution_type, :text
  end
end
