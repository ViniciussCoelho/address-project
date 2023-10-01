class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.text :name
      t.text :cpf
      t.text :phone
      t.hstore :address

      t.timestamps
    end
  end
end
