class AddRackspaceIdtoServer < ActiveRecord::Migration
  def up
    add_column :servers, :rackspace_id, :string
  end

  def down
    remove_column :servers, :rackspace_id
  end
end
