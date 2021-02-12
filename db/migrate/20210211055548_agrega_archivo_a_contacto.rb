class AgregaArchivoAContacto < ActiveRecord::Migration[6.1]
  def change
    create_table :archivos do |t|
      t.string :nombre
      t.string :estado
      t.timestamps
    end
    add_column :contactos, :archivo_id, :integer
    add_foreign_key :contactos, :archivos, column: :archivo_id
  end
end
