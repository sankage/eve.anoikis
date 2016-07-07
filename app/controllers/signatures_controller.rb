class SignaturesController < ApplicationController
  def create
    solar_system = SolarSystem.find_by(system_id: params[:solar_system_id])
    signature = solar_system.signatures.build(sig_params)
    if signature.save
      flash[:success] = "Signature added."
    else
      flash[:error] = "Signature not added."
    end
    redirect_to solar_system
  end

  def batch_create
    solar_system = SolarSystem.find_by(system_id: params[:solar_system_id])
    solar = SystemObject.new(solar_system)
    Signature.create_from_collection(solar_system, params[:signatures])
    ActionCable.server.broadcast 'signatures',
      signatures: SignaturesController.render(partial: 'signatures/table_rows',
                                               locals: { system: solar })
    render json: { success: true }
  end

  def edit
    @signature = Signature.find_by(id: params[:id])
  end

  def update
    solar_system = SolarSystem.find_by(system_id: params[:solar_system_id])
    signature = Signature.find_by(id: params[:id])
    if signature.update(sig_params)
      ActionCable.server.broadcast 'signatures',
        signature_id: signature.id,
        signature: SignaturesController.render(partial: 'signatures/table_row',
                                                locals: { sig: signature })
    else
    end
    respond_to do |format|
      format.json { render json: { success: true } }
      format.html { redirect_to solar_system }
    end
  end

  def destroy
    sig = Signature.find_by(id: params[:id])
    sig.destroy
    redirect_to :back
  end

  private

  def sig_params
    params.require(:signature).permit(:sig_id, :type, :group, :name)
  end
end
