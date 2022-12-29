class CreateCategory < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :category_group, foreign_key: true

      t.timestamps
    end
  end
end
