class CreateDoctors < ActiveRecord::Migration[6.1]
  def change
    create_table :doctors do |t|
      t.references :users, null: false, foreign_key: true
      t.references :doctor_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
