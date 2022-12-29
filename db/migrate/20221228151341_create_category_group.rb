class CreateCategoryGroup < ActiveRecord::Migration[7.0]
  def change
    create_table :category_groups do |t|
      t.string :title, null: false
      t.string :category_type, null: false
      t.string :color, default: ""

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
