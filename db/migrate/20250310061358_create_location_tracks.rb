class CreateLocationTracks < ActiveRecord::Migration[7.0]
  def up
    create_table :location_tracks do |t|
      t.decimal :latitude, null: true, precision: 10, scale: 7
      t.decimal :longitude, null: true, precision: 10, scale: 7
      t.references :officer, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :location_tracks
  end
end
