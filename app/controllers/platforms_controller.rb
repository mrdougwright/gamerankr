class PlatformsController < ApplicationController
  before_filter :load_platform, :only => [:show, :edit, :update, :destroy, :merge]
  before_filter :require_admin, :only => [:edit, :update, :destroy, :merge]
  
  def index
    @platforms = Platform.order('name').paginate :page => params[:page],
      :per_page => 100
  end
  
  def show
    @ports = @platform.ports.paginate :page => params[:page]
    get_rankings
    @aliases = @platform.platform_aliases
  end
  
  def generation
    @platforms = Platform.find_all_by_generation params[:generation], :limit => 100
    
    if @platforms.empty?
      flash[:error] = "Generation not found"
      redirect_to platforms_path
      return
    end
  end
  
  def edit
    @aliases = @platform.platform_aliases
    render :action => "edit"
  end
  
  def update
    if @platform.update_attributes(platform_params)
      flash[:notice] = "Updated"
      redirect_to @platform
      return
    end
    edit
  end
  
  def destroy
    @platform.destroy
    redirect_to platforms_path
  end
  
  def merge
    if request.post?
      @other_platform = Platform.find_by_name(params[:other_platform_name])
      if @other_platform
        @platform.merge(@other_platform)
        flash[:notice] = "Merged."
        redirect_to @platform
        return
      end
      flash.now[:error] = "platform not found"
    end
  end
  
  private
  
  def platform_params
    params.require(:platform).permit(:name, :released_at, :generation, :portable, :manufacturer_name, :description)
  end
end
