class AddProjectIdToSnapshots < ActiveRecord::Migration[5.2]
  def change
    add_column :snapshots, :project_id, :integer
  end
end
