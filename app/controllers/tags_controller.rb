class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all#.join(", ")
  end

  def show
    @tag =  ActsAsTaggableOn::Tag.find(params[:id])#.join(", ")
    @micropost = Micropost.tagged_with(@tag.name)
  end
end