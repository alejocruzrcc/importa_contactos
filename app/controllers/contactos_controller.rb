class ContactosController < ApplicationController
  
  def new
    if current_user
      @contacto = Contacto.new
    else
      redirect_to home_path 
    end
  end

  def index
    if current_user
      @contactos = Contacto.where(usuario_id: current_user.id, valido: true).paginate(page: params[:page], per_page: 10)
    else
      redirect_to home_path 
    end
  end

  def destroy
  end

  def create
    @archivo = Archivo.new
    @archivo.nombre = params[:contacto][:file].original_filename
    @archivo.estado = "En Espera"
    @archivo.save!
    @columnas = {nombre: params[:nombre], fechanac: params[:fechanac], telefono: params[:telefono], direccion: params[:direccion], tcredito: params[:tcredito], 
      franquicia: params[:franquicia], email: params[:email]}
    Contacto.import(params[:contacto][:file], current_user, @archivo, @columnas)
      flash[:notice] = "Contacts uploaded successfully"
      redirect_to contactos_path
  end

  def fallidos
    if current_user
      @contactosfallidos = Contacto.where(usuario_id: current_user.id, valido: false).paginate(page: params[:page], per_page: 10)
    else
      redirect_to home_path 
    end
  end
 


end
