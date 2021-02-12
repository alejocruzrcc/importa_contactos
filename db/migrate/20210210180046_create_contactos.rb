class CreateContactos < ActiveRecord::Migration[6.1]
  def change
    create_table :contactos do |t|
      t.string :nombre
      t.date :fechanac
      t.string :telefono
      t.string :direccion
      t.string :tcredito_id
      t.string :email
      t.integer :usuario_id
      t.timestamps
    end
    create_table :tcreditos do |t|
      t.string :numero
      t.string :franquicia
      t.string :terminadaen
      t.timestamps
    end
    add_foreign_key :contactos, :users, column: :usuario_id
    add_foreign_key :contactos, :tcreditos, column: :tcredito_id
  end
end
