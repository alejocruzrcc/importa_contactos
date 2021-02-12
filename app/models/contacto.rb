class Contacto < ApplicationRecord
    require 'csv'
    require "base64"

    belongs_to :user, class_name: 'User', foreign_key: 'usuario_id', optional: true
    belongs_to :archivo, class_name: 'Archivo', foreign_key: 'archivo_id', optional: true
    belongs_to :tcredito, class_name: 'Tcredito', foreign_key: 'tcredito_id', optional: true

    def self.import(file, user, archivo, columnas)
        fallidos= 0
        CSV.foreach(file.path, headers: true) do |row|
            errores = []
            contacto_hash = Contacto.new
            contacto_hash.archivo_id = archivo.id
            archivo.estado = "Procesando"
            contacto_hash.usuario_id = user.id
            nom = row[columnas[:nombre].to_i]
            if nom
                contacto_hash.nombre = nom
            else 
                errores.push("Campo nombre vacío")
            end
            fec = row[columnas[:fechanac].to_i]
            if fec
                if fec.include? "-"
                    fechanac =  Date.strptime(fec, '%F')
                elsif fec.length == 8
                    fechanac = Date.strptime(fec, '%Y%m%d')
                else
                    errores.push("Formato de fecha no válida")
                end
                contacto_hash.fechanac = fechanac
            else
                errores.push("Campo fecha vacío")
            end
            tel = row[columnas[:telefono].to_i]
            if tel
                
                if !tel.match(/\(\+\d{1,2}\)\s\d{3}\s\d{3}\s\d{2}\s\d{2}/).nil? || !tel.match(/\(\+\d{1,2}\)\s\d{3}\-\d{3}\-\d{2}\-\d{2}/).nil?
                    contacto_hash.telefono = tel
                else
                    errores.push("Campo teléfono en formato no aceptado. Debe ser (+00) 000 000 00 00 o también (+00) 000-000-00-00")
                end
            else
                errores.push("Campo teléfono vacío")
            end
            dir = row[columnas[:direccion].to_i]
            if dir
                contacto_hash.direccion = dir
            else
                errores.push("Campo teléfono vacío")
            end
            tc = row[columnas[:tcredito].to_i]
            fran_identificada = nil
            if tc
                detector = CreditCardDetector::Detector.new(tc)
                fran_identificada = detector.brand_name
                if !fran_identificada.nil?
                    tcredito = Tcredito.new
                    alfabeto = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                    codigo = alfabeto.split('').shuffle.join
                    tcredito.numero = tc.tr(alfabeto, codigo)
                    tcredito.franquicia = fran_identificada
                    tcredito.terminadaen = "TC terminada en " + tc.last(4)
                    if row[columnas[:franquicia].to_i] == fran_identificada
                        tcredito.franquicia = fran_identificada
                    else
                        errores.push("La franquicia de la Tarjeta de crédito no corresponde al numero")
                    end 
                    tcredito.save!
                    contacto_hash.tcredito_id = tcredito.id
                end
            else
                errores.push("Campo Tarjeta de credito vacío y franquicia inválida")
            end
            
            email = row[columnas[:email].to_i]
            if email
                unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
                    errores.push("No es un email válido")
                else 
                    contacto_hash.email = email
                end
                
            else
                errores.push("Campo email vacío")
            end
            
            if !errores.empty?
              contacto_hash.errores = errores.join(',')
              contacto_hash.valido = false
              fallidos += 1
            else
              contacto_hash.valido = true
            end
            contacto_hash.save!
            if fallidos == CSV.foreach(file.path, headers: true).count
              archivo.estado = "Fallido"
            elsif fallidos < CSV.foreach(file.path, headers: true).count
              archivo.estado = "Terminado"
            end
            
        end
        archivo.save!
    end
end
