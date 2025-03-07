class CreateOfficers < ActiveRecord::Migration[7.0]
  def change
    create_table :officers do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :officers
  end
end
