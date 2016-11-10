class SignaturesController < ApplicationController
  before_action :signed_in_user

  def create
    solar_system = SolarSystem.find_by(id: params[:solar_system_id])
    signature = solar_system.signatures.build(sig_params)
    system_object = SystemObject.new(params[:solar_system_id], current_user)
    if signature.save
      signature.create_connections(solar_system, connection_params)
      signature.update_connection_status(connection_status_params)
      broadcast_signatures(system_object)
      flash[:success] = "Signature added."
      json_object = {
          solar_system_id: system_object.id,
          type: :single_signature,
          signature_id: signature.id,
          signature: SignaturesController.render(partial: 'signatures/table_row',
                                                  locals: { sig: signature }),
          system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                   locals: { solar_system: system_object })
        }
    else
      flash[:error] = "Signature not added."
      json_object = {
        solar_system_id: system_object.id,
        type: :single_signature,
        errors: signature.errors.full_messages
      }
    end

    respond_to do |format|
      format.json { render json: json_object }
      format.html { redirect_to solar_system }
    end
  end

  def batch_create
    Signature.create_from_collection(params[:solar_system_id],
                                     params[:signatures])
    system_object = SystemObject.new(params[:solar_system_id], current_user)
    broadcast_signatures(system_object)
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
      broadcast_signatures(system_object)
      json_object = {
        solar_system_id: system_object.id,
        type: :single_signature,
        signature_id: signature.id,
        signature: SignaturesController.render(partial: 'signatures/table_row',
                                                locals: { sig: signature }),
        system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                 locals: { solar_system: system_object })
      }
    else
      json_object = {
        solar_system_id: system_object.id,
        type: :single_signature,
        errors: signature.errors.full_messages
      }
    end

    respond_to do |format|
      format.json { render json: json_object }
      format.html { redirect_to solar_system }
    end
  end

  def destroy
    signature = Signature.find_by(id: params[:id])
    signature.connection.destroy if signature.connection
    signature.destroy
    flash[:error] = "Signature deleted."

    system_object = SystemObject.new(signature.solar_system.id, current_user)
    broadcast_signatures(system_object)
    respond_to do |format|
      format.json { render json: {
          solar_system_id: system_object.id,
          type: :signature_removal,
          signature_id: signature.id,
          system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                                   locals: { solar_system: system_object })
        }
      }
      format.html { redirect_to solar_system }
    end
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
    params.require(:connection_status).permit(:life, :mass, :frigate_only, :flare)
  end

  def broadcast_signatures(system_object)
    ActionCable.server.broadcast 'signatures',
      solar_system_id: system_object.id,
      type: :signatures,
      signatures: SignaturesController.render(partial: 'signatures/table_rows',
                                               locals: { system: system_object }),
      system_map: SignaturesController.render(partial: 'solar_systems/connection_map',
                                               locals: { solar_system: system_object })
  end
end
