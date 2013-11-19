class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :state
      t.references :server

      t.timestamps
    end
    add_index :checks, :server_id
  end
end
