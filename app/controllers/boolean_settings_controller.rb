class BooleanSettingsController < ApplicationController

  before_filter :authenticate_user!

  # GET /boolean_settings/1/edit
  def edit
    @boolean_setting = BooleanSetting.find(params[:id])
  end


  # PUT /boolean_settings/1
  # PUT /boolean_settings/1.json
  def update
    @boolean_setting = BooleanSetting.find(params[:id])

    boolean_setting = params[:boolean_setting]
    boolean_setting.delete(:key)

    respond_to do |format|
      if @boolean_setting.update_attributes( boolean_setting )
        format.html { redirect_to settings_path, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @boolean_setting.errors, status: :unprocessable_entity }
      end
    end
  end

end
