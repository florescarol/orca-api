class CreateEarning < ActiveRecord::Migration[7.0]
  def change
    create_table :earnings do |t|
      t.string :name, null: false
      t.float :amount, null: false
      t.date :date, null: false

      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
