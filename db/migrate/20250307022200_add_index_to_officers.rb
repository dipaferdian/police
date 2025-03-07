class AddIndexToOfficers < ActiveRecord::Migration[7.0]
  def up
    add_index :officers, "LOWER(name)", where: "name IS NOT NULL", name: "index_officers_on_lower_name", unique: true
  end

  def down
    remove_index :officers, name: "index_officers_on_lower_name"
  end
end
