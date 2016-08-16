class SignaturesController < ApplicationController
  before_action :signed_in_user

  def create
    solar_system = SolarSystem.find_by(id: params[:solar_system_id])
    signature = solar_system.signatures.build(sig_params)
    system_object = SystemObject.new(params[:solar_system_id], current_user)
    if signature.save
      signature.create_connections(solar_system)
      ActionCable.server.broadcast 'signatures',
        solar_system_id: system_object.system_id,
        type: :signatures,
        signatures: SignaturesController.render(partial: 'signatures/table_rows',
                                                 locals: { system: system_object }),
        system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                 locals: { solar_system: system_object })

      flash[:success] = "Signature added."
    else
      flash[:error] = "Signature not added."
    end

    respond_to do |format|
      format.json { render json: {
          solar_system_id: system_object.system_id,
          signature_id: signature.id,
          signature: SignaturesController.render(partial: 'signatures/table_row',
                                                  locals: { sig: signature }),
          system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                   locals: { solar_system: system_object })
        }
      }
      format.html { redirect_to solar_system }
    end
  end

  def batch_create
    Signature.create_from_collection(params[:solar_system_id],
                                     params[:signatures])
    solar_system = SystemObject.new(params[:solar_system_id], current_user)
    ActionCable.server.broadcast 'signatures',
      solar_system_id: system_object.system_id,
      type: :signatures,
      signatures: SignaturesController.render(partial: 'signatures/table_rows',
                                               locals: { system: solar_system }),
      system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                               locals: { solar_system: solar_system })
    render json: { success: true }
  end

  def edit
    @signature = Signature.find_by(id: params[:id])
  end

  def update
    solar_system = SolarSystem.find_by(id: params[:solar_system_id])
    system_object = SystemObject.new(params[:solar_system_id], current_user)
    signature = Signature.find_by(id: params[:id])
    # TODO: add ability to overwrite a sig based on sig_id
    if signature.update(sig_params)
      signature.create_connections(solar_system, connection_params)
      signature.update_connection_status(connection_status_params)

      ActionCable.server.broadcast 'signatures',
        solar_system_id: system_object.system_id,
        signature_id: signature.id,
        signature: SignaturesController.render(partial: 'signatures/table_row',
                                                locals: { sig: signature }),
        system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                 locals: { solar_system: system_object })
    end
    respond_to do |format|
      format.json { render json: {
          solar_system_id: system_object.system_id,
          signature_id: signature.id,
          signature: SignaturesController.render(partial: 'signatures/table_row',
                                                  locals: { sig: signature }),
          system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                   locals: { solar_system: system_object })
        }
      }
      format.html { redirect_to solar_system }
    end
  end

  def destroy
    sig = Signature.find_by(id: params[:id])
    sig.connection.destroy if sig.connection
    sig.destroy
    flash[:error] = "Signature deleted."

    system_object = SystemObject.new(sig.solar_system.id, current_user)
    ActionCable.server.broadcast 'signatures',
      solar_system_id: system_object.system_id,
      type: :signatures,
      signatures: SignaturesController.render(partial: 'signatures/table_rows',
                                               locals: { system: system_object }),
      system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                               locals: { solar_system: system_object })
    redirect_to sig.solar_system
  end

  private

  def sig_params
    sig_stuff = params.require(:signature).permit(:sig_id, :type, :group, :name)
    unless sig_stuff[:sig_id].nil?
      sig_stuff[:sig_id] = sig_stuff[:sig_id].upcase
      sig_stuff[:sig_id] = nil if sig_stuff[:sig_id].strip.empty?
    end
    sig_stuff
  end

  def connection_params
    return unless params[:connection]
    params.require(:connection).permit(:wh_type)
  end

  def connection_status_params
    return unless params[:connection_status]
    params.require(:connection_status).permit(:life, :mass)
  end
end
