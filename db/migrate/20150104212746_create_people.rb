class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.belongs_to :organization, index: true
      t.belongs_to :last_pair, class_name: 'Person'
      t.boolean :paired, default: false

      t.timestamps
    end
  end
end
