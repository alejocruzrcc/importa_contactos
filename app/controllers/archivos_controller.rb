class ArchivosController < ApplicationController
    def index
        @archivos = Archivo.all.paginate(page: params[:page], per_page: 10)
    end
end
