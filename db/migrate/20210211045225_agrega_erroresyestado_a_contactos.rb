class AgregaErroresyestadoAContactos < ActiveRecord::Migration[6.1]
  def change
    add_column :contactos, :errores, :string
    add_column :contactos, :valido, :boolean
  end
end
