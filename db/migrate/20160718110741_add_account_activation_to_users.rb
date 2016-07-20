class AddAccountActivationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active_digest, :string
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime, default: Time.zone.now
  end
end
