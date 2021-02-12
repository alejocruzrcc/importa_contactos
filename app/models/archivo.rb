class Archivo < ApplicationRecord
    has_many :contactos , dependent: :destroy
end
