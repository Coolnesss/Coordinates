class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy, :vote, :send_to_api]
  before_action :ensure_that_signed_in, except: [:index, :new, :create, :vote, :show]

  def vote
    @position.increment!(:votes)
    #@position.send_to_api
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @position.votes }
    end
  end

  def send_to_api
    respond_to do |format|
      if @position.send_to_api
        format.html { redirect_to root_path, notice: "Queued sending to API. This should be done soon." }
        format.json { render json: @position }
      else
        format.html {redirect_to root_path, notice: "Failed to send to API. Maybe position isn't in Helsinki?"}
        format.json {render json: @position }
      end
    end
  end

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all.order :id
    @geojson = Hash.new

    @points = Position.geopoints
    @geojson = {
        type: 'FeatureCollection',
        features: @points
    }

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)
    respond_to do |format|
      if @position.save
        @position.create_images(params[:images]) if params[:images]
        format.html { redirect_to @position, notice: 'Position was successfully created.' }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    update_helper(@position, position_params)
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    destroy_helper(@position)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:updates, :category, :fb_id, :lon, :lat, :name, :description, :email, pictures: [:image])
    end
end
