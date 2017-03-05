class ProductsController < ApplicationController

  before_action :set_product, only: [:edit, :update, :show, :destroy, :page]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.description = product_params[:description].open.read if product_params[:description].present?
    if @product.save
      flash[:success] = 'Product created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def show
    doc = Nokogiri::HTML.parse(@product.description)

    # filter ppc links
    # Start
    @ppc_links = doc.css("li.ads-ad h3 a")
    @ppc_links = @ppc_links.map { |link|  link}
    @ppc_links = @ppc_links - @ppc_links.map { |link|  link if %w{display:none}.include?link['style'] }
    # End

    # filter ppc links
    # Start
    @organic_links = doc.css(".med h3 a")
    @organic_links = @organic_links.map { |link|  link}
    @organic_links = @organic_links - @organic_links.map { |link|  link if %w{display:none}.include?link['style'] }
    # End
  end

  def page
    render layout: false
  end

  def destroy
    @product.destroy!
    flash[:success] = 'Successfully deleted'
    redirect_to action: :index
  end

  private

  def set_product
    @product = Product.find params[:id]
  end

  def product_params
    params.require(:product).permit(:title, :description)
  end


end