class NotesController < ApplicationController
  def create
    ss = SolarSystem.find_by(id: params[:solar_system_id])
    note = ss.notes.build(notes_params)
    note.pilot_id = current_user.id
    if note.save
      flash["success"] = "Note added to system."
    else
      flash["error"] = "Note wasn't added to system."
    end
    redirect_to solar_system_path(ss)
  end

  def destroy
    note = Note.find_by(id: params[:id])
    note.destroy
    flash["success"] = "Note has been deleted."
    redirect_to solar_system_path(note.solar_system_id)
  end

  private

  def notes_params
    params.require(:note).permit(:text)
  end
end
