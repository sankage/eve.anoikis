class SignaturesController < ApplicationController
  def create
    system = SolarSystem.find_by(system_id: params[:solar_system_id])
    signature = system.signatures.build(sig_params)
    if signature.save
      flash[:success] = "Signature added."
    else
      flash[:error] = "Signature not added."
    end
    redirect_to system
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
