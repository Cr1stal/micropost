class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def index
    @microposts = Micropost.all
  end

  def show
    @images = @micropost.images.find(params[:id])
  end

  def new
    @micropost = Micropost.new
    @image = @micropost.images.build
  end


  def create
    #render plain: params[:micropost].inspect
    @micropost = current_user.microposts.build(micropost_params) # unless micropost_params.blank?
    if @micropost.save # && !@micropost.content.empty?
      @image = @micropost.images.create!(:file => @micropost.images, :micropost_id => @micropost.id)
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :tag_list, images_attributes: [:id, :micropost_id, :file])
      #params.require(:micropost).permit(:content, :name, :tag_list, :image) # [:id, :micropost_id, :file]:file, :name,
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end