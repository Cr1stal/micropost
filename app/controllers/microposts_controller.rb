class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @microposts = Micropost.all
  end

  def show
    @images = @micropost.images.all
  end

  def new
    @micropost = Micropost.new
    @image = @micropost.images.build
  end


  def create
    @micropost = current_user.microposts.build(micropost_params) # unless micropost_params.blank?
    if @micropost.save # && !@micropost.content.empty?
      params[:images][:file].each do |f|
        @image = @micropost.images.create!(:file => f, :micropost_id => @micropost.id)
      end
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
      params.require(:micropost).permit(:content, :tag_list, images_attributes: [:id, :micropost_id, :file]) # :file, :name,
    end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end