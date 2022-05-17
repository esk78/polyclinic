class CreateDoctorCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :doctor_categories do |t|
      t.string :name, index: { unique: true, name: 'unique_name' }

      t.timestamps
    end
  end
end
