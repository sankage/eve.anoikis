class TabsController < ApplicationController
  def create
    tab = current_user.tabs.build(tab_params)
    if tab.save
      flash["success"] = "Tab added."
    else
      falsh["error"] = "Tab was not added."
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    tab = current_user.tabs.find_by(id: params[:id])
    tab&.destroy
    redirect_back(fallback_location: root_path)
  end

  def switch
    current_user.tabs.update_all(active: false)
    tab = current_user.tabs.find_by(id: params[:id])
    tab&.update(active: true)
    redirect_back(fallback_location: root_path)
  end

  private

  def tab_params
    items = params.require(:tab).permit(:name, :solar_system)
    ss = SolarSystem.find_by(name: items[:solar_system])
    items[:solar_system_id] = ss.id
    items.delete(:solar_system)
    items
  end
end
