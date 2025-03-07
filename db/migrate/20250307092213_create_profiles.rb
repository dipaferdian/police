class CreateProfiles < ActiveRecord::Migration[6.1]
  def up
    create_table :profiles do |t|
      t.references :officer, null: false, foreign_key: true
      t.string :status, null: false
      t.timestamps
    end
  end

  def down
    drop_table :profiles
  end
end
