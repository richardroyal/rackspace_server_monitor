class CreateServersUsers < ActiveRecord::Migration
  def change
    create_table :servers_users, :id => false do |t|
      t.integer :server_id
      t.integer :user_id
    end
  end
end
