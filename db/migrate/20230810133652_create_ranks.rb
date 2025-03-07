class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :ranks
  end
end
