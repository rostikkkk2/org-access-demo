class AddOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :description
      
      t.timestamps
    end
  end
end
