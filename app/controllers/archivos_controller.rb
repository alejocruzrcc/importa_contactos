class ArchivosController < ApplicationController
    def index
        if current_user
            @archivos = Archivo.all.paginate(page: params[:page], per_page: 10)
        else
            redirect_to home_path 
        end
    end
end
