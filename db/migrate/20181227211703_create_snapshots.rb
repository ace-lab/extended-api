class CreateSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :snapshots do |t|
      t.string :origin
      t.string :data_name
      t.string :query
      t.text :content
      t.text :headers
      t.timestamp :taken_at

      t.timestamps
    end
  end
end
