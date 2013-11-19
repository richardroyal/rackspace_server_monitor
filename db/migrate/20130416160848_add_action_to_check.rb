class AddActionToCheck < ActiveRecord::Migration
  def change
    add_column :checks, :action, :string
  end
end
