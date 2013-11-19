class CreateBooleanSettings < ActiveRecord::Migration
  def change
    create_table :boolean_settings do |t|
      t.string :key
      t.boolean :value

      t.timestamps
    end
  end
end
