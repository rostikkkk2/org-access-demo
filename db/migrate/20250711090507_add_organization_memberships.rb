class AddOrganizationMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :role, default: 'employee'
      t.string :status, default: 'pending'
      t.text :message
      t.timestamps
    end

    add_index :organization_memberships, [:user_id, :organization_id], unique: true
  end
end
