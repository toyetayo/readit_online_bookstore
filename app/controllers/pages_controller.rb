# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  before_action :set_page, only: %i[show contact about]

  def contact
    render :show
  end

  def about
    render :show
  end

  def show
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:id]) || Page.find_by(title: params[:action].capitalize)
    render_not_found unless @page
  end

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
