class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :week, default: 0

      t.timestamps
    end
  end
end
