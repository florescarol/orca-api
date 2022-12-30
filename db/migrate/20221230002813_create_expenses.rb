class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name, null: false
      t.float :amount, null: false
      t.bigint :first_installment_id, default: nil
      t.integer :installments_number, default: 1, null: false
      t.date :date, null: false
      t.date :payment_date, null: false

      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.references :payment_method, foreign_key: true

      t.timestamps
    end
  end
end
