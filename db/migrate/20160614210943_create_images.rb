class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :file
      t.references :micropost, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end