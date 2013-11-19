class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :url
      t.string :return_value

      t.timestamps
    end
  end
end
