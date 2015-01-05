class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.belongs_to :organization, index: true
      t.boolean :paired, default: false
      t.boolean :attempted, default: false

      t.timestamps
    end
  end
end
