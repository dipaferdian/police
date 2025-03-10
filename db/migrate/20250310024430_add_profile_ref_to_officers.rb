class AddProfileRefToOfficers < ActiveRecord::Migration[7.0]
  def up
    add_reference :officers, :profile, null: true, foreign_key: true
  end

  def down
    remove_reference :officers, :profile, foreign_key: true
  end
end
