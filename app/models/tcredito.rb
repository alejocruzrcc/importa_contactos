class Tcredito < ApplicationRecord
    has_many :contactos , dependent: :destroy
end
