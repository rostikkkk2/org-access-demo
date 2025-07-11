class AddProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, default: 'active'
      t.references :organization, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.datetime :deadline
      
      t.timestamps
    end
    
    add_index :projects, :status
    add_index :projects, [:organization_id, :status]
  end
end
