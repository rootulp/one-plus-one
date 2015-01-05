class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :partner1_id, index: true
      t.integer :partner2_id, index: true
      t.integer :week, default: 0

      t.timestamps
    end

    add_index :relationships, [:partner1_id, :week], unique: true
    add_index :relationships, [:partner2_id, :week], unique: true
  end
end
