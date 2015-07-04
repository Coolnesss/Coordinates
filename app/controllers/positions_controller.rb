class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy, :vote]

  def vote
    @position.increment!(:votes)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @position.votes }
    end
  end

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all
    @geojson = Array.new

    @points = Array.new
    @geojson << {
        type: 'FeatureCollection',
        features: @points
      }
    @positions.each do |position|
      @points << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [position.lon, position.lat]
        },
        properties: {
          id: position.id,
          name: position.name,
          description: position.description,
          votes: position.votes,
          date: position.date_format,
          images: position.picture_urls
        }
      }


    end
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
        if params[:images]
          params[:images].each { |image|
            @position.pictures.create(image: image)
          }
        end
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
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:lon, :lat, :name, :description, :email, pictures: [:image])
    end
end
